function [xfbatch,yfbatch,batch] = BatchGeneration(xf,yf,batch)
sizexf1 = size(xf,2);
batch.Num = floor(sizexf1/batch.Size);
batch.Nsample = sizexf1;
k = randperm(sizexf1);
batch.randperm = k;
xfbatch = xf(:,k);
yfbatch = yf(:,k);