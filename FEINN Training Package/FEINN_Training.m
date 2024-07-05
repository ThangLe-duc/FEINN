%%  Training Finite Element Informed Neural Networks (FEI-NN) using Adam Optimizer
%%  Developed in MATLAB R2020a
%%  Author and programmer: Thang Le-Duc
%%  E-Mail: le.duc.thang0312@gmail.com; thangld@sju.ac.kr
%%  Homepage: https://www.researchgate.net/profile/Thang-Le-Duc-3
%%  Github: https://github.com/ThangLe-duc
%% ----------------------------FEINN TRAINING CODES-------------------------------------------------------------
function [f_final,x_final,Converge_curve,traintime,results] = FEINN_Training(optim,problem,nn,lr,batch,Funcname)
fitnessFunc = problem.fobj; batchMSE = []; batchObj = []; batchPhys = [];
%% INITIALIZATION
[xfbatch1,yfbatch1,batch] = BatchGeneration(problem.xTrain,problem.yTrain,batch);
xfbatch2 = DataSampling(problem,Funcname);
xnInit = SmallRandInitialization(1, problem, -0.1, 0.1, 'glorot');
xn = dlarray(xnInit);
ObjVal = dlarray(zeros(1,1));
Reg = dlarray(zeros(1,1));
TrainErr = dlarray(zeros(1,1));
PhysErr = dlarray(zeros(1,1));
Converge_curve = dlarray(zeros(1,optim.MaxIter));
fprintf('\n						 Mean\t\t\t Mean\t\t\t Mean\t\n')
fprintf('Epoch\tIteration\t\t MSE\t\t\t Obj\t\t\t Phys\t\n')
tstart = tic;
%% MAIN ITERATIONS
% DETERMINE TERMINATION CRITERIA FOR EACH PROBLEM
problem = TerminationCriteria(problem);
% TRAINING FEINN
for i=1:optim.MaxIter
    Converge_curve(i) = ObjVal(1);
    % ADAM OPTIMIZER  
    [xn,ObjVal,Reg,batch,nn,lr,optim,batchErr,batchObjEpo,batchPhysEpo] = SMO_Adam_AD(fitnessFunc,xn,ObjVal,Reg,xfbatch1,yfbatch1,xfbatch2,i,optim,problem,nn,lr,batch,TrainErr,PhysErr);
    batchMSE = [batchMSE; batchErr];
    batchObj = [batchObj; batchObjEpo];
    batchPhys = [batchPhys; batchPhysEpo];
    RegRecord(i,1) = Reg(1);
    fprintf('\t%i\t\t%i\t\t\t %E\t %E\t %E\n',i,(i*batch.Num),mean(batchErr),mean(batchObjEpo),mean(batchPhysEpo));
    % BATCH REARRAGEMENT
    if batch.Shuffle == 1
        [xfbatch1,yfbatch1,batch] = BatchGeneration(problem.xTrain,problem.yTrain,batch);
        xfbatch2 = DataSampling(problem,Funcname);
    end
    % VALIDATION PREDICTION
    switch problem.Funcname
        case '10bars'
        if nn.TestPred == 1
        [ValidStats(i),ValidFEIRes(i),yfDenormValid,TestStats(i),TestFEIRes(i),yfDenormTest,TrainObj(i,1),TrainPred(i,1)] = ...
           Testing_Regression10Bars(xn(1,:),problem,nn,0,problem.DOFprescribed);
        end
        case '72bars'
        if nn.TestPred == 1
        [ValidStats(i),ValidFEIRes(i),yfDenormValid,TestStats(i),TestFEIRes(i),yfDenormTest,TrainObj(i,1),TrainPred(i,1)] = ...
           Testing_Regression72Bars(xn(1,:),problem,nn,0,problem.DOFprescribed);
        end
        case 'EBBeam'
        if nn.TestPred == 1
        [ValidStats(i),ValidFEIRes(i),yfDenormValid,TestStats(i),TestFEIRes(i),yfDenormTest,TrainObj(i,1),TrainPred(i,1)] = ...
           Testing_Regression_BernBeam(xn(1,:),problem,nn,0,problem.DOFprescribed);
        end
        case 'CPB'
        if nn.TestPred == 1
        [ValidStats(i),ValidFEIRes(i),yfDenormValid,TestStats(i),TestFEIRes(i),yfDenormTest,TrainObj(i,1),TrainPred(i,1)] = ...
           Testing_Regression_Plate(xn(1,:),problem,nn,0,problem.DOFprescribed);
        end
    end
    % CONVERGENCE CRITERIA
    if (ValidStats(i).R2Avg > problem.R2AvgThreshold &&  mean(ValidFEIRes(i).BoundErr) < problem.BoundErrThreshold)...
            || i==optim.MaxIter
        fval = ObjVal(1);
        xval = xn(1,:);
        disp('_____________________________________________________')
        fprintf('FEINN training process is stopped at epoch: %i, loss = %s \n',i,mat2str(fval));
        break
    end
end
%% SAVE RESULTS
traintime = toc(tstart);
f_final = fval;
x_final = xval;
if nn.TestPred == 1
    results.ValidStats = ValidStats;
    results.ValidFEIRes = ValidFEIRes;
    results.yfDenormValid = yfDenormValid;
    results.TestStats = TestStats;
    results.TestFEIRes = TestFEIRes;
    results.yfDenormTest = yfDenormTest;
    results.TrainObj = TrainObj;
    results.TrainPred = TrainPred;
end
results.batchMSE = extractdata(batchMSE);
results.batchObj = extractdata(batchObj);
results.batchPhys = extractdata(batchPhys);
end