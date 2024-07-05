function nn = DNN_Setup(problem)
% DNN architecture hyper-parameters
nn.nHlayer = size(problem.ANNStruc,2)-2;
activeHid = 'ReLU' % 'sigmoid' 'tanh' 'ReLU' 'snake'
activeOut = 'purelinear'  % 'sigmoid' 'tanh' 'purelinear' 'radbas' 'softmax' 'ReLU' 'LeakyReLU' 'softplus'
nn.ObjType = 'physicLoss'; % rmse, physicLoss
for i=1:nn.nHlayer
    nn.nameFunc.hlay{i} = activeHid; % 'sigmoid' 'tanh' 'purelinear' 'ReLU' 'LeakyReLU' 'softplus'
end
nn.nameFunc.hlay{nn.nHlayer+1} = activeOut;
nn.activateLayer = @activationLayerFunc;
nn.dActivateLayer = @dActivationLayerFunc;

% Training algorithm hyper-parameters
nn.SGD = 'adam';
nn.Momentum = 0.9; 
nn.Momentum2 = 0.99;
nn.beta0 = 0.9;   
nn.beta1 = 0.9;   
nn.beta2 = 0.999; 
nn.RegType = 'L2-Reg';  % 'L1-Reg' 'L2-Reg'
L1Coef = 0.000;  % (0.0001 - 0.001)
L2Coef = 0.0001;  % (0.0001 - 0.001)
if strcmp(nn.RegType,'L1-Reg')
    nn.RegCoef = L1Coef;
elseif strcmp(nn.RegType,'L2-Reg')
    nn.RegCoef = L2Coef;
end
nn.CorCoef = 1e-6;
nn.ClipActive = 1;
nn.ClipType = 'normal'; % 'normal' 'percentile' 'limited percentile'
nn.GradHistory = [];
nn.ClipValue = 1;

% Physic-informed Loss
nn = PenaltyCoef(problem, nn, 'dynamic'); % 'fixed' 'dynamic' 'user-defined'

% Predict train and test set
nn.TestPred = 1
end