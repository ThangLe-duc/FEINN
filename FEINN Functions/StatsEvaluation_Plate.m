function [Test,FEIRes,yfDenorm] = StatsEvaluation_Plate(Wvector,input,target,targetTrue,problem,nn,DOFprescribed)

[Test.Obj,yfPred,Test.Err] = FEINN_Predict(Wvector,problem,input,target,nn);

% Denormalize output
yfPredScaled = yfPred.*problem.YScale;
yfDenorm = yfPredScaled';
[M, N] = size(yfDenorm);

% Calculate correlation coefficient of all output
DOFall = linspace(1,N,N);
DOFzeros = [DOFprescribed 51 84 117 150 170 173 176 179 182 183 185 188 191 194 216 249 282 315];
DOFzeros = sort(DOFzeros);
% DOFzeros = DOFprescribed;
DOFactive = setdiff(DOFall,DOFzeros);
% nDOFactive = size(yfDenorm,2)-problem.nDOFelim;
nDOFactive = length(DOFactive);
if problem.nDOFelim == 0
    for i=1:nDOFactive
        Test.R2(i) = corr(targetTrue(:,i),yfDenorm(:,i));
    end
else
    for i=1:nDOFactive
        Test.R2(i) = corr(targetTrue(:,DOFactive(i)),yfDenorm(:,DOFactive(i)));
    end
end
Test.R2Avg = mean(Test.R2);
% R2Avg = TestPredErr.R2Avg
% Calculate average relative error (ARE), mean squared error (MSE), average
% RMSE (aRMSE), average relative RMSE (aRRMSE)
Test.ARE = 1/N*sum(1/M*sum(abs((yfDenorm(:,DOFactive) - targetTrue(:,DOFactive))./(targetTrue(:,DOFactive)))));
Test.MSE = sum(1/M*sum((yfDenorm(:,DOFactive) - targetTrue(:,DOFactive)).^2));
Test.aRMSE = 1/N*sum(sqrt(1/M*sum((yfDenorm(:,DOFactive) - targetTrue(:,DOFactive)).^2)));
Test.aRRMSE = 1/N*sum(sqrt(sum((yfDenorm(:,DOFactive) - targetTrue(:,DOFactive)).^2)./sum((targetTrue(:,DOFactive) - mean(targetTrue(:,DOFactive))).^2)));

% Calculate FEI residual
[K,F,E] = Stiffness_Force_Plate_Batch_True(input,M,problem.XScale);
predValReshape = reshape(yfPredScaled,[],1,M);
FEIResErr = DPIResidual_Batch(K, predValReshape, F, M);
FEIRes.Err = 1/M*sqrt(M/E*FEIResErr);

% Calculate boundary error
nDOFzeros = size(DOFzeros,2);
for i=1:nDOFzeros
    BoundErr(i) = mae(yfDenorm(:,DOFzeros(i)), targetTrue(:,DOFzeros(i)));
end
FEIRes.BoundErr = BoundErr;
end