function [fitness,actualvalue,meanPredErr] = DNN_Predict(solution,problem,nn)
M = size(problem.xTest,2);
actualvalue = DNN_Sim(problem.ANNStruc,solution,problem.dim,problem.xTest,nn.ObjType,nn.activateLayer,nn.nameFunc);
% Regularization Terms
WeightVec = solution(1:problem.nW);
% Reg = sum(abs(WeightVec));
Reg = sum(WeightVec.^2);
% Reg = sum(abs(WeightVec)) + sum(WeightVec.^2);
switch nn.ObjType
    case 'rmse'
    meanPredErr = (1/M)*sum(sum((problem.yTest - actualvalue).^2));
    fitness = 0.5*meanPredErr + (1/M)*nn.RegCoef*0.5*Reg;
    case 'mae'
    meanPredErr = (1/M)*sum(sum(abs(problem.yTest - actualvalue)));
    fitness = meanPredErr + (1/M)*nn.RegCoef*0.5*Reg;
    case 'crossentropy'
    meanPredErr = -1/M*sum(sum(problem.yTest.*log(actualvalue)));
%     meanPredErr = -1/M*sum(sum(problem.yTest.*log(actualvalue)+ (1-problem.yTest).*log(1-actualvalue)));
%     meanPredErr = crossentropy(actualvalue,problem.yTest);
    fitness = meanPredErr + (1/M)*nn.RegCoef*0.5*Reg;
end    
end