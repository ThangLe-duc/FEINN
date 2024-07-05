function [Err_Valid, Err_Test, meanErrValid, meanErrTest] = FEIResBoundErr(results,nloop,nfeature)
for i=1:nloop
    for j=1:nfeature
        Err_Valid(i,j) = results.ValidFEIRes(i).BoundErr(j);
    end
end

for i=1:nloop
    for j=1:nfeature
        Err_Test(i,j) = results.TestFEIRes(i).BoundErr(j);
    end
end

meanErrValid = mean(Err_Valid,2);
meanErrTest = mean(Err_Test,2);
end