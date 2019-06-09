seq_load_rate = 80; % 80 phase masks/sec
num_stims = length(sequence);
% 
wait_time = num_stims/seq_load_rate +  1;%num_stims/100
% isTriggeredSequenceReady
tic
isTriggeredSequenceReady = 1;
% isTriggeredSequenceReady
while isTriggeredSequenceReady
    pause(.5)
end
pause(5)
toc
% pause(wait_time)

% wrndlg = warndlg('Seq Done?');
% pos = get(wrndlg,'position');
% set(wrndlg,'position',[0 1000 pos(3) pos(4)]);
% beep on
% beep
% waitfor(wrndlg)
% toc
% beep off

% pause(3)
% end

disp('done waiting for sequence load')