function handles = init(handles)

handles.run_type = handles.defaults.run_type;

switch handles.run_type
    case 'loop'
        set(handles.loop,'Value',1)
        set(handles.sequence,'Value',0)
    case 'sequence'
        set(handles.loop,'Value',0)
        set(handles.sequence,'Value',1)
end

handles.stim_type = handles.defaults.stim_type;
switch handles.stim_type
    case 'LED'
        set(handles.use_LED,'Value',1)
        set(handles.use_2P,'Value',0)
    case '2P'
        set(handles.use_LED,'Value',0)
        set(handles.use_2P,'Value',1)
end

handles.saptial_layout = handles.defaults.spatial_layout;
switch handles.saptial_layout
    case 'circles'
        set(handles.circles,'Value',1)
        set(handles.grid,'Value',0)
    case 'grid'
        set(handles.circles,'Value',0)
        set(handles.grid,'Value',1)
end

set(handles.current_sweep_number,'String',num2str(handles.data.sweep_counter));

set(handles.ExperimentName,'String',handles.data.experiment_name);

set(handles.SavePath,'String',handles.data.save_path);

SetSweepNumber=1;

set(handles.SetSweepNumber,'String',num2str(SetSweepNumber));

set(handles.deltacurrentpulseamp2,'String',handles.data.ch2.deltacurrentpulseamp2);

set(handles.ccpulsefreq2,'String',num2str(handles.data.ch2.pulsefrequency));

set(handles.ccpulsestarttime2,'String',num2str(handles.data.ch2.pulse_starttime));

set(handles.ccnumpulses2,'String',num2str(handles.data.ch2.pulsenumber));

set(handles.ccpulse_dur2,'String',num2str(handles.data.ch2.pulseduration));

set(handles.ccpulseamp2,'String',num2str(handles.data.ch2.pulseamp));

set(handles.deltacurrentpulseamp1,'String',num2str(handles.data.ch1.deltacurrentpulseamp1));

set(handles.ccpulsefreq1,'String',num2str(handles.data.ch1.pulsefrequency));

set(handles.ccpulsestarttime1,'String',num2str(handles.data.ch1.pulse_starttime));

set(handles.ccnumpulses1,'String',num2str(handles.data.ch1.pulsenumber));

set(handles.ccpulse_dur1,'String',num2str(handles.data.ch1.pulseduration));

set(handles.pulse_starttime,'String',num2str(handles.data.stimulation.pulse_starttime));

set(handles.ccpulseamp1,'String',num2str(handles.data.ch1.pulseamp));

set(handles.pulsefrequency,'String',num2str(handles.data.stimulation.pulsefrequency));

set(handles.pulsenumber,'String',num2str(handles.data.stimulation.pulsenumber));

set(handles.pulseduration,'String',num2str(handles.data.stimulation.pulseduration));

set(handles.pulseamp,'String',num2str(handles.data.stimulation.pulseamp));

set(handles.trial_length,'String',num2str(handles.defaults.trial_length));

set(handles.ITI,'String',num2str(handles.defaults.intertrial_interval));

handles.protocol_loaded = 0;
handles.run_count = 0;