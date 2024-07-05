function [yfPred,yfDenorm,TestPredErr] = DNN_PredictData(solution,problem,TestDat,nn)
M = size(TestDat.input,2);
yfPred = DNN_Sim(problem.ANNStruc,solution,problem.dim,TestDat.input,nn.ObjType,nn.activateLayer,nn.nameFunc);

% Relative Root Mean Squared Error
yfDenorm = minmaxDenormalize(yfPred,problem.psY);
yfDenorm = yfDenorm';

% rL2Err1 = 1/size(yfDenorm,2)*(sum(sum((yfDenorm - problem.yTestTrue).^2)))/(sum(sum((problem.yTestTrue).^2)))
% TestPredErr = 1/size(yfPred,2)*sum((yfPred - problem.yTest).^2./(problem.yTest).^2);
TestPredErr.MAPE = 1/M*sum(sum(abs((TestDat.outputnorm-yfPred)./TestDat.outputnorm)));
TestPredErr.MPE = 1/M*sum(sum((TestDat.outputnorm - yfPred)./TestDat.outputnorm));
TestPredErr.MAE = 1/M*sum(sum(abs(TestDat.outputnorm-yfPred)));
TestPredErr.RSE = 1/M*sum(sum((TestDat.outputnorm-yfPred).^2))/sum(sum((TestDat.outputnorm-mean(TestDat.outputnorm)).^2));
TestPredErr.R2 = calculateR2(TestDat.output,yfDenorm);

end