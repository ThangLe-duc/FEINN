function [fitness,grad] = DNN_AutoDiff(xIO,fitnessFunc,problem,batch,xf1,yf1,nn)

% fitness = feval(fitnessFunc,xIO,problem,batch,xf1,yf1,xf2,nn);
fitness = feval(fitnessFunc,xIO,problem,batch,xf1,yf1,nn);
grad = dlgradient(dlarray(fitness),xIO);
end