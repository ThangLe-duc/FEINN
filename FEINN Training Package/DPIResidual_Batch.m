function PhysE = DPIResidual_Batch(K, predVal, F, M)
GovEq = pagemtimes(K,predVal) - F;
PhysE = (1/M)*sum(sum(GovEq.^2));
end