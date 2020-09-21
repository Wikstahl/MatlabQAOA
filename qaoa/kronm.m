function x = kronm(Q,x)
% Fast Kronecker matrix multiplication. 
% Never computes the actual Kronecker matrix and omits
% multiplication by identity matrices.
% https://math.stackexchange.com/questions/3175653/how-to-efficiently-compute-the-matrix-vector-product-y-i-p-otimes-a-otimes

L = Q{1}; % LEFT
M = Q{2}; % MIDDLE
R = Q{3}; % RIGHT

% rearrange x to 2-by-LR
x = reshape(permute(reshape(x,[R,2,L]),[2,1,3]),[2,L*R]);

% actual multiplication: just of size 2
x = M*x;
% rearrange back the reshult
x = reshape(x,[2,R,L]);
x = ipermute(x,[2,1,3]);
x = x(:);
end