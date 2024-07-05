function [xn_upd,ObjVal_upd,Reg_upd,batch,nn,lr,bcmo,batchErr,batchObj,batchPhys] = SMO_Adam_AD(fitnessFunc,xn,ObjVal,Reg,xfbatch1,yfbatch1,xfbatch2,igen,bcmo,problem,nn,lr,batch,TrainErr,PhysErr)
%% MINIBATCH PROCESSING
batchFix = batch.Size;
nloop = floor(batch.Num);
batchErr = dlarray(zeros(nloop,1));
batchObj = dlarray(zeros(nloop,1));
batchPhys = dlarray(zeros(nloop,1));
for ithBatch = 1:nloop
    iter = (igen-1)*nloop + ithBatch;
    lr = LRSchedule(lr,igen,iter);
if strcmp(nn.PhysPenType, 'dynamic')
    nn.Physpenalty = min(nn.LastPhysPen*iter/(nloop*bcmo.MaxIter),nn.MaxPhysPen);
end
[batch,odd,Nsampdone] = SampleFeeding1(batch,nloop,ithBatch);

% ADAM OPTIMIZER
xIO = xn(1,:);
if ithBatch == nloop
    ind1_start = Nsampdone + 1;
    ind1_end = Nsampdone + batch.Size + odd;
else
    ind1_start = (ithBatch-1)*batch.Size + 1;
    ind1_end = (ithBatch-1)*batch.Size + batch.Size;
end
[xIO,gradPre,mtNew,vtNew,mtPre,vtPre,nn] = BP_Adam_AD(xIO,fitnessFunc,xfbatch1(:,ind1_start:ind1_end),yfbatch1(:,ind1_start:ind1_end,:),problem,batch,nn,lr,iter);
xn(1,:) = xIO;
[ObjVal,TrainErr,Reg,PhysErr] = fitnessFunc(xIO,problem,batch,xfbatch1(:,ind1_start:ind1_end),yfbatch1(:,ind1_start:ind1_end),nn);

% RETURN MINIBATCH RESULTS
batchErr(ithBatch,1) = TrainErr;
batchObj(ithBatch,1) = ObjVal;
batchPhys(ithBatch,1) = PhysErr;
end

%% RETURN CURRENT RESULTS
xn_upd = xn;
ObjVal_upd = ObjVal;
Reg_upd = Reg;
batch.Size = batchFix;
end