function result = nm(problem)
    % Nelder-Mead MVP
    nm.objective = problem.objective;
    nm.x0 = problem.x0;
    nm.solver = 'fminsearch';
    options = optimset('Display','iter' ...
        ,'PlotFcns',@optimplotfval ...
        ... Termination tolerance on the function value, (default) 1e-4
        ,'TolFun',1e-2 ...
        ... Termination tolerance on x, (default) 1e-4
        ,'TolX',1e-2 ...
        );
    nm.options = options;
    [xmin,fval,exitflag,output] = fminsearch(nm);
    result.xmin = xmin;
    result.fval = fval;
    result.exitflag = exitflag;
    result.output = output;
end

