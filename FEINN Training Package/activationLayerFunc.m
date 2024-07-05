function y = activationLayerFunc(x,nameFunc)
switch nameFunc
    case 'sigmoid'
        y = 1 ./ (1 + exp(-x));
    case 'tanh'
%         y = tanh(x);
        y = tansig(x);
    case 'purelinear'
        y = x;
    case 'radbas'
        y = radbas(x);
    case 'softmax'
        y = SoftMax_Func(x);
    case 'ReLU'
        y = max(x,0);
    case 'LeakyReLU'
        y = max(x,0.01*x);
    case 'softplus'
        y = log(1 + exp(x));
    case 'snake'
        y = x + (sin(x)).^2;
    case 'sin'
        y = sin(x);
end