function [xmin,fval] = bruteforce(func,ranges)
%     Minimize a function over a given range by brute force.
% 
%     Uses the "brute force" method, i.e. computes the function's value
%     at each point of a multidimensional grid of points, to find the global
%     minimum of the function.
% 
%     Parameters
%     ----------
%     func: @(x,y,...)
%         The objective function to be minimized
% 
%     ranges: cell
%         The program uses these to create the grid of points
%         on which the objective function will be computed.
% 
%     Returns
%     -------
%     x0 : array
%         A 1-D array containing the coordinates of a point at which the
%         objective function has its minimum value.


if iscell(ranges) == 0
    error('Ranges must be in cell format.')
end

% Number of parameters to optimize.
N = length(ranges);

% Create a 1xN cell array
grid = cell(1,N);

% Fill each cell array with grid points
[grid{:}] = ndgrid(ranges{:});

% Concatenate and reshape the grid
grid = reshape(cat(N,grid{:}),[],N);

% Size of grid
Nsize = size(grid);

% Allocate memory
fgrid = ones(1,Nsize(1));

% Function values at each point of the evaluation grid
parfor i = 1:Nsize(1)
    fgrid(i) = func(grid(i,:));
end

% Find global minimum
[fval, idx] = min(fgrid);

% Grid point where the function has its global minimum
xmin = grid(idx,:);

if N/2 == 1
    % Make a 3D plot of func only if p = 1
    X = ranges{1};
    Y = ranges{2};
    Z = reshape(fgrid,length(X),length(Y));
    f = figure('Renderer', 'painters', 'Position', [0 0 1500 600]);
    movegui(f,'center')
    subplot(1,2,1)
    %make here your first plot
    surf(X,Y,Z,'EdgeColor','none')
    colormap jet % color
    
    xlabel('$\gamma$','Interpreter','latex')
    ylabel('$\beta$','Interpreter','latex')
    zlabel('$F_1(\gamma,\beta)$','Interpreter','latex')
    set(gca, 'FontSize', 20);
    
    subplot(1,2,2)
    %make here your second plot
    imagesc(X,Y,Z)
    %contourf(X,Y,Z)
    colorbar
    
    xlabel('$\gamma$','Interpreter','latex','FontSize',50)
    ylabel('$\beta$','Interpreter','latex','FontSize',50)
    zlabel('$F_1(\gamma,\beta)$','Interpreter','latex')
    set(gca, 'FontSize', 30); 
    set(gca,'YDir','normal'); % coord (0,0) at origin
    
    
    savefig('bruteforce.fig')
end

end
