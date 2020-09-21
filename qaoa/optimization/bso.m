function result = bso(problem)
%{     
    BAYESIAN OPTIMIZATION
    
    Description
    ----------
    To perform a Bayesian optimization using bayesopt, follow these steps.

    1. Prepare your variables.  See Variables for a Bayesian Optimization.
    https://se.mathworks.com/help/stats/variables-for-a-bayesian-optimization.html

    2. Create your objective function.  See Bayesian Optimization Objective 
    Functions.  If necessary, create constraints, too.  See Constraints in 
    Bayesian Optimization.
    https://se.mathworks.com/help/stats/bayesian-optimization-objective-functions.html

    3. Decide on options, meaning the bayseopt Name, Value pairs. You are  
    not required to pass any options to bayesopt but you typically do, 
    especially when trying to improve a solution.

    4. Call bayesopt.
    https://se.mathworks.com/help/stats/bayesopt.html

    Examine the solution. You can decide to resume the optimization by using 
    resume, or restart the optimization, usually with modified options.
    %}

    % 1. For each variable in your objective function, create a variable 
    % description object using optimizableVariable.  Each variable has a 
    % unique name and a range of values
    x0 = problem.x0;
    p = size(x0,2)/2;
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
    initial_x = table(); % create an empty table
    for i = 1:2*p
        initial_x = addvars(initial_x,x0(:,i),'NewVariableNames',varnames{i});
    end

    % 3. Decide on options, meaning the bayseopt.
    result = bayesopt(@objfun,vars ...
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

    result

% 2. Create your objective function
% The objective function has the following signature:
function fval = objfun(in)
    x = in.Variables;
    fval = fun(x);
end
end
