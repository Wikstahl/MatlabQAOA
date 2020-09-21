%{
    Description: Simulates the quantum approximate optimization
    algorithm (QAOA).

    Developer: Pontus Vikstål
%}
addpath('qaoa')

% Eigenvalues of the Cost Hamiltonian given as a column vector
cost = [1;-1];
cost_min = min(cost); % Smallest eigenvalue

% Circuit depth
p = 1;
% Angles
gamma = [];
beta = [];
% Classical optimizer
minimizer = 'GlobalSearch';

%{
 Run the QAOA. Given the eigenvalues of the cost Hamiltonian, the iteration
 level p, a classical optimizer (optional), and starting point(s) for the
 classical optimizer (optional); The Code returns the variational state |γ,β⟩ 
 (final_state) using the best angles found by the classical optimizer. 
 The result from the classical optimizer is also returned as a struct. 
 If a non-empty array with angles is given as input, the classical 
 optimizier is not used and the final_state is computed using the 
 input angles, and the result is set to 0.
%}
[final_state,result] = qaoa(cost,p,gamma,beta,minimizer);

% Obtain the probability distribution by taking the absolute square |c_n|^2
% of each element of the final state vector |γ,β⟩.
probabilities = abs(final_state).^2;

% Calculates the expectation value ⟨γ,β|C|γ,β⟩. We take the real part
% to remove the small imaginary part due to machine inaccuracy.
exp_val = real(final_state' * (cost .* final_state));
fprintf('Expected value = %f \n',round(exp_val,2));

% Calculate the approximation ratio 
% r = (⟨γ,β|C|γ,β⟩ - C_max)/(C_min - C_max), 0 ≤ r ≤ 1
cost_max = max(cost);
approx_ratio = (exp_val-cost_max)/(cost_min - cost_max);
fprintf('Approximation ratio = %f \n',round(approx_ratio,2));

% Print the probability of obtaining the optimal solution.
z = find(cost == cost_min); % In case of the ground state being degenerate
fidelity = sum(probabilities(z));
fprintf('Success probability = %f %%\n',round(fidelity*100,2));

rmpath('qaoa')