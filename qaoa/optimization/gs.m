function result = gs(problem)
 %{
    GLOBAL SEARCH METHOD (Default)
    
    Description
    ----------
    GlobalSearch uses a scatter-search mechanism for generating start
    points.  GlobalSearch analyzes start points and rejects those points
    that are unlikely to improve the best local minimum found so far.
    %}


    % Create options, see following link for possible options
    % https://se.mathworks.com/help/optim/ug/fmincon.html
    opts = optimoptions(...
    ... Solver https://se.mathworks.com/help/optim/ug/fmincon.html
        @fmincon...
    ... Optimization algorithm, 'interior-point' (default)
    ... https://se.mathworks.com/help/optim/ug/choosing-the-algorithm.html
        ,'Algorithm','trust-region-reflective' ...
    ... Displays output at each iteration, 'final' (default)
        ,'Display','final' ...
    ... Termination tolerance on x, 1e-6 (default) | 1e-10 (interior-point)
        ,'StepTolerance',1e-3 ...
    ... Termination tolerance on the function value, 1e-6 (default) 
        ,'FunctionTolerance',1e-3 ...
    ... Max number of iterations, 400 (default) | 1000 (interrior-point)
        ,'MaxIterations',400 ...
    ... Maximum number of function evaluations allowed, 
    ... 100*numberOfVariables (default) | 3000 (interrior-point)
        ...,'MaxFunctionEvaluations',100 ... 
    ... Gradient for the objective function, false (default)
        ,'SpecifyObjectiveGradient',true ...
    ... Compare user-supplied derivatives to finite-differencing 
    ... derivatives, false (default) | true
        ,'CheckGradients',false ...
    ... Finite differences, used to estimate gradients 
    ... 'forward' (default) | 'central'
        ,'FiniteDifferenceType','central' ...
    ... Scalar or vector step size factor for finite differences
        ,'FiniteDifferenceStepSize',1e-6 ...
    ... When true, fmincon estimates gradients in parallel, false (default)
        ,'UseParallel',true ...
    );
    
    problem.solver = 'fmincon';
    problem.options = opts;

    gs = GlobalSearch();
    gs.NumTrialPoints = 1e3; % Number of random seeds (starting points)
    
    [xmin,fval,exitflag,output,solutions] = run(gs,problem);
    
    result.xmin = xmin;
    result.fval = fval;
    result.exitflag = exitflag;
    result.output = output;
    result.solutions = solutions;
end

