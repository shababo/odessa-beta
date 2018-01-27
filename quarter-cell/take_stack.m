

isAcquireImage = 1;

% while imageCount == curImageCount
%     imageCount
%     curImageCount
%     pause(1)
% end

wrndlg = warndlg('Stack Done?');
pos = get(wrndlg,'position');
set(wrndlg,'position',[0 1000 pos(3) pos(4)]);
waitfor(wrndlg)

disp('stack done!')