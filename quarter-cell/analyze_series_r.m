
 
function handles = analyze_series_r(handles)
% function [series_r holding_i input_r] = analyze_series_r ()
sweep_counter=handles.data.sweep_counter;
if get(handles.test_pulse,'Value') && ~(2 == get(handles.Cell1_type_popup,'Value'));

    ch1sweep=handles.data.ch1sweep;
    Fs=handles.defaults.Fs; 

    % find max and min around test pulse which should go from 50-100 ms
    Max = max(handles.data.ch1sweep((Fs*.040):(Fs*.060)));
    Min = min(handles.data.ch1sweep((Fs*.040):(Fs*.060)));
    peak_capacitance = Min - Max;
    handles.data.ch1.series_r(sweep_counter)=(-4/peak_capacitance)*1000; % multiply by 1000 to corrent for nA to pA conversion


    % analyze holding current for cells 1 & 2
    avg1=mean(handles.data.ch1sweep((Fs*0.03):round(Fs*0.035))); % have to use round to keep second limit as integer
    handles.data.ch1.holding_i(sweep_counter)=avg1;

    % analyze input resistance for cells 1 & 2
    R1=4/(mean(handles.data.ch1sweep((Fs*.080):(Fs*.095)))-mean(handles.data.ch1sweep((Fs*.01):(Fs*.02))));
    handles.data.ch1.input_r(sweep_counter)=R1*1000;
else
    handles.data.ch1.series_r(sweep_counter) = NaN;
    handles.data.ch1.holding_i(sweep_counter) = NaN;
    handles.data.ch1.input_r(sweep_counter) = NaN;
end
    

