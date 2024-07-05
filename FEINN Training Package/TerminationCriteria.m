function problem = TerminationCriteria(problem)
M = size(problem.yTrain,2);
if (M == 100) || (M == 1000)
    if strcmp(problem.Funcname, '10bars')
        problem.DOFprescribed = [9 10 11 12];
        problem.R2AvgThreshold = 0.87;
        problem.BoundErrThreshold = 5e-4;
    elseif strcmp(problem.Funcname, '72bars')
        problem.DOFprescribed = linspace(1,12,12);
        problem.R2AvgThreshold = 0.85;
        problem.BoundErrThreshold = 5e-4;
    elseif strcmp(problem.Funcname, 'EBBeam')
        problem.DOFprescribed = [1 2 103];
        problem.R2AvgThreshold = 0.93;
        problem.BoundErrThreshold = 5e-4;
    elseif strcmp(problem.Funcname, 'CPB')
        gridx = linspace(0,1,11);
        gridy = linspace(0,1,11);
        [coordinates, ~] = Rectangles_Mesh(gridx,gridy);
        typeBC = 'ss-ss-ss-ss' ;        % Boundary Condition type
        bcdof = BoundaryCondition(typeBC,coordinates) ;
        problem.DOFprescribed = bcdof;
        problem.R2AvgThreshold = 0.99;
        problem.BoundErrThreshold = 1e-2;
    end
elseif M > 1000
    if strcmp(problem.Funcname, '10bars')
        problem.DOFprescribed = [9 10 11 12];
        problem.R2AvgThreshold = 0.95;
        problem.BoundErrThreshold = 1e-4;
    elseif strcmp(problem.Funcname, '72bars')
        problem.DOFprescribed = linspace(1,12,12);
        problem.R2AvgThreshold = 0.97;
        problem.BoundErrThreshold = 1e-4;
    elseif strcmp(problem.Funcname, 'EBBeam')
        problem.DOFprescribed = [1 2 103];
        problem.R2AvgThreshold = 0.99;
        problem.BoundErrThreshold = 1e-4;
    elseif strcmp(problem.Funcname, 'CPB')
        gridx = linspace(0,1,11);
        gridy = linspace(0,1,11);
        [coordinates, ~] = Rectangles_Mesh(gridx,gridy);
        typeBC = 'ss-ss-ss-ss' ;        % Boundary Condition type
        bcdof = BoundaryCondition(typeBC,coordinates) ;
        problem.DOFprescribed = bcdof;
        problem.R2AvgThreshold = 0.99;
        problem.BoundErrThreshold = 1e-2;
    end
end