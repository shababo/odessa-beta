seq_load_rate = 80; % 80 phase masks/sec
num_stims = length(sequence);
wait_time = num_stims/load_rate + 3
isTriggeredSequenceReady = 1;
pause(wait_time)
disp('done waiting for sequence load')