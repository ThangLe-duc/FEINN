function y = dActivationLayerFunc(x,nameFunc)
switch nameFunc
    case 'sigmoid'
        y = x.*(1 - x);
    case 'tanh'
        y = dtansig(x,x);
    case 'purelinear'
        y = 1;
    case 'radbas'
        y = -2.*x.*x;
    case 'softmax'
        y = 1;
    case 'ReLU'
        y = double(x>0);
    case 'LeakyReLU'
        if double(x) >= 0
            y = 1;
        else
            y = 0.01;
        end
    case 'softplus'
        y = 1./(1 + exp(-x));
    case 'snake'
        y = 1 + 2*sin(x).*cos(x);
    case 'sin'
        y = cos(x);
end