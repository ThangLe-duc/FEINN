function [nW, nB, nn] = DNN_Structure(DNNStruc, nn, varargin)
% Calculate number of weights and bias for each layer
nLayer = size(DNNStruc,2);
nn.nLayer = nLayer;
for i=1:nLayer
    nnodeLayer(i) = DNNStruc(i);
    if i>1
        Wnum(i-1) = nnodeLayer(i-1)*nnodeLayer(i);
        Bnum(i-1) = nnodeLayer(i);
    end
end
nW = sum(Wnum);
nB = sum(Bnum);

nn.vWL = zeros(1,nW);
nn.vBL = zeros(1,nB);
nn.HistWL = zeros(1,nW);
nn.HistBL = zeros(1,nB);
nn.mtWL = zeros(1,nW);
nn.vtWL = zeros(1,nW);
nn.mtBL = zeros(1,nB);
nn.vtBL = zeros(1,nB);