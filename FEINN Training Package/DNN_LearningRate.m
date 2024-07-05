function lr = DNN_LearningRate(MaxEpoch)
% Determine learning rate
lr.Schedule = 'none';    % 'noSchedule' 'piecewise' 'time-based' 'exponential' 'step' 'cyclical'
if strcmp(lr.Schedule,'piecewise')
    lr.Value = 1e-3;  % SGD: 5e-3
    lr.DropPeriod = 15;
    lr.DropFrac = 0.1;   % 0.01 for time-based; 0.5 for 'piecewise'
elseif strcmp(lr.Schedule,'time-based')
    lr.Value = 3e-3;  % SGD: 5e-3
    lr.DropFrac = lr.Value/MaxEpoch;
elseif strcmp(lr.Schedule,'exponential')
    lr.Value = 3e-3;
    lr.Init = lr.Value;
    lr.DropFrac = lr.Value/MaxEpoch;
elseif strcmp(lr.Schedule,'step')
    lr.Value = 1e-3;
    lr.Init = lr.Value;
    lr.DropFrac = 0.5;
    lr.Tepoch = 200;
elseif strcmp(lr.Schedule,'cyclical')
    lr.Up = 3e-3;
    lr.Low = 0.5e-3;
    lr.Stepsize = 200;
elseif strcmp(lr.Schedule,'none')
    lr.Value = 1e-3;
end
lr