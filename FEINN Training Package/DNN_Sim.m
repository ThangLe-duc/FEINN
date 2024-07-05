% This function simulates DNN

function [out,z,a,W,B,nLayer] = DNN_Sim(DNNStruc,solution,dim,x,ObjType,activateLayer,nameFunc)
nLayer = size(DNNStruc,2);
for i=1:nLayer
    nnodeLayer(i) = DNNStruc(i);
    if i>1
        Wnum(i-1) = nnodeLayer(i-1)*nnodeLayer(i);
        Bnum(i-1) = nnodeLayer(i);
    end
end
Weight = solution(1,1:sum(Wnum));
Bias = solution(1,sum(Wnum)+1:dim);

% indstart = zeros(1,Leng-1);
indend = zeros(1,nLayer-1);
for i=2:nLayer
    indstart = indend(i-1) + 1;
    indend(i) = indstart + Wnum(i-1) - 1;
    W.L{i-1} = Weight(1,indstart : indend(i));
end

indend = zeros(1,nLayer-1);
for i=2:nLayer
    indstart = indend(i-1) + 1;
    indend(i) = indstart + Bnum(i-1) - 1;
    B.L{i-1} = Bias(indstart : indend(i));
end

for i=1:nLayer-1
    Wlayer = reshape(W.L{i},nnodeLayer(i),nnodeLayer(i+1));
    W.L{i} = Wlayer';
end

a.L{1} = x;
for i=1:nLayer-1
    z.L{i} = W.L{i}*a.L{i} + B.L{i}'*ones(1,size(x,2));
    a.L{i+1} = activateLayer(z.L{i},nameFunc.hlay{i});
end
z.Out = z.L{nLayer-1};
a.Out = a.L{nLayer};

out = a.Out;