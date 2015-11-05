function handles = process(handles)

stim_output = handles.data.stim_output;
ch1_output = handles.data.ch1_output; ch2_output=handles.data.ch2_output;

sweep_counter = handles.data.sweep_counter;

%store channels 1 and 2 in thissweep for further processing
thissweep=handles.io_data;


% scale units
if strcmp(handles.defaults.AO0,'ch1_out')==1 
    thissweep=thissweep*1000; % scale from nA to pA or Volts to mV
end

% scale by user gain for each channel
thissweep(:,1)=thissweep(:,1)/handles.data.ch1.user_gain; 
thissweep(:,2)=thissweep(:,2)/handles.data.ch2.user_gain;


% store the handles.io_data in cell array 'handles.data.sweeps'
handles.data.sweeps{sweep_counter}=thissweep;

%% store the analog outputs, but downsample them
handles.data.stims{sweep_counter}={downsample(stim_output,10), downsample(ch1_output,10), downsample(ch2_output,10)};
set(handles.current_sweep_number,'String',num2str(sweep_counter));
handles.data.ch1sweep=thissweep(:,1);
handles.data.ch2sweep=thissweep(:,2);
if get(handles.use_LED,'Value')
    handles.data.stim_sweep = thissweep(:,3);
else
    handles.data.stim_sweep = thissweep(:,4);
end

%% high pass handles.data.sweeps if checked

% if get(handles.Highpass_cell1_check, 'Value')
%     handles.data.ch1sweep=highpass_filter(handles.data.ch1sweep);
% end
% if get(handles.Highpass_cell2_check, 'Value')
%     handles.data.ch2sweep=highpass_filter(handles.data.ch2sweep);
% end

%%
%after handles.io_data collection analzye inputs for series_r and other properties
handles = analyze_series_r(handles);

%% stores absolute time when first sweep is taken
if handles.data.sweep_counter == 1
   handles.data.exp_start_time = clock;
   handles.data.trialtime(handles.data.sweep_counter) = 0;
end


