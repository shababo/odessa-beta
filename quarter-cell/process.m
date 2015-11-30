function handles = process(handles)

stim_output = handles.data.stim_output;
ch1_output = handles.data.ch1_output; ch2_output=handles.data.ch2_output;

sweep_counter = handles.data.sweep_counter;

%store channels 1 and 2 in thissweep for further processing
thissweep=handles.io_data;


% scale units
if strcmp(handles.defaults.AO0,'ch1_out')==1 
    thissweep(:,1)=thissweep(:,1)*1000; % scale from nA to pA or Volts to mV
end

% scale by user gain for each channel
thissweep(:,1)=thissweep(:,1)/handles.data.ch1.user_gain; 
thissweep(:,2)=thissweep(:,2)/handles.data.ch2.user_gain;


% store the handles.io_data in cell array 'handles.data.sweeps'
handles.data.sweeps{sweep_counter}=thissweep;

switch handles.run_type
    case 'loop'
        
        if isfield(handles.data,'lut') && get(handles.use_lut,'Value')
            handles.data.trial_metadata(sweep_counter).amp_units = 'mW';
        else
            handles.data.trial_metadata(sweep_counter).amp_units = 'V';
        end
        
        handles.data.trial_metadata(sweep_counter).pulseamp = handles.data.stimulation.pulseamp;
        handles.data.trial_metadata(sweep_counter).pulseduration = handles.data.stimulation.pulseduration;
        handles.data.trial_metadata(sweep_counter).pulsenumber = handles.data.stimulation.pulsenumber;
        handles.data.trial_metadata(sweep_counter).pulsefrequency = handles.data.stimulation.pulsefrequency;
        handles.data.trial_metadata(sweep_counter).pulse_starttime = handles.data.stimulation.pulse_starttime;
        
        
    case 'conditions'
        
        if isfield(handles.data,'lut') && get(handles.use_lut,'Value')
            handles.data.trial_metadata(sweep_counter).amp_units = 'mW';
        else
            handles.data.trial_metadata(sweep_counter).amp_units = 'V';
        end
        
        handles.data.trial_metadata(sweep_counter).pulseamp = handles.data.stim_conds.amps(handles.data.tmp.cond_ind(1));
        handles.data.trial_metadata(sweep_counter).pulseduration = handles.data.stim_conds.durations(handles.data.tmp.cond_ind(2));
        handles.data.trial_metadata(sweep_counter).pulsenumber = handles.data.stim_conds.numpulses(handles.data.tmp.cond_ind(3));
        handles.data.trial_metadata(sweep_counter).pulsefrequency = handles.data.stim_conds.freqs(handles.data.tmp.cond_ind(4));
        handles.data.trial_metadata(sweep_counter).pulse_starttime =handles.data.stim_conds.starttimes(handles.data.tmp.cond_ind(5));
end
        

if get(handles.use_LED,'Value')
    handles.data.trial_metadata(sweep_counter).stim_type = 'LED';
    handles.data.trial_metadata(sweep_counter).hologram_id = 'N/A';
else
    handles.data.trial_metadata(sweep_counter).stim_type = '2P';
    handles.data.trial_metadata(sweep_counter).hologram_id = get(handles.hologram_id,'String');
end

handles.data.trial_metadata(sweep_counter).note = get(handles.notes,'String');
handles.data.trial_metadata(sweep_counter).lut_used = get(handles.use_lut,'Value');
handles.data.trial_metadata(sweep_counter).run_count = handles.run_count;

clamp_mode = get(handles.Cell1_type_popup,'Value');
switch clamp_mode
    case 1
        handles.data.trial_metadata(sweep_counter).clamp_type = 'voltage-clamp';
    case 2
        handles.data.trial_metadata(sweep_counter).clamp_type = 'current-clamp';
end


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


