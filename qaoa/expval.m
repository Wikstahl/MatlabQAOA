function [f,gradf] = expval(x,cost,p,q,s,X)
%     Calculate the expectation value f = ⟨γ,β|C|γ,β⟩, and the gradient of 
%     the expectation value.
%     
%     Parameters
%     ----------
%     x : 1-2p Array (row vector)
%         Array with angles [γ1 ... γp β1 ... βp]
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
%     f : float
%         Returns the expectation value of ⟨γ,β|C|γ,β⟩
%     
%     gradf : 1-2p Array (column vector)
%         Array with the computed gradient 
%         [∂f/∂γ1 ; ... ; ∂f/∂γp ; ∂f/∂β1 ; ... ; ∂f/∂βp]


% angles
gamma = x(1:p);
beta = x((p+1):2*p);

% state |γ,β⟩ = U(B,β_p)U(C,γ_p) ... U(B,β_1)U(C,γ_1)|+⟩
s = variational_state(cost,p,q,s,X,gamma,beta);

% calculate the expectation value f = ⟨γ,β|C|γ,β⟩
f = real(dot(s, cost .* s));

% gradient of the expectation value 
% NOTE: This part of the code could probably be optimized further
if nargout > 1 % gradient required and should be set to nargout > 1
    
    % computes 
    % gradf = [∂f/∂γ1 ; ... ; ∂f/∂γp ; ∂f/∂β1 ; ... ; ∂f/∂βp]
    % where 
    % ∂f/∂γn = -2Im(⟨γ,β|W^p_n·C·(W^p_n)^†·C|γ,β⟩) 
    % and
    % ∂f/∂βn = -2Im(⟨γ,β|W^p_n·U(C,γn)^†·B·U(C,γn)·(W^p_n)^†·C|γ,β⟩)
    % and 
    % W^p_n = U(B,βp)U(C,γp) ... U(B,βn)U(C,γn) with 1≤n≤p. 
    
    gradf = zeros(2*p,1); % allocate memory
    bra = conj(s); % "conjugate" = ⟨γ,β|
    ket = cost .* s; % C|γ,β⟩
    
    for n = p:-1:1 % count backwards
        
        for i = 1:q
            % ⟨γ,β|U(B,βn) = ⟨s| for n = 1
            bra = cos(beta(n)) * bra - 1j * sin(beta(n)) * kronm(X{i},bra);
            % U(B,βn)^†·C|γ,β⟩
            ket = cos(beta(n)) * ket  + 1j * sin(beta(n)) * kronm(X{i}, ket);
        end
        % ⟨γ,β|U(B,βn)·U(C,γn)
        bra = bra .* exp(-1j * gamma(n) * cost);
        % U(C,γn)^†·U(B,βn)^†·C|γ,β⟩
        ket = exp(1j * gamma(n) * cost) .* ket;
        
        % ∂f/∂γn = -2Im(⟨γ,β|W^p_n·C·(W^p_n)^†·C|γ,β⟩)
        gradf(n) = -2 * imag(bra.' * (cost .* ket));
        
        % ⟨γ,β|W^p_n·U(C,γn)^†
        left = bra .* exp(1j * gamma(n) * cost);        
        % U(C,γn)·(W^p_n)^†·C|γ,β⟩
        right = exp(-1j * gamma(n) * cost) .* ket;
        
        % Construct the operator B = Σ_j^n σ^j_x and apply it to the right
        B = zeros(2^q,1);
        for i = 1:q
            B = B + kronm(X{i}, right);
        end
        
        % ∂f/∂βn = -2Im(⟨γ,β|W^p_n·U(C,γn)^†·B·U(C,γn)·(W^p_n)^†·C|γ,β⟩)
        gradf(p+n) = -2 * imag(left.' * B);    
    end
end
end

