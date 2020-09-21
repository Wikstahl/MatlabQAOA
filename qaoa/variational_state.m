function [s] = variational_state(cost,p,q,s,X,gamma,beta)
%     Constructs the variational quantum state |γ,β⟩
%     
%     Parameters
%     ----------
%     gamma: 1-p Array (row vector)
%         Array with angles [γ1 ... γp]
% 
%     beta: 1-p Array (row vector)
%         Array with angles [β1 ... βp]
%
%     cost : 1-D array (column vector) containing all the values of the cost
%           function.
%
%     p : integer
%         The number of iterations.
% 
%     q : integer
%         The number of qubits.
% 
%     s : 1-D array (column vector)
%         initial state vector |+⟩ = H^(⊗N)·|0⟩⊗|0⟩⊗...⊗|0⟩
%     
%     X : 1-q cell
%         Reduced Pauli sigma-x matrices
%    
%     Returns
%     -------
%     s : 1-2^n Array (column vector)
%         Returns the state vector |γ,β⟩.


% Final state |γ,β⟩ = U(B,β_p)U(C,γ_p) ... U(B,β_1)U(C,γ_1)|s⟩
for i = 1:p
    % |s⟩ = U(C,γ_i)·|s⟩
    % Hadamard product, in other words, we do an entrywise product, since
    % the Hamiltonian is diagonal.
    s = exp(-1j * gamma(i) * cost) .* s;
    
    % |s⟩ = U(B,β_i)*|s⟩
    for j = 1:q
        % Construct the rotation matrix and apply it to the state vector.
        % Use fast Kronecker matrix multiplication for matrices
        s = cos(beta(i)) * s - 1j * sin(beta(i)) * kronm(X{j},s);
    end
end
end
