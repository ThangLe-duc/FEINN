function [fitness,TrainErr,Reg,PhysErr] = DNN_Loss(solution,problem,batch,xf,yf,nn)
PhysErr = 0;
M = size(xf,2);
actualvalue = DNN_Sim(problem.ANNStruc,solution,problem.dim,xf,nn.ObjType,nn.activateLayer,nn.nameFunc);
% Regularization Terms
WeightVec = solution(1:problem.nW);
if strcmp(nn.RegType,'L1-Reg')
    Reg = sum(abs(WeightVec));
elseif strcmp(nn.RegType,'L2-Reg')
    Reg = sum(WeightVec.^2);
else
    print('Wrong Regularization');
end

switch nn.ObjType
    case 'rmse'
    TrainErr = (1/M)*sum(sum((yf - actualvalue).^2));
    fitness = 0.5*TrainErr + (1/M)*nn.RegCoef*0.5*Reg;
    case 'mae'
    TrainErr = (1/M)*sum(sum(abs(yf - actualvalue)));
    fitness = TrainErr + (1/M)*nn.RegCoef*0.5*Reg;
    case 'crossentropy'
    TrainErr = -1/M*sum(sum(yf.*log(actualvalue)));
    fitness = TrainErr + (1/M)*nn.RegCoef*0.5*Reg;
end
end