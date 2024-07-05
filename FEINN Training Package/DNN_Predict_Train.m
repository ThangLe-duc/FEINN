function [fitness,yfPred,meanPredErr] = DNN_Predict_Train(solution,problem,nn)
M = size(problem.xTrain,2);
yfPred = DNN_Sim(problem.ANNStruc,solution,problem.dim,problem.xTrain,nn.ObjType,nn.activateLayer,nn.nameFunc);
% Regularization Terms
WeightVec = solution(1:problem.nW);
Reg = sum(WeightVec.^2);
switch nn.ObjType
    case 'rmse'
    meanPredErr = (1/M)*sum(sum((problem.yTrain - yfPred).^2));
    fitness = 0.5*meanPredErr + (1/M)*nn.RegCoef*0.5*Reg;
    case 'mae'
    meanPredErr = (1/M)*sum(sum(abs(problem.yTrain - yfPred)));
    fitness = meanPredErr + (1/M)*nn.RegCoef*0.5*Reg;
    case 'crossentropy'
    meanPredErr = -1/M*sum(sum(problem.yTrain.*log(yfPred)));
    fitness = meanPredErr + (1/M)*nn.RegCoef*0.5*Reg;
    case 'physicLoss'
    meanPredErr = (1/M)*sum(sum((problem.yTrain - yfPred).^2));
    fitness = 0.5*meanPredErr + (1/M)*nn.RegCoef*0.5*Reg;
end
end