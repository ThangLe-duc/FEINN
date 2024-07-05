function lr = LRSchedule(lr, igen, iter)
switch lr.Schedule
    case 'noSchedule'
        
    case 'piecewise'
        if mod(igen-1,lr.DropPeriod) == 0 && (igen-1 > 0)
            lr.Value = lr.Value * lr.DropFrac;
        end
        
    case 'time-based'
        lr.Value = lr.Value/(1 + lr.DropFrac*igen);
        
    case 'exponential'
        lr.Value = lr.Init*exp(-lr.DropFrac*igen);
        
    case 'step'
        lr.Value = lr.Init*exp(-lr.DropFrac*floor(igen/lr.Tepoch));
        
    case 'cyclical'
        cycle = floor(0.5*(1+iter)/lr.Stepsize);
        x = abs(iter/lr.Stepsize - 2*cycle+1);
        lr.Value = lr.Low - (lr.Up - lr.Low)*max(0,1-x);
end
end