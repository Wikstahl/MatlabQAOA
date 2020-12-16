classdef qaoa < matlab.System

    % Attributes
    properties
        % Default Variables
        cost;
        
        Steps = 1;
        
        Minimizer {mustBeMember(Minimizer,...
        {'GlobalSearch',...
        'MultiStart',...
        'Bayesian',...
        'Nelder-Mead',...
        'BruteForce'})}...
        = 'GlobalSearch';
    
        MinimOptions;
        
        OptimOptions;
    end

    properties(Dependent,Hidden)
        qubits;
        dimensions;
        initial_state;
    end

    methods
        %% Getters
        function qubits = get.qubits(self)
           qubits = log2(length(self.cost));
        end
        
        function dimensions = get.dimensions(self)
            dimensions = length(self.cost);
        end
        
        function initial_state = get.initial_state(self)
            initial_state = 1 / sqrt(self.dimensions) * ones(self.dimensions,1);
        end      

        %% Constructor
        function self = qaoa(cost, varargin)
            self.cost = cost;
            if nargin > 1
                % Convert string arrays to character arrays
                [varargin{:}] = convertStringsToChars(varargin{:});
                setProperties(self,length(varargin),varargin{:});
            end
            if isempty(self.gamma) && isempty(self.beta)
                self.gamma = pi * rand(1,self.Steps);
                self.beta = pi * rand(1,self.Steps);
            end
        end

        function result = qaoa_optimize(self, steps, minimizer, minim_options, optim_options)
            %Optimize
            % 
            Optimizer(steps, minimizer, minim_options, optim_options)
           
            
            % Create problem structure
            problem = struct();
            problem.lb = zeros(2*p,1); % lower bounds
            problem.ub = pi * ones(2*p,1); % upper bounds
            problem.x0 = self.x0; % initial points
            problem.objective = @(x)expval(x,self); % objective function

            addpath('qaoa/optimization')
            if ~exist('minimizer','var') || strcmp(minimizer,'GlobalSearch')
                result = gs(problem);
                xmin = result.xmin;
            elseif strcmp(minimizer,'MultiStart')
                result = ms(problem);
                xmin = result.xmin;
            elseif strcmp(minimizer,'Bayesian')
                result = bso(problem);
                xmin = result.XAtMinObjective{1,:};
            elseif strcmp(minimizer,'BruteForce')
                result = brute(problem);
                xmin = result.xmin;
            elseif strcmp(minimizer,'NelderMead')
                result = nm(problem);
                xmin = result.xmin;
            elseif strcmp(minimizer,'ParticleSwarm')
                result = pso(problem);
                xmin = result.xmin;
            end
            
        end

        function [f] = expval(x,self)
            %     Calculate the expectation value f = ⟨γ,β|C|γ,β⟩, and the
            %     gradient of the expectation value.
            %
            %     Returns
            %     -------
            %     f : float
            %         Returns the expectation value of ⟨γ,β|C|γ,β⟩


            % variational parameters
            self.gamma = x(1:self.Steps);
            self.beta = x((self.Steps+1):2*self.Steps);

            % state |γ,β⟩ = U(B,β_p)U(C,γ_p) ... U(B,β_1)U(C,γ_1)|+⟩
            var_state = variational_state(self);

            % calculate the expectation value f = ⟨γ,β|C|γ,β⟩
            f = real(dot(var_state, self.cost .* var_state));
        end

        function [s] = variational_state(self,gamma,beta)
            %     Constructs the variational quantum state |γ,β⟩
            %
            %     Returns
            %     -------
            %     var_state : 1-2^n Array (column vector)
            %         Returns the state vector |γ,β⟩.
            
            s = self.initial_state;
            % Final state |γ,β⟩ = U(B,β_p)U(C,γ_p) ... U(B,β_1)U(C,γ_1)|s⟩
            for i = 1:self.Steps
                % |s⟩ = U(C,γ_i)·|s⟩
                % Hadamard product, in other words, we do an entrywise product, since
                % the Hamiltonian is diagonal.
                s = exp(-1j * self.gamma(i) * self.cost) .* s;

                % |s⟩ = U(B,β_i)*|s⟩
                for j = 1:self.qubits
                    % Construct the rotation matrix and apply it to the state vector.
                    % Use fast Kronecker matrix multiplication for matrices
                    % Copyright (c) 2015, Matthias Kredler https://goo.gl/D8jyMw
                    s = cos(self.beta(i)) * s ...
                        - 1j * sin(self.beta(i)) * kronm(self.sigmaX{j},s);
                end
            end
        end
    end
end
