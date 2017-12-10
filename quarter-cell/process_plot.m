function handles = process_plot(handles)



set(handles.run,'String','Process')
handles = process(handles);
guidata(handles.acq_gui,handles) % needed?
handles = plot_gui(handles);
guidata(handles.acq_gui,handles) % needed?
% drawnow