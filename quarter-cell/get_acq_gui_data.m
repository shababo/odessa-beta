function [acq_gui, acq_gui_data] = get_acq_gui_data()

acq_gui = findobj('Tag','acq_gui');
acq_gui_data = guidata(acq_gui);