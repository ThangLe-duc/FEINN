function [fitness,yfPred,meanPredErr] = FEINN_Predict(solution,problem,input,target,nn)
M = size(problem.xTest,2);
yfPred = DNN_Sim(problem.ANNStruc,solution,problem.dim,input,nn.ObjType,nn.activateLayer,nn.nameFunc);
% Regularization Terms
WeightVec = solution(1:problem.nW);
Reg = sum(WeightVec.^2);
switch nn.ObjType
    case 'rmse'
    meanPredErr = (1/M)*sum(sum((target - yfPred).^2));
    fitness = 0.5*meanPredErr + (1/M)*nn.RegCoef*0.5*Reg;
    case 'mae'
    meanPredErr = (1/M)*sum(sum(abs(target - yfPred)));
    fitness = meanPredErr + (1/M)*nn.RegCoef*0.5*Reg;
    case 'crossentropy'
    meanPredErr = -1/M*sum(sum(target.*log(yfPred)));
    fitness = meanPredErr + (1/M)*nn.RegCoef*0.5*Reg;
    case 'physicLoss'
    meanPredErr = (1/M)*sum(sum((target - yfPred).^2));
    fitness = 0.5*meanPredErr + (1/M)*nn.RegCoef*0.5*Reg;
end
end