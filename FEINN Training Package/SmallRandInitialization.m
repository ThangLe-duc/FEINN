function xOut = SmallRandInitialization(NP, problem, LB, UB, type)
switch type
    case 'uniform'
        xOut = LB + rand(NP,problem.dim)*(UB-LB);
    case 'normal'
        xOut = LB + UB*randn(NP,problem.dim);
    case 'glorot'
        nLayer = size(problem.ANNStruc,2);
        W = [];
        for i=2:nLayer
            Wi = (sqrt(2)/sqrt(problem.ANNStruc(i-1)+problem.ANNStruc(i)))*randn(NP,problem.ANNStruc(i-1)*problem.ANNStruc(i));
            W = [W Wi];
        end
        B = zeros(NP,problem.nB);
        xOut = [W B];
    case 'he'
        nLayer = size(problem.ANNStruc,2);
        W = [];
        for i=2:nLayer
            Wi = (2/sqrt(problem.ANNStruc(i-1)+problem.ANNStruc(i)))*randn(NP,problem.ANNStruc(i-1)*problem.ANNStruc(i));
            W = [W Wi];
        end
        B = zeros(NP,problem.nB);
        xOut = [W B];
end