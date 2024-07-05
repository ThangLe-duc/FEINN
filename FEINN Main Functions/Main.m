%%  Training Finite Element Informed Neural Networks (FEI-NN) using Adam Optimizer
%%  Developed in MATLAB R2020a
%%  Author and programmer: Thang Le-Duc
%%  E-Mail: le.duc.thang0312@gmail.com; thangld@sju.ac.kr
%%  Homepage: https://www.researchgate.net/profile/Thang-Le-Duc-3
%%  Github: https://github.com/ThangLe-duc
%% -------------------------MAIN CODE------------------------------------------------------
clear all, close all, clc
rng('default')

addpath("FEINN Training Package\")
addpath("FEINN Functions")
addpath("FEINN Functions\utilities\")

%% Initialization
Funcname = '10bars'; % 10bars; 72bars; EBBeam; CPB
problem = ProblemDefinition(Funcname);
epoch = 2000
nn = DNN_Setup(problem);
lr = DNN_LearningRate(epoch);
valid.Active = 0;
[problem,nn] = StructuralProblems(Funcname,valid,nn,problem);
optim = Optim_Setup(epoch);
batch = Batch_Setup;

%% Training FEINN by Adam Optimizer
[Loss_final,Weight_final,Loss_cg,traintime,results] = FEINN_Training(optim,problem,nn,lr,batch,Funcname);

%% Statistical Results
ValidErr = results.ValidStats(size(results.TrainObj,1)).Obj
ValidPred = results.ValidStats(size(results.TrainObj,1)).Err
ValidFEIRes = results.ValidFEIRes(size(results.TrainObj,1))
    
TestErr = results.TestStats(size(results.TrainObj,1)).Obj
TestPred = results.TestStats(size(results.TrainObj,1)).Err
TestFEIRes = results.TestFEIRes(size(results.TrainObj,1))
ElapsedTime = traintime
save ANN.mat Weight_final optim problem nn batch Loss_cg
save results.mat Loss_final results traintime