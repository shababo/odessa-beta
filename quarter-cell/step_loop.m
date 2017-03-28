function  data = step_loop(handles)
% this is the core function of acquisition. It is called by the timer
% function when triggering internally, and is the re-called for each
% trigger when using external triggers


% generate analog output vectors for each trial

start_color = get(handles.run,'BackgroundColor');
set(handles.run,'BackgroundColor',[1 0 0]);
set(handles.run,'String','Acq...')
[AO0, AO1, AO2, AO3] = analogoutput_gen(handles);

data = io(handles.s,[AO0, AO1, AO2, AO3]);


set(handles.run,'backgroundColor',start_color)
guidata(handles.acq_gui,handles)

