function handles = process(handles)

stim_output = handles.data.stim_output;
ch1_output = handles.data.ch1_output; ch2_output=handles.data.ch2_output;

sweep_counter = handles.data.sweep_counter;

%store channels 1 and 2 in thissweep for further processing
thissweep = handles.io_data;


% scale units
if strcmp(handles.defaults.AO0,'ch1_out')==1 
    thissweep(:,1)=thissweep(:,1)*1000; % scale from nA to pA or Volts to mV
end

if strcmp(handles.defaults.AO1,'ch2_out')==1 
    thissweep(:,2)=thissweep(:,2)*1000; % scale from nA to pA or Volts to mV
end

% scale by user gain for each channel
thissweep(:,1)=thissweep(:,1)/handles.data.ch1.user_gain; 
thissweep(:,2)=thissweep(:,2)/handles.data.ch2.user_gain;


% store the handles.io_data in cell array 'handles.data.sweeps'
handles.data.sweeps{sweep_counter}=thissweep;
handles.data.trial_metadata(sweep_counter).spots_key = [];
handles.data.trial_metadata(sweep_counter).sequence = [];
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
        if isfield(handles.data,'spots_key')
            handles.data.trial_metadata(sweep_counter).spots_key = handles.data.spots_key;
            handles.data.trial_metadata(sweep_counter).sequence = handles.data.sequence;
        end
        
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
    handles.data.trial_metadata(sweep_counter).hologram_id = handles.roi_id;
end

handles.data.trial_metadata(sweep_counter).note = get(handles.notes,'String');
handles.data.trial_metadata(sweep_counter).lut_used = get(handles.use_lut,'Value');
handles.data.trial_metadata(sweep_counter).run_count = handles.run_count;
handles.data.trial_metadata(sweep_counter).test_trial = handles.is_test_trial;
handles.data.trial_metadata(sweep_counter).tf_on = get(handles.tf_on,'Value');

clamp_mode = get(handles.Cell1_type_popup,'Value');
switch clamp_mode
    case 1
        handles.data.trial_metadata(sweep_counter).cell1_clamp_type = 'voltage-clamp';
    case 2
        handles.data.trial_metadata(sweep_counter).cell1_clamp_type = 'current-clamp';
    case 3
        handles.data.trial_metadata(sweep_counter).cell1_clamp_type = 'cell-attached';
end

clamp_mode = get(handles.Cell2_type_popup,'Value');
switch clamp_mode
    case 1
        handles.data.trial_metadata(sweep_counter).cell2_clamp_type = 'voltage-clamp';
    case 2
        handles.data.trial_metadata(sweep_counter).cell2_clamp_type = 'current-clamp';
    case 3
        handles.data.trial_metadata(sweep_counter).cell2_clamp_type = 'cell-attached';
end

handles.data.trial_metadata(sweep_counter).cell1_highpass = get(handles.Highpass_cell1_check, 'Value');
handles.data.trial_metadata(sweep_counter).cell2_highpass = get(handles.Highpass_cell2_check, 'Value');

handles.data.trial_metadata(sweep_counter).obj_position = handles.data.obj_position;

if isfield(handles.data,'cell_pos')
    handles.data.trial_metadata(sweep_counter).cell_position = handles.data.cell_pos;
    handles.data.trial_metadata(sweep_counter).relative_position = handles.data.obj_position - handles.data.cell_pos;
else
    handles.data.trial_metadata(sweep_counter).cell_position = NaN;
    handles.data.trial_metadata(sweep_counter).relative_position = NaN;
end

if isfield(handles.data,'cell2_pos')
    handles.data.trial_metadata(sweep_counter).cell2_position = handles.data.cell2_pos;
    handles.data.trial_metadata(sweep_counter).relative_position_cell2 = handles.data.obj_position - handles.data.cell2_pos;
else
    handles.data.trial_metadata(sweep_counter).cell2_position = NaN;
    handles.data.trial_metadata(sweep_counter).relative_position_cell2 = NaN;
end

if isfield(handles.data,'start_pos')
    handles.data.trial_metadata(sweep_counter).start_position = handles.data.start_pos;
    handles.data.trial_metadata(sweep_counter).relative_to_start_position = handles.data.obj_position - handles.data.start_pos;
else
    handles.data.trial_metadata(sweep_counter).start_position = NaN;
    handles.data.trial_metadata(sweep_counter).relative_to_start_position = NaN;
end

%% store the analog outputs, but downsample them
handles.data.stims{sweep_counter}={downsample(stim_output,10), downsample(ch1_output,10), downsample(ch2_output,10)};

handles.data.ch1sweep = thissweep(:,1);
handles.data.ch2sweep = thissweep(:,2);

if get(handles.use_LED,'Value')
    handles.data.stim_sweep = stim_output;%    thissweep(:,4);
else
    handles.data.stim_sweep = thissweep(:,4);
end

%% high pass handles.data.sweeps if checked

if get(handles.Highpass_cell1_check, 'Value')
    handles.data.ch1sweep = highpass_filter(handles.data.ch1sweep,handles.defaults.Fs);
end
if get(handles.Highpass_cell2_check, 'Value')
    handles.data.ch2sweep = highpass_filter(handles.data.ch2sweep,handles.defaults.Fs);
end

%%
% after handles.io_data collection analzye inputs for series_r and other properties
handles = analyze_series_r(handles);


%% stores absolute time when first sweep is taken
if handles.data.sweep_counter == 1
   handles.data.exp_start_time = clock;
   handles.data.trialtime(handles.data.sweep_counter) = 0;
end


