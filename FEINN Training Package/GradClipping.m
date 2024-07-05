function [GradCor, nn] = GradClipping(nn, problem, GradCor, clipEpoch, nloop)
if nn.ClipActive > 0
    switch nn.ClipType
        case 'normal'
            % Calculate norm of gradient
            gradNorm = norm(GradCor(1:problem.nW));
            % Calculate scale value
            gradScale = min(nn.ClipValue/gradNorm, 1);
            GradCor = gradScale*GradCor;
        case 'percentile'
            % Calculate norm of gradient
            gradNorm = norm(GradCor(1:problem.nW));
            % Calculate clipping value
            nn.GradHistory = [nn.GradHistory gradNorm];
            clipVal = prctile(nn.GradHistory,nn.ClipValue);
            % Calculate scale value
            gradScale = min(clipVal/gradNorm, 1);
            GradCor = gradScale*GradCor;
        case 'limited percentile'
            % Calculate norm of gradient
            gradNorm = norm(GradCor(1:problem.nW));
            % Calculate clipping value
            nn.GradHistory = [nn.GradHistory gradNorm];
            if size(nn.GradHistory,2) > clipEpoch*nloop
                nn.GradHistory = [nn.GradHistory(2:clipEpoch*nloop) gradNorm];
            end
            clipVal = prctile(nn.GradHistory,nn.ClipValue);
            % Calculate scale value
            gradScale = min(clipVal/gradNorm, 1);
            GradCor = gradScale*GradCor;
    end
end
end