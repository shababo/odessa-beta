function [data,handles] = io(handles, output,varargin)

if ~isempty(varargin) && ~isempty(varargin{1})
    do_bg = varargin{1};
else
    do_bg = 0;
end

s = handles.s;
s.queueOutputData(output);
data = [];

if do_bg
    
    s.NotifyWhenDataAvailableExceeds = size(output,1);
    handles.lh = s.addlistener('DataAvailable', @get_io_data);
    s.startBackground();
%     wait(s);

    % while s.IsRunning
    % end

%     delete(lh)
%     [acq_gui, acq_gui_data] = get_acq_gui_data();
%     data = acq_gui_data.this_acq_data;
else
    data = s.startForeground();
end