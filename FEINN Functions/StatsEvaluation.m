function [Test,FEIRes,yfDenorm] = StatsEvaluation(Wvector,input,target,targetTrue,problem,nn,DOFprescribed)

[Test.Obj,yfPred,Test.Err] = FEINN_Predict(Wvector,problem,input,target,nn);

% Denormalize output
yfPredScaled = yfPred.*problem.YScale;
yfDenorm = yfPredScaled';
[M, N] = size(yfDenorm);

% Calculate correlation coefficient of all output
nDOFactive = size(yfDenorm,2)-problem.nDOFelim;
for i=1:nDOFactive
    Test.R2(i) = corr(targetTrue(:,i),yfDenorm(:,i));
end
Test.R2Avg = mean(Test.R2);
% R2Avg = TestPredErr.R2Avg
% Calculate average relative error (ARE), mean squared error (MSE), average
% RMSE (aRMSE), average relative RMSE (aRRMSE)
Test.ARE = 1/N*sum(1/M*sum(abs((yfDenorm(:,1:nDOFactive) - targetTrue(:,1:nDOFactive))./(targetTrue(:,1:nDOFactive)))));
Test.MSE = sum(1/M*sum((yfDenorm(:,1:nDOFactive) - targetTrue(:,1:nDOFactive)).^2));
Test.aRMSE = 1/N*sum(sqrt(1/M*sum((yfDenorm(:,1:nDOFactive) - targetTrue(:,1:nDOFactive)).^2)));
Test.aRRMSE = 1/N*sum(sqrt(sum((yfDenorm(:,1:nDOFactive) - targetTrue(:,1:nDOFactive)).^2)./sum((targetTrue(:,1:nDOFactive) - mean(targetTrue(:,1:nDOFactive))).^2)));

% Calculate FEI residual
[K,F,E] = Stiffness_Force_10Bars_Batch_True(input,M,problem.XScale);
predValReshape = reshape(yfPredScaled,[],1,M);
FEIResErr = DPIResidual_Batch(K, predValReshape, F, M);
FEIRes.Err = 1/(M*E)*sqrt(M*FEIResErr);

% Calculate boundary error
nDOFprescribed = size(DOFprescribed,2);
for i=1:nDOFprescribed
    BoundErr(i) = mae(yfDenorm(:,DOFprescribed(i)), targetTrue(:,DOFprescribed(i)));
end
FEIRes.BoundErr = BoundErr;
end