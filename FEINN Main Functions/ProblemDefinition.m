function problem = ProblemDefinition(Funcname)
problem.Funcname = Funcname;
switch Funcname
    case '10bars'
        problem.nDOFelim = 4;
        Ono = 8 + problem.nDOFelim;
        Ino = 10;
        DNNStruc = [Ino, 100, 100, Ono];
        problem.ANNStruc = DNNStruc;
        problem.type = 'regression';
    case '72bars'
        problem.nDOFelim = 0;
        Ono = 60 - problem.nDOFelim;
        Ino = 76;
        DNNStruc = [Ino, 100, 100, Ono];
        problem.ANNStruc = DNNStruc;
        problem.type = 'regression';
    case 'EBBeam'
        problem.nDOFelim = 3;
        Ono = 100 + problem.nDOFelim;
        Ino = 3;
        DNNStruc = [Ino, 100, 100, Ono]; 
        problem.ANNStruc = DNNStruc;
        problem.type = 'regression';
        problem.OutDat = 103;
    case 'CPB'
        problem.nDOFelim = 84;
        Ono = 363;
        Ino = 3;
        DNNStruc = [Ino, 300, 300, Ono];
        problem.ANNStruc = DNNStruc;
        problem.type = 'regression';
        problem.OutDat = 363;
end