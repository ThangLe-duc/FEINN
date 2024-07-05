function [ValidStats,ValidFEIRes,yfDenormValid,TestStats,TestFEIRes,yfDenormTest,ObjTrain,TrainErr] = ...
    Testing_Regression10Bars(Wvector,problem,nn,graph,DOFprescribed)

Wvector = extractdata(Wvector);

if graph == 1
figure
set(axes,'FontName','Times New Roman');
hold on
grid on;
end

% DNN Prediction on train and test set
[ObjTrain,~,TrainErr] = DNN_Predict_Train(Wvector,problem,nn);

% Statistical Evaluation on Validation Set
[ValidStats,ValidFEIRes,yfDenormValid] = StatsEvaluation(Wvector,problem.xValid,problem.yValid,problem.YValidTrue,problem,nn,DOFprescribed);

% Statistical Evaluation on Test Set
[TestStats,TestFEIRes,yfDenormTest] = StatsEvaluation(Wvector,problem.xTest,problem.yTest,problem.YTestTrue,problem,nn,DOFprescribed);
end