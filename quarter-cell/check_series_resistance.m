function res_bad = check_series_resistance(handles)

handles.data.sweep_counter
if handles.data.ch1.series_r(end) > str2double(get(handles.series_r_max,'String'))
    res_bad = 1;
else
    res_bad = 0;
end