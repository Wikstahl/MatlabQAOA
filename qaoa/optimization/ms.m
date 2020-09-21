function result = ms(problem)
    %{
    MULTI START
    
    Description
    ----------
    Multistart attempts to find multiple local minimas to the function 
    by starting from various points.  It distributes start points to 
    multiple processors for local solution.  It returns the local
    solution where the function has its minimum value.
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
    
    ms = MultiStart('UseParallel',true);
    rs = CustomStartPointSet(problem.x0);
    %stpoints = CustomStartPointSet(list(rs,problem));
    stpoints = CustomStartPointSet(problem.x0);
    problem.x0 = problem.x0(1,:);
    [xmin,fval,exitflag,output,solutions] = run(ms,problem,stpoints);
    
    result.xmin = xmin;
    result.fval = fval;
    result.exitflag = exitflag;
    result.output = output;
    result.solutions = solutions;
end

