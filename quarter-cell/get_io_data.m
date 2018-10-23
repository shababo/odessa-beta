function get_io_data(src,event)

% disp('trigger')
[acq_gui, handles] = get_acq_gui_data();

if handles.data.do_process
    handles.io_data = event.Data;

    handles = process_plot(handles);
    % wait
    start_time = clock;
    while etime(clock, start_time) < str2double(get(handles.ITI,'String'))
    end
    drawnow
    default_color = [0.8627    0.8627    0.8627];  
    handles.data.do_process = 0;
    guidata(handles.run,handles)
    set(handles.run,'String','Start');
    set(handles.run,'BackgroundColor',default_color);
    drawnow

    % update fields
    % handles = trial_length_Callback(handles.trial_length, [], handles);
    
end