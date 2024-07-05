function [Test,FEIRes,yfDenorm] = StatsEvaluation_BernBeam(Wvector,input,target,targetTrue,problem,nn,DOFprescribed)

[Test.Obj,yfPred,Test.Err] = FEINN_Predict(Wvector,problem,input,target,nn);

% Denormalize output
yfPredScaled = yfPred.*problem.YScale;
yfDenorm = yfPredScaled';
[M, N] = size(yfDenorm);

% Calculate correlation coefficient of all output
nDOFactive = size(yfDenorm,2)-problem.nDOFelim;
if problem.nDOFelim == 0
    for i=1:nDOFactive
        Test.R2(i) = corr(targetTrue(:,i),yfDenorm(:,i));
    end
else
    for i=1:nDOFactive
        Test.R2(i) = corr(targetTrue(:,i+2),yfDenorm(:,i+2));
    end
end
Test.R2Avg = mean(Test.R2);
% R2Avg = TestPredErr.R2Avg
% Calculate average relative error (ARE), mean squared error (MSE), average
% RMSE (aRMSE), average relative RMSE (aRRMSE)
Test.ARE = 1/N*sum(1/M*sum(abs((yfDenorm(:,3:nDOFactive+2) - targetTrue(:,3:nDOFactive+2))./(targetTrue(:,3:nDOFactive+2)))));
Test.MSE = sum(1/M*sum((yfDenorm(:,3:nDOFactive+2) - targetTrue(:,3:nDOFactive+2)).^2));
Test.aRMSE = 1/N*sum(sqrt(1/M*sum((yfDenorm(:,3:nDOFactive+2) - targetTrue(:,3:nDOFactive+2)).^2)));
Test.aRRMSE = 1/N*sum(sqrt(sum((yfDenorm(:,3:nDOFactive+2) - targetTrue(:,3:nDOFactive+2)).^2)./sum((targetTrue(:,3:nDOFactive+2) - mean(targetTrue(:,3:nDOFactive+2))).^2)));

% Calculate FEI residual
[K,F,E] = Stiffness_Force_BernBeam_Batch_True(input,M,problem.XScale,50);
predValReshape = reshape(yfPredScaled,[],1,M);
FEIResErr = DPIResidual_Batch(K, predValReshape, F, M);
FEIRes.Err = 1/M*sqrt(M/E*FEIResErr);

% Calculate boundary error
nDOFprescribed = size(DOFprescribed,2);
for i=1:nDOFprescribed
    BoundErr(i) = mae(yfDenorm(:,DOFprescribed(i)), targetTrue(:,DOFprescribed(i)));
end
FEIRes.BoundErr = BoundErr;
end