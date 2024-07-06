function [Test,FEIRes,yfDenorm] = StatsEvaluation72Bars(Wvector,input,target,targetTrue,problem,nn,DOFprescribed)

[Test.Obj,yfPred,Test.Err] = FEINN_Predict(Wvector,problem,input,target,nn);

% Denormalize output
yfPredScaled = yfPred.*problem.YScale;
yfDenorm = yfPredScaled';
[M, N] = size(yfDenorm);

% Calculate boundary error
nDOFprescribed = size(DOFprescribed,2);
for i=1:nDOFprescribed
    BoundErr(i) = mae(yfDenorm(:,DOFprescribed(i)), targetTrue(:,DOFprescribed(i)));
end
FEIRes.BoundErr = BoundErr;

% Calculate correlation coefficient of all output
nDOFactive = size(yfDenorm,2);
for i=nDOFprescribed+1-problem.nDOFelim:nDOFactive
    Test.R2(i) = corr(targetTrue(:,i),yfDenorm(:,i));
end
Test.R2Avg = mean(Test.R2(nDOFprescribed+1-problem.nDOFelim:nDOFactive));
% R2Avg = TestPredErr.R2Avg
% Calculate average relative error (ARE), mean squared error (MSE), average
% RMSE (aRMSE), average relative RMSE (aRRMSE)
Test.ARE = 1/N*sum(1/M*sum(abs((yfDenorm(:,13-problem.nDOFelim:nDOFactive) - targetTrue(:,13-problem.nDOFelim:nDOFactive))./(targetTrue(:,13-problem.nDOFelim:nDOFactive)))));
Test.MSE = sum(1/M*sum((yfDenorm(:,13-problem.nDOFelim:nDOFactive) - targetTrue(:,13-problem.nDOFelim:nDOFactive)).^2));
Test.aRMSE = 1/N*sum(sqrt(1/M*sum((yfDenorm(:,13-problem.nDOFelim:nDOFactive) - targetTrue(:,13-problem.nDOFelim:nDOFactive)).^2)));
Test.aRRMSE = 1/N*sum(sqrt(sum((yfDenorm(:,13-problem.nDOFelim:nDOFactive) - targetTrue(:,13-problem.nDOFelim:nDOFactive)).^2)./sum((targetTrue(:,13-problem.nDOFelim:nDOFactive) - mean(targetTrue(:,13-problem.nDOFelim:nDOFactive))).^2)));

% Calculate FEI residual
[K,F,E] = Stiffness_Force_72BarsForce_Batch_True(input,M,problem);
predValReshape = reshape(yfPredScaled,[],1,M);
FEIResErr = DPIResidual_Batch(K, predValReshape, F, M);
FEIRes.Err = 1/(M*E)*sqrt(M*FEIResErr);
end