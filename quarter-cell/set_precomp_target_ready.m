precomp_rate = 20; % holograms/sec
wait_time = length(precomputed_target)/precomp_rate + 5;
isPrecomputedTargetArrayReady = 1;
% pause(5)
% while any(isPrecomputedHologramReady == 0)
%     pause(5);
% end
wrndlg = warndlg('Precomp Done?');
pos = get(wrndlg,'position');
set(wrndlg,'position',[0 1000 pos(3) pos(4)]);
waitfor(wrndlg)
% pause(wait_time)
disp('done waiting for phase loading')
clear precomputed_target