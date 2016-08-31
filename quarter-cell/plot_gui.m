function handles = plot_gui(handles)

% if not first trial store elapsed time to current trial
currenttime = clock;
elapsed_time = etime(currenttime, handles.data.exp_start_time);
handles.data.trialtime(handles.data.sweep_counter) = elapsed_time;

elapsed_time_in_minutes = elapsed_time/60;

% draw current experiment time in whole cell1 axes
mins = floor(elapsed_time_in_minutes); % get minutes
secs = elapsed_time_in_minutes - mins;
secs = round(secs*60); % convert back to seconds
mins = num2str(mins);
 if (secs>9)
  secs = num2str(secs);
 else
  secs = num2str(secs);
  secs = strcat('0',secs);
 end
current_sweep_time = strcat(mins,':', secs);

set(handles.current_sweep_number,'String',num2str(handles.data.sweep_counter));
set(handles.current_run_number,'String',num2str(handles.run_count));

%% increment sweep counter
handles.data.sweep_counter=handles.data.sweep_counter+1; 

% test if should plot handles.io_data from channel2
plot_cell2 = get(handles.record_cell2_check, 'Value');




%% plot the handles.io_data on the corresponding axes in the GUI figure
if get(handles.test_pulse,'Value')
    pulse_over_sample = (handles.defaults.testpulse_start + handles.defaults.testpulse_duration + .1)*handles.defaults.Fs;
else
    pulse_over_sample = 1;
end
timebase = handles.data.timebase;

stim_sweep = handles.data.stim_sweep;
if get(handles.use_lut,'Value')
    stim_sweep = stim_sweep/max(stim_sweep)*handles.data.trial_metadata(end).pulseamp;
end

if get(handles.record_cell2_check,'Value')
    size(timebase(pulse_over_sample:end))
    size(handles.data.ch1sweep(pulse_over_sample:end))
    handles.current_trial_axes = plotyy(handles.current_trial_axes(1),timebase(pulse_over_sample:end),handles.data.ch1sweep(pulse_over_sample:end),timebase(pulse_over_sample:end),handles.data.ch2sweep(pulse_over_sample:end));
    set(handles.current_trial_axes(1),'xlim',[handles.data.timebase(pulse_over_sample) handles.data.timebase(end)])
    set(handles.current_trial_axes(2),'xlim',[handles.data.timebase(pulse_over_sample) handles.data.timebase(end)])
else
    size(timebase(pulse_over_sample:end))
    size(handles.data.ch1sweep(pulse_over_sample:end))
    handles.current_trial_axes(1)
    plot(handles.current_trial_axes(1),timebase(pulse_over_sample:end),handles.data.ch1sweep(pulse_over_sample:end));
    set(handles.current_trial_axes(1),'xlim',[handles.data.timebase(pulse_over_sample) handles.data.timebase(end)])
end


plot(handles.current_trial_stim_axes,timebase(pulse_over_sample:end),stim_sweep(pulse_over_sample:end))
set(handles.current_trial_stim_axes,'xlim',[handles.data.timebase(pulse_over_sample) handles.data.timebase(end)])
set(handles.current_trial_stim_axes,'xticklabel',[]);


% assignin('base','timebase',handles.data.timebase)


if get(handles.test_pulse,'Value')
    
    if get(handles.record_cell2_check,'Value')
        handles.testpulse_axes = plotyy(handles.testpulse_axes(1),handles.data.timebase(1:pulse_over_sample),handles.data.ch1sweep(1:pulse_over_sample),...
            handles.data.timebase(1:pulse_over_sample),handles.data.ch2sweep(1:pulse_over_sample));
    else
        plot(handles.testpulse_axes(1),handles.data.timebase(1:pulse_over_sample),handles.data.ch1sweep(1:pulse_over_sample));
    end
%     plot(handles.testpulse_axes,handles.data.timebase(1:pulse_over_sample),handles.data.ch1sweep(1:pulse_over_sample))


% axes(handles.Ih_axes)
% hold(handles.Ih_axes, 'on')
plot(handles.Ih_axes, handles.data.trialtime, handles.data.ch1.holding_i,'.-');
hold(handles.Ih_axes);
plot(handles.Ih_axes, handles.data.trialtime, handles.data.ch2.holding_i,'.-');
% hold(handles.Ih_axes, 'off')
set(handles.ih_text,'string',['Ih1: ' num2str(handles.data.ch1.holding_i(end)) ', Ih2: ' num2str(handles.data.ch2.holding_i(end))])
axis tight


plot(handles.Rs_axes, handles.data.trialtime, handles.data.ch1.series_r,'.-');
hold(handles.Rs_axes);
plot(handles.Rs_axes, handles.data.trialtime, handles.data.ch2.series_r,'.-');
% set(handles.Rs_axes,'ylim',[0 30])
% axis tight
set(handles.rs_text,'string',['Rs1: ' num2str(handles.data.ch1.series_r(end)) ', Rs2: ' num2str(handles.data.ch2.series_r(end))])

plot(handles.Ir_axes, handles.data.trialtime, handles.data.ch1.input_r,'.-')
hold(handles.Ir_axes);
plot(handles.Ir_axes, handles.data.trialtime, handles.data.ch2.input_r,'.-')
set(handles.ri_text,'string',['Ri1: ' num2str(handles.data.ch1.input_r(end)) ', Ri2: ' num2str(handles.data.ch2.input_r(end))])

axis tight

end

%% keep cursor lines on if checked % comment out to prevent cursur update
% if (get(handles.addcursors_radio,'Value')==1)
%     dualcursor([handles.data.analysis_limits.cell1(1) handles.data.analysis_limits.cell1(3)],[],[],[],handles.current_trial_axes); 
% end
% if (get(handles.addcursors_radio2,'Value')==1)
%      dualcursor([handles.data.analysis_limits.cell2(1) handles.data.analysis_limits.cell2(3)],[],[],[],handles.current_trial_axes); 
% end

% if (value3 == 1) % if recording two cells
%     plot(handles.Whole_cell2_axes,handles.data.ch2sweep);
%     plot(handles.Whole_cell2_axes_Ih,handles.data.ch2.holding_i,'o');
%     plot(handles.Whole_cell2_axes_Rs,handles.data.ch2.series_r,'o');
%     plot(handles.Whole_cell2_axes_Ir,handles.data.ch2.input_r,'o');
% end

% labelaxes(handles)

%% draw elapsed experiment time in whole cell1 axes
% ymax = get(handles.current_trial_axes, 'YLim'); ymax = ymax(2);
% xmax = get(handles.current_trial_axes, 'XLim'); xmax = xmax(2);
% if ymax > 0
%     text(0.9*xmax,0.9*ymax,current_sweep_time,'Parent',handles.current_trial_axes);
% else
%      text(0.9*xmax,1.1*ymax,current_sweep_time,'Parent',handles.current_trial_axes);
% end