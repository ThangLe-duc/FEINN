function [fitness,TrainErr,Reg,PhysE] = DPINN_PhysicsLoss_Comb(solution,problem,batch,xf1,yf1,nn)
M = size(xf1,2);

%% Physic-informed Term
% Calculate stiffness matrix and force vector
switch problem.Funcname
    case '10bars'
        [K,F] = Stiffness_Force_10Bars_Batch(xf1,batch.Size,problem.XScale);
    case '72bars'
        [K,F] = Stiffness_Force_72BarsForce_Batch(xf1,batch.Size,problem);
    case 'EBBeam'
        [K,F] = Stiffness_Force_BernBeam_Batch(xf1,batch.Size,problem.XScale,50);
    case 'CPB'
        [K,F] = Stiffness_Force_Plate_Batch(xf1,batch.Size,problem.XScale);
end
predValNorm = DNN_Sim(problem.ANNStruc,solution,problem.dim,xf1,nn.ObjType,nn.activateLayer,nn.nameFunc);
predVal2 = predValNorm.*problem.YScale;
predValReshape = reshape(predVal2,[],1,batch.Size);

% yfDenorm = yf1.*problem.YScale;
% yfReshape = reshape(yfDenorm,[],1,batch.Size);

% PhysE = Loss_TensorMult(K1, predValReshape, F1, M);
PhysE = DPIResidual_Batch(K, predValReshape, F, M);
% PhysE_True = DPIResidual_Batch(K, yfReshape, F, M);
% PhysE_True = Loss_TensorMult(K1, yfReshape, F1, M);

%% MSE Term
MSE = (1/M)*sum(sum((yf1 - predValNorm).^2));
TrainErr = MSE;

% grad1 = dlgradient(MSE,solution);
% grad2 = dlgradient(PhysE,solution);
%% Regularization Terms
WeightVec = solution(1:problem.nW);
if strcmp(nn.RegType,'L1-Reg')
    Reg = sum(abs(WeightVec));
elseif strcmp(nn.RegType,'L2-Reg')
    Reg = sum(WeightVec.^2);
else
    print('Wrong Regularization');
end

%% Fitness
fitness = 0.5*(nn.MSEpenalty*MSE + nn.Physpenalty*PhysE) + (1/M)*nn.RegCoef*0.5*Reg;
% fitness = 0.5*(nn.MSEpenalty*MSE + floor(MSE/PhysE)*PhysE) + (1/M)*nn.RegCoef*0.5*Reg;

end