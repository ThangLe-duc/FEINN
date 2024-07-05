function [xnOut,gradPre,mtNew,vtNew,mtOld,vtOld,nn] = BP_Adam_AD(xIO,fitnessFunc,xTrain1,yTrain1,problem,batch,nn,lr,iter)

x0 = dlarray(xIO);
% [fval,grad] = dlfeval(@DNN_AutoDiff,x0,fitnessFunc,problem,batch,xTrain1,yTrain1,xTrain2,nn);
[fval,grad] = dlfeval(@DNN_AutoDiff,x0,fitnessFunc,problem,batch,xTrain1,yTrain1,nn);
gradPre = extractdata(grad);
% gradOut = grad;
mtOld = [nn.mtWL nn.mtBL];
vtOld = [nn.vtWL nn.vtBL];

Dev.WL = gradPre(1:problem.nW);
nn.mtWL = nn.beta1*nn.mtWL + (1-nn.beta1)*Dev.WL;
nn.vtWL = nn.beta2*nn.vtWL + (1-nn.beta2)*Dev.WL.^2;
mtCorWL = nn.mtWL./(1-nn.beta1^iter);
vtCorWL = nn.vtWL./(1-nn.beta2^iter);
vWL = mtCorWL./(sqrt(vtCorWL)+1e-8);

Dev.BL = gradPre(problem.nW+1:problem.dim);
nn.mtBL = nn.beta1*nn.mtBL + (1-nn.beta1)*Dev.BL;
nn.vtBL = nn.beta2*nn.vtBL + (1-nn.beta2)*Dev.BL.^2;
mtCorBL = nn.mtBL./(1-nn.beta1^iter);
vtCorBL = nn.vtBL./(1-nn.beta2^iter);
vBL = mtCorBL./(sqrt(vtCorBL)+1e-8);

mtNew = [nn.mtWL nn.mtBL];
vtNew = [nn.vtWL nn.vtBL];

if strcmp(nn.RegType,'L1-Reg')
    xnOut(1:problem.nW) = xIO(1:problem.nW) - lr.Value*nn.RegCoef*sign(xIO(1:problem.nW)) - lr.Value*vWL;
    xnOut(problem.nW+1:problem.dim) = xIO(problem.nW+1:problem.dim) - lr.Value*vBL;
%     xnOut = xIO - lr.Value*nn.RegCoef*sign(xIO) - lr.Value*[vWL vBL];
elseif strcmp(nn.RegType,'L2-Reg')
    xnOut(1:problem.nW) = (1-lr.Value*nn.RegCoef)*xIO(1:problem.nW) - lr.Value*vWL;
    xnOut(problem.nW+1:problem.dim) = xIO(problem.nW+1:problem.dim) - lr.Value*vBL;
%     xnOut = (1-lr.Value*nn.RegCoef)*xIO - lr.Value*[vWL vBL];
end