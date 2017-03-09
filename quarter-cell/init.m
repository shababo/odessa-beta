function handles = init(handles)

handles.run_type = handles.defaults.run_type;

switch handles.run_type
    case 'loop'
        set(handles.loop,'Value',1)
        set(handles.conditions,'Value',0)
    case 'conditions'
        set(handles.loop,'Value',0)
        set(handles.conditions,'Value',1)
end

load(handles.defaults.lut_file1,'lut','ratio_map')
handles.data.lut = lut;
handles.data.ratio_map = ratio_map;
set(handles.load_lut,'ForegroundColor',[0 .5 .5])

handles.roi_id = handles.defaults.roi_id;
switch handles.roi_id
    case 'roi1'
        set(handles.roi1,'Value',1)
        set(handles.roi2,'Value',0)
        set(handles.roi3,'Value',0)
        load(handles.defaults.lut_file1,'lut')
        

   case 'roi2'
        set(handles.roi1,'Value',0)
        set(handles.roi2,'Value',1)
        set(handles.roi3,'Value',0)
        load(handles.defaults.lut_file2,'lut')

    case 'roi3'
        set(handles.roi1,'Value',0)
        set(handles.roi2,'Value',0)
        set(handles.roi3,'Value',1)    
        load(handles.defaults.lut_file3,'lut')

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

handles.spatial_layout = handles.defaults.spatial_layout;
switch handles.spatial_layout
    case 'cross'
        set(handles.cross,'Value',1)
        set(handles.grid,'Value',0)
        set(handles.locations,'Value',0)
    case 'grid'
        set(handles.cross,'Value',0)
        set(handles.grid,'Value',1)
        set(handles.locations,'Value',0)
    case 'locations'
        set(handles.cross,'Value',0)
        set(handles.grid,'Value',0)
        set(handles.locations,'Value',1)
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

set(handles.ccpulseamp1,'String',num2str(handles.data.ch1.pulseamp));

set(handles.trial_length,'String',num2str(handles.defaults.trial_length));

set(handles.ITI,'String',num2str(handles.defaults.intertrial_interval));

set(handles.comnum,'String',num2str(handles.defaults.comnum));
get(handles.comnum,'String')

handles.protocol_loaded = 0;

% connect to MPC200
if ~isempty(instrfind)
    fclose(instrfind);
end
% handles.mpc200 = serial(strcat('COM',get(handles.comnum,'String')),'BaudRate',128000,'Terminator','CR');
% fopen(handles.mpc200); %UNCOMMENT FOR OBJECTIVE CONTROL!!
% handles.mpc200.Parity = 'none';
% set(handles.mpc200_status,'String','Connected to MPC-200/NOT Calib');




handles.run_count = 0;