function [x0] = interpolation(x0)
%{
    INTERPOLATION-BASED STRATEGY

    Description
    -----------
    Uses linear interpolation to produce a good starting point
    for optimizing QAOA as one iteratively increases the
    level p.

    Parameters
    ----------
    opt : 1-2(p-1) array (row vector)
         Optimal angels for level p-1

    Returns
    -------
    x0 : 2-p array (row vector) 
         Starting-points for level p.
%}

% declare variabels
p = length(x0)/2;
gamma_opt = x0(1:p);
beta_opt = x0((p+1):2*p);
gamma0 = zeros(1,p);
beta0 = zeros(1,p);

% gamma0 and beta0
for j = 1:(p+1)
    if j == 1
        gamma0(j) = (p-j+1)/p * gamma_opt(j);
        beta0(j) = (p-j+1)/p * beta_opt(j);
    elseif j == (p+1)
        gamma0(j) = (j-1)/p * gamma_opt(j-1);
        beta0(j) = (j-1)/p * beta_opt(j-1);
    else
        gamma0(j) = (j-1)/p * gamma_opt(j-1) + (p-j+1)/p * gamma_opt(j);
        beta0(j) = (j-1)/p * beta_opt(j-1) + (p-j+1)/p * beta_opt(j);
    end 
end

x0 = [gamma0, beta0];
end

