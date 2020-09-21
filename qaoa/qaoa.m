function [final_state,result] = qaoa(cost,p,gamma,beta,minimizer,x0)
%
%     Quantum Approximate Optimization Algorithm.
% 
%     Parameters
%     ----------
%     cost : 1-D array (column vector) containing all the values of the cost
%           function.
% 
%     p : integer
%         The number of iterations.
% 
%     gamma : Either an empty or 1-p array (row vector) containing the 
%             optimal angles. (optional)
% 
%     beta : Either an empty or 1-p array (row vector) containing the 
%            optimal angles. (optional)
% 
%     minimizer : string (optional)
%                 Optimization algorithm 'GlobalSearch' (default), 
%                 'MultiStart', 'Bayesian', BayesianHybridNelderMead, 
%                 'NelderMead','ParticleSwarm','BruteForce'.
%
%     x0 : 1-2p array (row vector) (optional)
%          Starting-points for level p.
% 
%     Returns
%     -------
%     final_state : 1-D array (column vector)
%         Returns the state vector |γ,β⟩
% 
%     result : struct with fields
%         The result from the minimizer
%
%

% if no variational parameters are given simply set them as empty arrays.
if (~exist('gamma', 'var') && ~exist('beta', 'var'))
    gamma = []; beta = [];
end

if ~exist('minimizer', 'var') 
    minimizer = 'GlobalSearch';
end

% declare variables
q = log2(length(cost)); % Number of qubits required
sigma_x = [0 1;1 0]; % Pauli sigma-x matrix

X = cell(1,q);
for i = 1:q
    % Creates the i:th Palui sigma-x matrix and stores it in a cell.
    X{i} = {2^(i-1),sigma_x,2^(q-i)};
end

% Construct the initial state vector |+⟩ = H^(⊗N)·|0⟩⊗|0⟩⊗...⊗|0⟩
s = 1 / sqrt(2^q) * ones(2^q,1);

if size(gamma) ~= size(beta)
    % Check if gamma and beta are arrays of equal size.
    error('The arrays gamma and beta must be of equal size.')

elseif isempty(gamma) == 1
    % If gamma and beta are empty arrays find the optimal angles.
    if ~exist('x0', 'var') 
        x0 = pi * rand(1,2*p); % random start-point;
    end
    
    % Create problem structure
    problem = struct();
    problem.lb = zeros(2*p,1); % lower bounds
    problem.ub = pi * ones(2*p,1); % upper bounds
    problem.x0 = x0; % initial points
    problem.objective = @(x)expval(x,cost,p,q,s,X); % objective function
 
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
    elseif strcmp(minimizer,'BayesianHybridNelderMead')
        result = baynm(problem);
        xmin = result.xmin;
    elseif strcmp(minimizer,'ParticleSwarm')
        result = pso(problem);
        xmin = result.xmin;
    end
    
    % The found optimal angles.  
    gamma = xmin(1:p);
    beta = xmin((p+1):2*p);
    
elseif size(gamma) ~= p
    % If gamma and beta are given by nonempty arrays verify that they have
    % correct dimensions, i.e. that they are equal to p.
    error('The number of total angles must be equal to 2p.')
else
    result = 0;
end

% Final state |γ,β⟩ = U(B,β_p)U(C,γ_p)···U(B,β_1)U(C,γ_1)|s⟩
final_state = variational_state(cost,p,q,s,X,gamma,beta);
