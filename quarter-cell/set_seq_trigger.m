seq_load_rate = 80; % 80 phase masks/sec
num_stims = length(sequence);
wait_time = num_stims/seq_load_rate +  20;%num_stims/100
% isTriggeredSequenceReady
isTriggeredSequenceReady = 1;
% isTriggeredSequenceReady
% while isTriggeredSequenceReady
%     isTriggeredSequenceReady
wrndlg = warndlg('Seq Done?');
pos = get(wrndlg,'position');
set(wrndlg,'position',[0 1000 pos(3) pos(4)]);
waitfor(wrndlg)
%     pause(wait_time)
% end
disp('done waiting for sequence load')