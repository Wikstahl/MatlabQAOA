
% Example
% Remember |-1/2> -> |0> -> 0
%          |1/2>-> |1> -> 1
%{
clc;clear
S = {[0,1,2,3,4,5,6],[1,2,3,5]};
U = [0,1,2,3,4,5,6];


A = [1 0;
     1 1;
     1 0];
[problem,J,h,eigvals] = exactproblem(A);
%}
function [problem,J,h,c,eigvals] = exactproblem(A)
%EXACTPROBLEM creates a problem structure of the exact cover problem
%   Input: 
%   A: m-n Matrix, representing the problem 
%
%   Returns:
%   problem: Problem structure for the exact cover problem
%
%   J: n-n matrix representing the couplings
%
%   h: n-1 vector representing the magnetic fields
%
%   eigvals: eigenvalues of the Hamiltonian

problem.Aeq = A;
problem.lb = zeros(size(A,1),1);
problem.ub = ones(size(A,1),1);
problem.beq = ones(size(A,2),1);

K = A;
v = size(K,2); % number of subsets
J = zeros(v,v); % couplings
h = zeros(v,1); % magnetic fields

% Coupling matrix
for i = 1:v
    for j = 1:v
        J(i,j) = 1/2 * sum(K(:,i) .* K(:,j));
    end
end

% Magnetic field vector
for i = 1:v
    h(i) = sum(K(:,i)) - 1/2 * sum(K .* K(:,i), 'all');
end

% Constant
c = 1/4 * sum((sum(K,2) - 2).^2) + 1/2 * trace(J);

%{
% Pauli-Z
sigma_z = [ 1;
           -1]; 
% Construct all possible Pauli-Z matrices
Z = cell(1,v);
for i = 1:v
    Z{i} = kron(ones(2^(i-1),1),kron(sigma_z,ones(2^(v-i),1)));
end

% Hamiltonian
H = zeros(2^v,1);

% J[i][j] terms
for i = 1:(v-1)
    L = 0;
    for j = (i+1):v
        L = L + J(i,j) * (Z{i} .* Z{j});
    end
    H = H + L;
end

% h[i] terms
for i = 1:v
    H = H + h(i) * Z{i};
end

% constant term
H = H + ones(2^v,1) * c;

eigvals = H;
%}
% Construct all possible solutions
smat = dec2bin(0:2^v-1)-'0';
smat = sum((smat*A'-1).^2, 2);
eigvals = smat;

end

