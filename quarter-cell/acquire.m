function  handles = acquire(handles)
% this is the core function of acquisition. It is called by the timer
% function when triggering internally, and is the re-called for each
% trigger when using external triggers


stim_output = handles.data.stim_output;
ch1_output = handles.data.ch1_output; ch2_output=handles.data.ch2_output;
sweep_counter = handles.data.sweep_counter;

% generate analog output vectors for each trial

[AO0, AO1, AO2, AO3] = analogoutput_gen(handles);
handles.s.queueOutputData([AO0, AO1, AO2, AO3]);
%s.outputSingleScan([0 0 3 0])

%% start analog scanning and collect the data from the DAQ buffer into data.
% this is the core of the DAQ process
data = handles.s.startForeground();


%store channels 1 and 2 in thissweep for further processing
thissweep=data(:,1:2);


% scale units
if strcmp(handles.defaults.AO0,'ch1-primary')==1 
    thissweep=thissweep*1000; % scale from nA to pA or Volts to mV
else 
    thissweep=thissweep/1000; % what is this line for?
end

% scale by user gain for each channel
thissweep(:,1)=thissweep(:,1)/handles.data.ch1.user_gain; 
thissweep(:,2)=thissweep(:,2)/handles.data.ch2.user_gain;

% store the data in cell array 'handles.data.sweeps'
handles.data.sweeps{sweep_counter}=thissweep;

%% store the analog outputs, but downsample them
handles.data.stims{sweep_counter}={(downsample(stim_output,10)), downsample(ch1_output,10), downsample(ch2_output,10)};
set(handles.current_sweep_number,'String',num2str(sweep_counter));
handles.data.ch1sweep=thissweep(:,1);
handles.data.ch2sweep=thissweep(:,2);

%% high pass handles.data.sweeps if checked
value4 = get(handles.Highpass_check, 'Value');

if (value4 == 1)
    handles.data.ch1sweep=highpass_filter(handles.data.ch1sweep);
    handles.data.ch2sweep=highpass_filter(handles.data.ch2sweep);
end

%after data collection analzye inputs for series_r and other properties
handles = analyze_series_r(handles);

%% stores absolute time when first sweep is taken
if handles.data.sweep_counter == 1
   handles.data.exp_start_time = clock;
   handles.data.trialtime(handles.data.sweep_counter)= 0;
end

% if not first trial store elapsed time to current trial
currenttime = clock;
elapsed_time = etime(currenttime, handles.data.exp_start_time);
elapsed_time_in_minutes = elapsed_time/60; % convert to minutes
handles.data.trialtime(handles.data.sweep_counter) = elapsed_time_in_minutes;

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

%% increment sweep counter
handles.data.sweep_counter=handles.data.sweep_counter+1; 

% test if should plot data from channel2
value3 = get(handles.record_cell2_check, 'Value');




%% plot the data on the corresponding axes in the GUI figure
plot(handles.Whole_cell1_axes,handles.data.timebase,handles.data.ch1sweep);
plot(handles.Whole_cell1_axes_Ih, handles.data.trialtime, handles.data.ch1.holding_i,'o');

val = get(handles.Highpass_check, 'Value'); % check for highpass filtering
if (val == 1)
   plot(handles.Whole_cell1_axes_Rs, handles.data.trialtime, handles.data.ch1.spikerate1,'o');
else
   plot(handles.Whole_cell1_axes_Rs, handles.data.trialtime, handles.data.ch1.series_r,'o');
end

plot(handles.Whole_cell1_axes_Ir, handles.data.trialtime, handles.data.ch1.input_r,'o')


%% keep cursor lines on if checked % comment out to prevent cursur update
% if (get(handles.addcursors_radio,'Value')==1)
%     dualcursor([handles.data.analysis_limits.cell1(1) handles.data.analysis_limits.cell1(3)],[],[],[],handles.Whole_cell1_axes); 
% end
% if (get(handles.addcursors_radio2,'Value')==1)
%      dualcursor([handles.data.analysis_limits.cell2(1) handles.data.analysis_limits.cell2(3)],[],[],[],handles.Whole_cell1_axes); 
% end

if (value3 == 1) % if recording two cells
    plot(handles.Whole_cell2_axes,handles.data.timebase,handles.data.ch2sweep);
    plot(handles.Whole_cell2_axes_Ih,handles.data.ch2.holding_i,'o');
    plot(handles.Whole_cell2_axes_Rs,handles.data.ch2.series_r,'o');
    plot(handles.Whole_cell2_axes_Ir,handles.data.ch2.input_r,'o');
end

labelaxes(handles)
%% check if default saving checkbox is checked, otherwise don't save; when
% using external triggering avoid saving after each trial because saving
% can cause acquisition to miss triggers

saveval =  get(handles.default_save_check, 'Value');
if (saveval==1)
    save(handles.data.save_name);
end

%% draw elapsed experiment time in whole cell1 axes
ymax = get(handles.Whole_cell1_axes, 'YLim'); ymax = ymax(2);
xmax = get(handles.Whole_cell1_axes, 'XLim'); xmax = xmax(2);
if ymax > 0
    text(0.9*xmax,0.9*ymax,current_sweep_time,'Parent',handles.Whole_cell1_axes);
else
     text(0.9*xmax,1.1*ymax,current_sweep_time,'Parent',handles.Whole_cell1_axes);
end

guidata(get(src,'UserData'),handles)

