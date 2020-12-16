classdef optimizer < qaoa

    % Attributes
    properties        
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

    end

    methods
        %% Getters

        %% Constructor
        function self = qaoa(cost, varargin)
        
        end

        function result = qaoa_optimize(self, Minimizer)
            %Optimize
            % 
            
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

    end
end
