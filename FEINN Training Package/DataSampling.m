function xIn = DataSampling(problem,Funcname)
switch Funcname
    case '10bars'
        d = 10;
        LB = ones(1,d)*0.1;
        UB = ones(1,d)*33.5;
        NumDat = size(problem.xTrain,2);
        xIn = rand(NumDat,d).*(UB - LB) + LB;
        xIn = (xIn')/UB(1);
    case '72bars'
        dimA = 16;
        dimF = 60;
        LB = ones(1,dimA)*0.1; UB = ones(1,dimA)*3.2;
        LBF = ones(1,dimF)*1000; UBF = ones(1,dimF)*10000;
        NumDat = size(problem.xTrain,2);
        Atrial = rand(NumDat,dimA).*(UB - LB) + LB;
        Ftrial = rand(NumDat,dimF).*(UBF - LBF) + LBF;
        xIn = [Atrial Ftrial];
        xIn = (xIn')/UB(1);
    case 'F09'
        d = 3; %dimension
        LB(1) = 1; LB(2) = -100; LB(3) = 10;
        UB(1) = 30; UB(2) = -10000; UB(3) = 1000;
        NumDat = size(problem.xTrain,2);
        xIn = rand(NumDat,d).*(UB - LB) + LB;
        xIn = (xIn')/1000;
    case 'EBBeam'
        d = 3; %dimension
        LB(1) = 1; LB(2) = -100; LB(3) = 10;
        UB(1) = 30; UB(2) = -10000; UB(3) = 1000;
        NumDat = size(problem.xTrain,2);
        xIn = rand(NumDat,d).*(UB - LB) + LB;
        xIn = (xIn')/1000;
    case 'CPB'
        d = 3; %dimension
        LB(1) = 0.01; LB(2) = 1; LB(3) = -10;
        UB(1) = 0.1; UB(2) = 10; UB(3) = 10;
        NumDat = size(problem.xTrain,2);
        xIn = rand(NumDat,d).*(UB - LB) + LB;
        xIn = (xIn')/1000;
end