function result = baynm(problem)

    % Combination of Bayesian Optimization and Nelder Mead
    x0 = problem.x0;
    p = length(problem.lb)/2;
    fun = problem.objective;
    
    vars = [];
    varnames = {1,2*p};
    
    for i = 1:p
        name = strcat('gamma',int2str(i));
        optvar = optimizableVariable(name,[0 pi]);
        vars = [vars,optvar]; % vector with optimizableVariable objects
        varnames{i} = name;
    end
    for i = (p+1):2*p
        name = strcat('beta',int2str(i-p));
        optvar = optimizableVariable(name,[0 pi]);
        vars = [vars,optvar]; % vector with optimizableVariable objects
        varnames{i} = name;
    end

    % Initial evaluation points, specified as an N-by-D table, where N is 
    % the number of evaluation points, and D is the number of variables.
    initial_x = array2table(x0,'VariableNames',varnames);

    % 3. Decide on options, meaning the bayseopt.
    results = bayesopt(@objfun,vars ...
    ... Function to choose next evaluation point
    ... 'expected-improvement-per-second-plus' (default) 
        ,'AcquisitionFunctionName','expected-improvement' ...
    ... If fun is stochastic, false (default) | true
        ,'IsObjectiveDeterministic',true ...
    ... Propensity to explore, 0.5 (default) | positive real
        ,'ExplorationRatio',.5 ...
    ... Fit Gaussian Process model, 300 (default)
        ,'GPActiveSetSize',300 ...
    ... ObjFun evaluation limit, 30 (default) | positive integer
        ,'MaxObjectiveEvaluations',30 ... 
    ... Compute in parallel, false (default) | true
        ,'UseParallel',true ...
    ... Imputation method for parallel worker objective function values
    ... 'clipped-model-prediction' (default)
        ,'ParallelMethod','min-observed' ...
    ... Number of initial evaluation points, 4 (default) | positive integer
        ,'NumSeedPoints',size(x0,1) ...
    ... Command line display, 1 (default)
        ,'Verbose',1 ...
    ... Initial evaluation points
        ,'InitialX',initial_x ...
    ... Plot functi on called after each iteration 
    ... {@plotObjectiveModel,@plotMinObjective} (default)
        ,'PlotFcn',{@plotObjectiveModel,@plotMinObjective} ...
    ... Function called after each iteration, {} (default)
        ... ,'OutputFcn',{@assignInBase,@saveToFile} ...
    ... File name for the @saveToFile output function
        ... ,'SaveFileName','optimizations/test.mat' ...
    ... Variable name for the @assignInBase output function
        ... ,'SaveVariableName','Results' ...
    );
    xmin = results.XAtMinObjective{1,:};
    
    nm.objective = problem.objective;
    nm.x0 = xmin;
    nm.solver = 'fminsearch';
    options = optimset('Display','final' ...
        ,'PlotFcns',@optimplotfval ...
        ... Termination tolerance on the function value, (default) 1e-4
        ,'TolFun',1e-6 ...
        ... Termination tolerance on x, (default) 1e-4
        ,'TolX',1e-6 ...
        ... Maximum number of iterations allowed, (default) 200*numberOfVariables
        ,'MaxIter',100 ...
        ... Maximum number of function evaluations, (default) 200*numberOfVariables
        ,'MaxFunEvals',100*p ...
        );
    nm.options = options;
    [xmin,fval,exitflag,output] = fminsearch(nm);
    
    result.xmin = xmin;
    result.fval = fval;
    result.exitflag = exitflag;
    result.output = output;
    
    % 2. Create your objective function
    % The objective function has the following signature:
    function fval = objfun(in)
        x = in.Variables;
        fval = fun(x);
    end
end

