function nn = PenaltyCoef(problem, nn, PhysPenType)
nn.PhysPenType = PhysPenType;
nn.MSEpenalty = 1;
switch PhysPenType
    case 'fixed'
        switch problem.Funcname
            case '10bars'
                nn.Physpenalty = 1.2787e+03;
            case '72bars'
                nn.Physpenalty = 91.1323;
            case 'EBBeam'
                nn.Physpenalty = 1;
            case 'CPB'
                nn.Physpenalty = 19.8622;
        end
    case 'dynamic'
        nn.Physpenalty = 0;
        nn.LastPhysPen = 50;
        nn.MaxPhysPen = 50;
    case 'user-defined'
        switch problem.Funcname
            case '10bars'
                nn.Physpenalty = 1000;
            case '72bars'
                nn.Physpenalty = 1000;
            case 'EBBeam'
                nn.Physpenalty = 10;
            case 'CPB'
                nn.Physpenalty = 19.8622;
        end
end
end