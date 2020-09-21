function result = brute(problem)
    %{
    BRUTE FORCE METHOD
    
    Description
    ----------
    Bruteforce creates a grid given by the variable ranges and evaluates
    the function for all these grid points and then selects the grid point
    where the function has its minimum value.

    Note
    ----------
    This algorithm is very slow for p larger than one.
    %}
    
    p = length(problem.x0)/2;
    fun = problem.objective;

    steps = 200; % This determines the size of the grid
    gamma_vec = linspace(0,pi,steps);
    beta_vec = linspace(0,pi,steps);
    ranges = [repmat({gamma_vec},1,p) repmat({beta_vec},1,p)];
    [xmin,fval] = bruteforce(fun,ranges);
    result.xmin = xmin;
    result.fval = fval;
end

