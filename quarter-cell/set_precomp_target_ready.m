precomp_rate = 20; % holograms/sec
wait_time = length(precomputed_target)/rate + 5
isPrecomputedTargetArrayReady = 1;
pause(wait_time)
disp('done waiting for phase loading')