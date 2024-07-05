function [batch,odd,Nsampdone] = SampleFeeding1(batch,nloop,ithBatch)
odd = 0;
Nsampdone = (ithBatch-1)*batch.Size;
if ithBatch == nloop
    batch.Size = floor((batch.Nsample-Nsampdone));
    odd = mod((batch.Nsample-Nsampdone),batch.Size);
end
end