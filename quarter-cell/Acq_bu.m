function varargout = Acq_bu(varargin)

% ACQ_BU MATLAB code for Acq_bu.fig
%      ACQ_BU, by itself, creates a new ACQ_BU or raises the existing
%      singleton*.
%
%      H = ACQ_BU returns the handle to a new ACQ_BU or the handle to
%      the existing singleton*.
%
%      ACQ_BU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACQ_BU.M with the given input arguments.
%
%      ACQ_BU('Property','Value',...) creates a new ACQ_BU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Acq_bu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Acq_bu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Acq_bu

% Last Modified by G UIDE v2.5 13-Feb-2013 14:39:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Acq_bu_OpeningFcn, ...
                   'gui_OutputFcn',  @Acq_bu_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Acq_bu is made visible.
function Acq_bu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Acq_bu (see VARARGIN)

% Choose default command line output for Acq_bu
handles.output = hObject; 

% create experiment structs
[handles.defaults, handles.s, handles.data] = load_defaults;

% generate analog outputs
handles.data = setup_input_output(handles.data, handles.defaults);

handles = init(handles);

% handles.globalTimer=timer('TimerFcn', @acquire, 'TaskstoExecute', handles.defaults.total_sweeps, ...
%     'Period', handles.defaults.ISI, 'ExecutionMode','fixedRate','UserData',hObject);
% handles.globalTimer.BusyMode='error';

labelaxes(handles)


% Update handles structure
guidata(hObject, handles);


% UIWAIT makes Acq_bu wait for user response (see UIRESUME)
% uiwait(handles.acq_gui);


% --- Outputs from this function are returned to the command line.
function varargout = Acq_bu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Whole_cell1_axes_CreateFcn(hObject, eventdata, handles)

% Hint: place code in OpeningFcn to populate Whole_cell1_axes





% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% str2double(get(handles.ITI,'String'))
% handles.globalTimer=timer('TimerFcn', @acquire, 'TaskstoExecute', handles.defaults.total_sweeps, 'Period',str2double(get(handles.ITI,'String')), 'ExecutionMode','fixedRate','UserData',handles);
% guidata(hObject,handles)



default_color = [0.8627    0.8627    0.8627]; % grey
set(hObject,'BackgroundColor',[0 1 .5]);

switch handles.run_type
    case 'loop'
        disp('looping...')
        if get(handles.loop_forever,'Value')
            while get(hObject,'Value')
%                 handles = make_stim_out(handles);
                handles.io_data = step_loop(handles);
                handles = process_and_wait(handles,str2double(get(handles.ITI,'String')));
            end
        else
            for loop_ind = 1:str2num(get(handles.loop_count,'String'))
                handles.io_data = step_loop(handles);
                handles = process_and_wait(handles,str2double(get(handles.ITI,'String')));
                if ~get(hObject,'Value')
                    break
                end
            end
        end
        set(hObject,'Value',0)
    case 'sequence'
        disp('sequencing...')
        %run sequence
        if handles.protocol_loaded
            for i = 1:length(handles.protocol)
                handles.io_data = io(handles.s,handles.protocol(i).output);
                handles = process_and_wait(handles,handles.protocol(i).intertrial_interval);
                if ~get(hObject,'Value')
                    break
                end
            end
        end
        set(hObject,'Value',0)
    case 'conditions'
        disp('running conditions')
        if get(handles.use_seed,'Value')
            rng(ceil(str2double(handles.rng_seed,'String')));
        end
        conditions = repmat(1:size(handles.data.stim_conds.cond_inds,1),1,str2double(get(handles.num_trials,'String')))
        conditions = conditions(randperm(length(conditions)))
        
        for i = 1:length(conditions)
            
            conditions(i)
            start_color = get(handles.run,'BackgroundColor');
            set(handles.run,'BackgroundColor',[1 0 0]);
            set(handles.run,'String','Acq...')
            [AO0, AO1, AO2, AO3] = analogoutput_gen(handles);
            
            cond_ind = handles.data.stim_conds.cond_inds(conditions(i),:);

            handles.io_data = io(handles.s,[AO0, AO1, squeeze(handles.data.stim_conds.stims(cond_ind(1),cond_ind(2),cond_ind(3),cond_ind(4),cond_ind(5),:)), AO3]);

            set(handles.run,'backgroundColor',start_color)
            guidata(handles.acq_gui,handles)
            
            handles = process_and_wait(handles,str2double(get(handles.ITI,'String')));
            
            if ~get(hObject,'Value')
                break
            end
        end
        set(hObject,'Value',0)
        
end
        
set(hObject,'String','Start');
set(hObject,'BackgroundColor',default_color);

% update fields
handles = trial_length_Callback(handles.trial_length, [], handles);

guidata(hObject,handles)

function handles = process_and_wait(handles,wait_time)

start_time = clock;
set(handles.run,'String','Process')
handles = process(handles);
drawnow
% PUT PLOT HERE! (take out of process.m)
set(handles.run,'String','ITI')
drawnow
    while etime(clock, start_time) < wait_time
    end
drawnow



% --- Executes during object creation, after setting all properties.
function ITI_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function handles = trial_length_Callback(hObject, eventdata, handles)

trial_length = str2double(get(hObject,'String'));
handles.defaults.trial_length = trial_length;

handles = make_stim_out(handles);

% [handles.data.stim_output,handles.data.timebase] = ...
%     makepulseoutputs(handles.data.stimulation.pulse_starttime,handles.data.stimulation.pulsenumber, handles.data.stimulation.pulseduration,...
%     handles.data.stimulation.pulseamp, handles.data.stimulation.pulsefrequency, handles.defaults.Fs, trial_length);

 
handles.data.ch1_output=makepulseoutputs(handles.data.ch1.pulse_starttime,handles.data.ch1.pulsenumber, handles.data.ch1.pulseduration, handles.data.ch1.pulseamp, handles.data.ch1.pulsefrequency, handles.defaults.Fs, trial_length);
handles.data.ch2_output=makepulseoutputs(handles.data.ch2.pulse_starttime,handles.data.ch2.pulsenumber, handles.data.ch2.pulseduration, handles.data.ch2.pulseamp, handles.data.ch2.pulsefrequency, handles.defaults.Fs, trial_length);
handles.data.ch1_output=handles.data.ch1_output/handles.defaults.CCexternalcommandsensitivity;
handles.data.ch2_output=handles.data.ch2_output/handles.defaults.CCexternalcommandsensitivity;
handles.data.testpulse = makepulseoutputs(handles.defaults.testpulse_start, 1, handles.defaults.testpulse_duration, handles.defaults.testpulse_amp, 1, handles.defaults.Fs, trial_length);
guidata(hObject,handles)

handles = updateAOaxes(handles);
guidata(hObject,handles)




% --- Executes during object creation, after setting all properties.
function trial_length_CreateFcn(hObject, eventdata, handles)
 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
   
end



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)

makeoutputs


% --- Executes during object creation, after setting all properties.
function Whole_cell1_axes_Rs_CreateFcn(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function test_pulse_CreateFcn(hObject, eventdata, handles)

% --- Executes on button press in ext_cmd_2_check.
function ext_cmd_2_check_Callback(hObject, eventdata, handles)

% Hint: get(hObject,'Value') returns toggle state of ext_cmd_2_check

% --- Executes on button press in VC_toggle_WC1.
function VC_toggle_WC1_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of VC_toggle_WC1


% --- Executes on button press in VC_toggle_WC2.
function VC_toggle_WC2_Callback(hObject, eventdata, handles)

% Hint: get(hObject,'Value') returns toggle state of VC_toggle_WC2



function pulseamp_Callback(hObject, eventdata, handles)

handles.data.stimulation.pulseamp=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of pulseamp as text
%        str2double(get(hObject,'String')) returns contents of pulseamp as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pulseamp_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pulseduration_Callback(hObject, eventdata, handles)


handles.data.stimulation.pulseduration=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of pulseduration as text
%        str2double(get(hObject,'String')) returns contents of pulseduration as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pulseduration_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pulsenumber_Callback(hObject, eventdata, handles)


handles.data.stimulation.pulsenumber=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of pulsenumber as text
%        str2double(get(hObject,'String')) returns contents of pulsenumber as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pulsenumber_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pulsefrequency_Callback(hObject, eventdata, handles)

handles.data.stimulation.pulsefrequency=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of pulsefrequency as text
%        str2double(get(hObject,'String')) returns contents of pulsefrequency as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pulsefrequency_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

   

function pulse_starttime_Callback(hObject, eventdata, handles)

handles.data.stimulation.pulse_starttime=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of pulse_starttime as text
%        str2double(get(hObject,'String')) returns contents of pulse_starttime as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pulse_starttime_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in update_pulses_button.
function update_pulses_button_Callback(hObject, eventdata, handles)




% handles.data.shutter=makepulseoutputs(handles.data.stimulation.pulse_starttime-shutterlag,handles.data.stimulation.pulsenumber, handles.data.stimulation.pulseduration+shutterlag, shutteramp, handles.data.stimulation.pulsefrequency, handles.defaults.Fs, handles.defaults.trial_length);
handles = make_stim_out(handles);
% if isfield(handles.data,'lut') && get(handles.use_lut,'Value')
%     amplitude = get_voltage(handles.data.lut,handles.data.stimulation.pulseamp);
%     if isempty(amplitude)
%         amplitude = 0;
%     end
% else
%     amplitude = handles.data.stimulation.pulseamp;
% end
% handles.data.stim_output=makepulseoutputs(handles.data.stimulation.pulse_starttime,handles.data.stimulation.pulsenumber, handles.data.stimulation.pulseduration, amplitude, handles.data.stimulation.pulsefrequency, handles.defaults.Fs, handles.defaults.trial_length);
% handles.data.stim_output=handles.data.stim_output; % for laser diode drivers need -1V holding voltage
% handles.data.pulsesorramps=0;
handles = updateAOaxes(handles);
guidata(hObject,handles)

function handles = make_stim_out(handles)

handles.data.stimulation.pulseamp=str2double(get(handles.pulseamp,'String'));
handles.data.stimulation.pulseduration=str2double(get(handles.pulseduration,'String'));
handles.data.stimulation.pulsenumber=str2double(get(handles.pulsenumber,'String'));
handles.data.stimulation.pulsefrequency=str2double(get(handles.pulsefrequency,'String'));
handles.data.stimulation.pulse_starttime=str2double(get(handles.pulse_starttime,'String'));

if isfield(handles.data,'lut') && get(handles.use_lut,'Value')
    amplitude = get_voltage(handles.data.lut,handles.data.stimulation.pulseamp);
    if isempty(amplitude)
        amplitude = 0;
    end
else
    amplitude = handles.data.stimulation.pulseamp;
end
[handles.data.stim_output, handles.data.timebase]=makepulseoutputs(handles.data.stimulation.pulse_starttime,handles.data.stimulation.pulsenumber, handles.data.stimulation.pulseduration, amplitude, handles.data.stimulation.pulsefrequency, handles.defaults.Fs, handles.defaults.trial_length);



% --- Executes on button press in VC_cell1_radio.
function VC_cell1_radio_Callback(hObject, eventdata, handles)


if get(hObject,'Value')~=1
    ylabel(handles.Whole_cell1_axes,'mV')
    % ylabel(handles.CCoutput_axes,'pA')
    if get(handles.LFP_check, 'Value')~=1 
        handles.data.ch1.user_gain=20; % set gain to 20 for whole cell current clamp
    else
        handles.data.ch1.user_gain=500; % set gain to 500 for LFP recording
    end
    
else
    
    handles.data.ch1.user_gain=1;
    ylabel(handles.Whole_cell1_axes,'pA')  
    % ylabel(handles.CCoutput_axes,'mV')
end
handles.data.ch1_output=makepulseoutputs(handles.data.ch1.pulse_starttime,handles.data.ch1.pulsenumber, handles.data.ch1.pulseduration, handles.data.ch1.pulseamp, handles.data.ch1.pulsefrequency, handles.defaults.Fs, handles.defaults.trial_length);
handles.data.ch1_output=handles.data.ch1_output/handles.data.ch1.externalcommandsensitivity;
handles.data.ch2_output=makepulseoutputs(handles.data.ch2.pulse_starttime,handles.data.ch2.pulsenumber, handles.data.ch2.pulseduration, handles.data.ch2.pulseamp, handles.data.ch2.pulsefrequency, handles.defaults.Fs, handles.defaults.trial_length);
handles.data.ch2_output=handles.data.ch2_output/handles.data.ch1.externalcommandsensitivity;
% Hint: get(hObject,'Value') returns toggle state of VC_cell1_radio
guidata(hObject,handles)

% --- Executes on button press in VC_cell2_radio.
function VC_cell2_radio_Callback(hObject, eventdata, handles)


if get(hObject,'Value')~=1
    ylabel(handles.Whole_cell2_axes,'mV')
    handles.data.ch2.user_gain=20;
else
    ylabel(handles.Whole_cell2_axes,'pA')  
    handles.data.ch2.user_gain=1;
end
% Hint: get(hObject,'Value') returns toggle state of VC_cell2_radio
guidata(hObject,handles)


% --- Executes on button press in previoussweep_button.
function previoussweep_button_Callback(hObject, eventdata, handles)



SetSweepNumber=handles.data.SetSweepNumber;
thissweep=handles.data.thissweep;
SetSweepNumber=SetSweepNumber-1; 
if (SetSweepNumber < 1) % if trying to view traces that don't exist yet get error
        
else


handles.data.SetSweepNumber=SetSweepNumber;
value3 = get(handles.record_cell2_check, 'Value'); % check if dual whole cell
set(handles.SetSweepNumber,'String',num2str(SetSweepNumber));
sweeppoints=size(handles.data.sweeps{SetSweepNumber});
tim=linspace(0,sweeppoints(:,1)/handles.defaults.Fs,sweeppoints(:,1));

val4 = get(handles.axes_hold_check, 'Value'); % check if dual whole cell
% if checked get current axes limits
if (val4 == 1)
    xlimits = get(handles.sweep_display_axes,'xlim');
    ylimits = get(handles.sweep_display_axes, 'ylim');
end

val = get(handles.Highpass_check, 'Value'); % check for highpass filtering

if (value3==1)
    thissweep=handles.data.sweeps{handles.data.SetSweepNumber}; 
    thissweep1=thissweep(:,1);
    thissweep1= smart_zero(thissweep1,handles);
    thissweep2=thissweep(:,2);
    thissweep2 = smart_zero(thissweep2,handles);
    plot(handles.sweep_display_axes,tim, thissweep1, tim, thissweep2);
else
    thissweep=handles.data.sweeps{SetSweepNumber}; 
    thissweep=thissweep(:,1);
    thissweep=thissweep-mean(thissweep(1:20000));
    if (val == 1)
        thissweep=highpass_filter(thissweep); % if checked highpass filter
    end  
    plot(handles.sweep_display_axes,tim, thissweep); % if just single cell just plot cell1
end

if val4 == 1 % if holding axes limits
    xlim(handles.sweep_display_axes, [xlimits(1) xlimits(2)]);
    ylim(handles.sweep_display_axes, [ylimits(1) ylimits(2)]);
end

xlabel(handles.sweep_display_axes, 'seconds')
ylabel(handles.sweep_display_axes, 'pA')
% set(handles.stimulus_num,'String',num2str(handles.data.motorstim(handles.data.SetSweepNumber)));
%     set(handles.stimulus_num,'String',num2str(handles.data.stimulus_sequence(handles.data.SetSweepNumber)));

end

guidata(hObject,handles)

% --- Executes on button press in nextsweep_button.
function nextsweep_button_Callback(hObject, eventdata, handles)


SetSweepNumber=handles.data.SetSweepNumber; 
thissweep=handles.data.thissweep;
sweep_counter=handles.data.sweep_counter;
sweepcount=size(handles.data.sweeps);
if (SetSweepNumber >= sweepcount(2)) % if trying to view traces that don't exist yet get error
    
else
    
val = get(handles.Highpass_check, 'Value');

 
handles.data.SetSweepNumber=handles.data.SetSweepNumber+1;

value3 = get(handles.record_cell2_check, 'Value'); % check if dual whole cell
 set(handles.SetSweepNumber,'String',num2str(handles.data.SetSweepNumber));
sweeppoints=size(handles.data.sweeps{handles.data.SetSweepNumber});
tim=linspace(0,sweeppoints(:,1)/handles.defaults.Fs,sweeppoints(:,1));

val4 = get(handles.axes_hold_check, 'Value'); % check if dual whole cell
% if checked get current axes limits
if (val4 == 1)
    xlimits = get(handles.sweep_display_axes,'xlim');
    ylimits = get(handles.sweep_display_axes, 'ylim');
end

if (value3==1)
    thissweep=handles.data.sweeps{handles.data.SetSweepNumber}; 
    thissweep1=thissweep(:,1);
    thissweep1= smart_zero(thissweep1,handles);
    thissweep2=thissweep(:,2);
    thissweep2 = smart_zero(thissweep2,handles);
    plot(handles.sweep_display_axes,tim, thissweep1, tim, thissweep2);
else
    thissweep=handles.data.sweeps{handles.data.SetSweepNumber}; 
    thissweep=thissweep(:,1);
    thissweep = smart_zero(thissweep,handles);
%     thissweep=thissweep-mean(thissweep(1:20000));
    if (val == 1)
        thissweep=highpass_filter(thissweep); % if checked highpass filter
    end  
    plot(handles.sweep_display_axes,tim, thissweep); % if just single cell just plot cell1
end

if val4 == 1 % if holding axes limits
    xlim(handles.sweep_display_axes, [xlimits(1) xlimits(2)]);
    ylim(handles.sweep_display_axes, [ylimits(1) ylimits(2)]);
end

xlabel(handles.sweep_display_axes, 'seconds')
ylabel(handles.sweep_display_axes, 'pA')
% set(handles.stimulus_num,'String',num2str(handles.data.motorstim(handles.data.SetSweepNumber)));
% set(handles.stimulus_num,'String',num2str(handles.data.stimulus_sequence(handles.data.SetSweepNumber)));
% set(handles.stimulus_num,'String',num2str(handles.data.VisStimSeq(handles.data.SetSweepNumber)));
end

guidata(hObject,handles)


% --- Executes on button press in update_cc_cell1_button.
function update_cc_cell1_button_Callback(hObject, eventdata, handles)

handles.data.ch1_output=makepulseoutputs(handles.data.ch1.pulse_starttime,handles.data.ch1.pulsenumber, handles.data.ch1.pulseduration, handles.data.ch1.pulseamp, handles.data.ch1.pulsefrequency, handles.defaults.Fs, handles.defaults.trial_length);
handles.data.ch1_output=handles.data.ch1_output/handles.defaults.CCexternalcommandsensitivity; % scale by external command sensititvity under Current Clamp
handles = updateAOaxes(handles);

guidata(hObject,handles)


% --- Executes on button press in update_cc_cell2_button.
function update_cc_cell2_button_Callback(hObject, eventdata, handles)

handles.data.ch2_output=makepulseoutputs(handles.data.ch2.pulse_starttime,handles.data.ch2.pulsenumber, handles.data.ch2.pulseduration, handles.data.ch2.pulseamp, handles.data.ch2.pulsefrequency, handles.defaults.Fs, handles.defaults.trial_length);
handles.data.ch2_output=handles.data.ch2_output/handles.defaults.CCexternalcommandsensitivity;
handles = updateAOaxes(handles);

guidata(hObject,handles)

function ccpulseamp2_Callback(hObject, eventdata, handles)


handles.data.ch2.pulseamp=str2double(get(hObject,'String'))
% Hints: get(hObject,'String') returns contents of ccpulseamp2 as text
%        str2double(get(hObject,'String')) returns contents of ccpulseamp2 as a double
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function ccpulseamp2_CreateFcn(hObject, eventdata, handles)


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ccpulse_dur2_Callback(hObject, eventdata, handles)


handles.data.ch2.pulseduration=str2double(get(hObject,'String'));

% Hints: get(hObject,'String') returns contents of ccpulse_dur2 as text
%        str2double(get(hObject,'String')) returns contents of ccpulse_dur2 as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function ccpulse_dur2_CreateFcn(hObject, eventdata, handles)


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ccnumpulses2_Callback(hObject, eventdata, handles)


handles.data.ch2.pulsenumber=str2double(get(hObject,'String'));

% Hints: get(hObject,'String') returns contents of ccnumpulses2 as text
%        str2double(get(hObject,'String')) returns contents of ccnumpulses2 as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function ccnumpulses2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ccpulsestarttime2_Callback(hObject, eventdata, handles)


handles.data.ch2.pulse_starttime=str2double(get(hObject,'String'));

% Hints: get(hObject,'String') returns contents of ccpulsestarttime2 as text
%        str2double(get(hObject,'String')) returns contents of ccpulsestarttime2 as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function ccpulsestarttime2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ccpulseamp1_Callback(hObject, eventdata, handles)

handles.data.ch1.pulseamp=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of ccpulseamp1 as text
%        str2double(get(hObject,'String')) returns contents of ccpulseamp1 as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function ccpulseamp1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ccpulse_dur1_Callback(hObject, eventdata, handles)


handles.data.ch1.pulseduration=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of ccpulse_dur1 as text
%        str2double(get(hObject,'String')) returns contents of ccpulse_dur1 as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function ccpulse_dur1_CreateFcn(hObject, eventdata, handles)


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ccnumpulses1_Callback(hObject, eventdata, handles)

handles.data.ch1.pulsenumber=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of ccnumpulses1 as text
%        str2double(get(hObject,'String')) returns contents of ccnumpulses1 as a double


% --- Executes during object creation, after setting all properties.
function ccnumpulses1_CreateFcn(hObject, eventdata, handles)


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ccpulsestarttime1_Callback(hObject, eventdata, handles)


handles.data.ch1.pulse_starttime=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of ccpulsestarttime1 as text
%        str2double(get(hObject,'String')) returns contents of ccpulsestarttime1 as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function ccpulsestarttime1_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SetSweepNumber_Callback(hObject, eventdata, handles)


SetSweepNumber=handles.data.SetSweepNumber;
thissweep=handles.data.thissweep;

handles.data.SetSweepNumber=str2double(get(hObject,'String'));
sweeppoints=size(handles.data.sweeps{handles.data.SetSweepNumber});
tim=linspace(0,sweeppoints(:,1)/handles.defaults.Fs,sweeppoints(:,1));
value3 = get(handles.record_cell2_check, 'Value'); % check if dual whole cell

val4 = get(handles.axes_hold_check, 'Value'); % check if dual whole cell
% if checked get current axes limits
if (val4 == 1)
    xlimits = get(handles.sweep_display_axes,'xlim');
    ylimits = get(handles.sweep_display_axes, 'ylim');
end

if (value3==1)
    thissweep=handles.data.sweeps{handles.data.SetSweepNumber}; 
    thissweep1=thissweep(:,1);
    thissweep1= smart_zero(thissweep1,handles);
    thissweep2=thissweep(:,2);
    thissweep2 = smart_zero(thissweep2,handles);
    plot(handles.sweep_display_axes,tim, thissweep1, tim, thissweep2);
else
    thissweep=handles.data.sweeps{handles.data.SetSweepNumber}; 
    thissweep=thissweep(:,1);
    plot(handles.sweep_display_axes,tim, thissweep); % if just single cell just plot cell1
end
% set(handles.stimulus_num,'String',num2str(handles.data.stimulus_sequence(handles.data.SetSweepNumber)));

if val4 == 1 % if holding axes limits
    xlim(handles.sweep_display_axes, [xlimits(1) xlimits(2)]);
    ylim(handles.sweep_display_axes, [ylimits(1) ylimits(2)]);
end

xlabel(handles.sweep_display_axes, 'seconds')
ylabel(handles.sweep_display_axes, 'pA')
% Hints: get(hObject,'String') returns contents of SetSweepNumber as text
%        str2double(get(hObject,'String')) returns contents of SetSweepNumber as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function SetSweepNumber_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SavePath_Callback(hObject, eventdata, handles)

handles.data.save_path=(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of SavePath as text
%        str2double(get(hObject,'String')) returns contents of SavePath as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function SavePath_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ExperimentName_Callback(hObject, eventdata, handles)

handles.data.experiment_name=(get(hObject,'String'));
handles.data.save_name = [handles.data.save_path handles.data.experiment_name];
if exist(handles.data.save_name,'file')
    handles.data.save_name = [handles.data.save_name(1:end-4) 'next.mat'];
end
guidata(hObject,handles)

function ExperimentName_CreateFcn(hObject, eventdata, handles)



if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function current_sweep_number_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function current_sweep_number_CreateFcn(hObject, eventdata, handles)



if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ccpulsefreq2_Callback(hObject, eventdata, handles)

handles.data.ch2.pulsefrequency=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of ccpulsefreq2 as text
%        str2double(get(hObject,'String')) returns contents of ccpulsefreq2 as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function ccpulsefreq2_CreateFcn(hObject, eventdata, handles)


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ccpulsefreq1_Callback(hObject, eventdata, handles)

handles.data.ch1.pulsefrequency=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of ccpulsefreq1 as text
%        str2double(get(hObject,'String')) returns contents of ccpulsefreq1 as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function ccpulsefreq1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in autogen_cell1_check.
function autogen_cell1_check_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of autogen_cell1_check

% --- Executes on button press in autogen_cell2_check.
function autogen_cell2_check_Callback(hObject, eventdata, handles)

% Hint: get(hObject,'Value') returns toggle state of autogen_cell2_check

function deltacurrentpulseamp1_Callback(hObject, eventdata, handles)

handles.data.ch1.deltacurrentpulseamp1=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of deltacurrentpulseamp2 as text
%        str2double(get(hObject,'String')) returns contents of deltacurrentpulseamp2 as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function deltacurrentpulseamp1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltacurrentpulseamp2_Callback(hObject, eventdata, handles)

handles.data.ch2.deltacurrentpulseamp2=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of deltacurrentpulseamp2 as text
%        str2double(get(hObject,'String')) returns contents of deltacurrentpulseamp2 as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function deltacurrentpulseamp2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hold_sweep_display_axes.
function hold_sweep_display_axes_Callback(hObject, eventdata, handles)

hold(handles.sweep_display_axes);
% Hint: get(hObject,'Value') returns toggle state of hold_sweep_display_axes


% --- Executes on button press in record_cell2_check.
function record_cell2_check_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of record_cell2_check

% --- Executes on button press in Highpass_check.
function Highpass_check_Callback(hObject, eventdata, handles)

% Hint: get(hObject,'Value') returns toggle state of Highpass_check


function highpass_freq1_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of highpass_freq1 as text
%        str2double(get(hObject,'String')) returns contents of highpass_freq1 as a double

% --- Executes during object creation, after setting all properties.
function highpass_freq1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Whole_cell2_axes_CreateFcn(hObject, eventdata, handles)

% Hint: place code in OpeningFcn to populate Whole_cell2_axes

% --- Executes on button press in ExtTrigger_Button.
function ExtTrigger_Button_Callback(hObject, eventdata, handles)

% Hint: get(hObject,'Value') returns toggle state of ExtTrigger_toggle
Trig_value = get(hObject, 'Value');
if (Trig_value == 1)
    handles.defaults.ExternalTrigger = 1;
        if (isempty(s.Connections)) % check if external trigger connection doesn't exists
           handles.s.addTriggerConnection('External','dev1/PFI0','StartTrigger');
        end
else
    handles.defaults.ExternalTrigger = 0;
   handles.s.removeConnection(1);
end
guidata(hObject,handles)

% --- Executes on selection change in Cell1_type_popup.
function Cell1_type_popup_Callback(hObject, eventdata, handles)

val = get(hObject,'Value');
switch val
    case 1
        handles.data.ch1.user_gain=1;
        ylabel(handles.Whole_cell1_axes,'pA')
        handles.data.ch1.externalcommandsensitivity=20;
    case 2
        handles.data.ch1.user_gain=20;
        ylabel(handles.Whole_cell1_axes,'mV')
        handles.data.ch1.externalcommandsensitivity=400;
    case 3
        handles.data.ch1.user_gain=500;
        ylabel(handles.Whole_cell1_axes,'mV')
end 
% Hints: contents = cellstr(get(hObject,'String')) returns Cell1_type_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Cell1_type_popup
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function Cell1_type_popup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Cell2_type_popup.
function Cell2_type_popup_Callback(hObject, eventdata, handles)


val = get(hObject,'Value');
switch val
    case 1
        handles.data.ch2.user_gain=1;
        ylabel(handles.Whole_cell2_axes,'pA')
        handles.data.ch2.externalcommandsensitivity=20;
    case 2
        handles.data.ch2.user_gain=20;
        ylabel(handles.Whole_cell2_axes,'mV')
        handles.data.ch2.externalcommandsensitivity=400;
    case 3
        handles.data.ch2.user_gain=500;
        ylabel(handles.Whole_cell2_axes,'mV')
    case 4
        handles.data.ch2.user_gain=1; % should be 1 but set to 1/1000 to correct for multiplication in acquire function
        ylabel(handles.Whole_cell2_axes, 'Volts')
end 
% Hints: contents = cellstr(get(hObject,'String')) returns Cell2_type_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Cell2_type_popup
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function Cell2_type_popup_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in get_limits_button.
function get_limits_button_Callback(hObject, eventdata, handles)

if (get(handles.addcursors_radio,'Value')==1)
handles.data.analysis_limits.cell1 = dualcursor(handles.Whole_cell1_axes);
end
if (get(handles.addcursors_radio2,'Value')==1)
handles.data.analysis_limits.cell2 = dualcursor(handles.Whole_cell2_axes);
end


% --- Executes on button press in loadexp_button.
function loadexp_button_Callback(hObject, eventdata, handles)


loadname=handles.data.SaveName;


load(loadname, 'handles.data.sweeps', 'handles.defaults', 'handles.data', 'LED', 'Ramp', 'cell1', 'cell2'); %, 'motor'); 
% plot
plot(handles.Whole_cell1_axes,handles.data.timebase,handles.data.cell1sweep);
plot(handles.Whole_cell1_axes_Ih,handles.data.ch1.holding_i,'o');
plot(handles.Whole_cell1_axes_Rs,handles.data.ch1.series_r,'o');
plot(handles.Whole_cell1_axes_Ir,handles.data.ch1.input_r,'o');
plot(handles.stim_axes,handles.data.timebase, handles.data.stim_output);
plot(handles.CCoutput_axes,handles.data.timebase, handles.data.CCoutput1, handles.data.timebase, handles.data.CCoutput2);

value3 = get(handles.record_cell2_check, 'Value');
if (value3 == 1) % if recording two cells
    plot(handles.Whole_cell2_axes,handles.data.timebase,handles.data.cell2sweep);
    plot(handles.Whole_cell2_axes_Ih,handles.data.ch2.holding_i,'o');
    plot(handles.Whole_cell2_axes_Rs,handles.data.ch2.series_r,'o');
    plot(handles.Whole_cell2_axes_Ir,handles.data.ch2.input_r,'o');
end
set(handles.current_sweep_number,'String',num2str(handles.data.sweep_counter));
handles.data.SetSweepNumber = 1;
set(handles.SetSweepNumber,'String',num2str(1));
plot(handles.sweep_display_axes, handles.data.timebase, handles.data.sweeps{1}); 
handles = updateAOaxes(handles);
guidata(hObject,handles)




% --- Executes on button press in SaveExpt_button.
function SaveExpt_button_Callback(hObject, eventdata, handles)

button=questdlg('Are you sure?');

if strcmp(button, 'Yes')
    save_data(handles);
end



% --- Executes on button press in default_save_check.
function default_save_check_Callback(hObject, eventdata, handles)
% hObject    handle to default_save_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of default_save_check


% --- Executes on button press in new_exp_button.
function new_exp_button_Callback(hObject, eventdata, handles)
% hObject    handle to new_exp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button=questdlg('Save?');

if strcmp(button, 'Yes')
    save_data(handles);
end

close(Acq)


% --- Executes on selection change in update_param_popup.
function update_param_popup_Callback(hObject, eventdata, handles)
% hObject    handle to update_param_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns update_param_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from update_param_popup


% --- Executes during object creation, after setting all properties.
function update_param_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to update_param_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaparam_Callback(hObject, eventdata, handles)
% hObject    handle to deltaparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaparam as text
%        str2double(get(hObject,'String')) returns contents of deltaparam as a double


% --- Executes during object creation, after setting all properties.
function deltaparam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in auto_update_param_check.
function auto_update_param_check_Callback(hObject, eventdata, handles)
% hObject    handle to auto_update_param_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of auto_update_param_check



function stimulus_num_Callback(hObject, eventdata, handles)
% hObject    handle to stimulus_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stimulus_num as text
%        str2double(get(hObject,'String')) returns contents of stimulus_num as a double


% --- Executes during object creation, after setting all properties.
function stimulus_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulus_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in axes_hold_check.
function axes_hold_check_Callback(hObject, eventdata, handles)
% hObject    handle to axes_hold_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of axes_hold_check
function genotype_Callback(hObject, eventdata, handles)
% hObject    handle to genotype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.Expt_Params.genotype=(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of genotype as text
%        str2double(get(hObject,'String')) returns contents of genotype as a double


% --- Executes during object creation, after setting all properties.
function genotype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to genotype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% global handles.data
% set(hObject,'String',num2str(handles.data.Expt_Params.genotype));
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function age_Callback(hObject, eventdata, handles)
% hObject    handle to age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structureglobal handles.data

handles.data.Expt_Params.age=(get(hObject,'String'));
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of age as text
%        str2double(get(hObject,'String')) returns contents of age as a double


% --- Executes during object creation, after setting all properties.
function age_CreateFcn(hObject, eventdata, handles)
% hObject    handle to age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function virus_Callback(hObject, eventdata, handles)
% hObject    handle to virus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.Expt_Params.virus=(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of virus as text
%        str2double(get(hObject,'String')) returns contents of virus as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function virus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to virus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox22.
function checkbox22_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22



function injection_age_Callback(hObject, eventdata, handles)
% hObject    handle to injection_age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.Expt_Params.lightsource=(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of injection_age as text
%        str2double(get(hObject,'String')) returns contents of injection_age as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function injection_age_CreateFcn(hObject, eventdata, handles)
% hObject    handle to injection_age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function internal_Callback(hObject, eventdata, handles)
% hObject    handle to internal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.Expt_Params.internal=(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of internal as text
%        str2double(get(hObject,'String')) returns contents of internal as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function internal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to internal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function external_Callback(hObject, eventdata, handles)
% hObject    handle to external (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.Expt_Params.brainregion=(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of external as text
%        str2double(get(hObject,'String')) returns contents of external as a double
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function external_CreateFcn(hObject, eventdata, handles)
% hObject    handle to external (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function slice_number_Callback(hObject, eventdata, handles)
% hObject    handle to slice_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slice_number as text
%        str2double(get(hObject,'String')) returns contents of slice_number as a double

handles.data.animal_number=(get(hObject,'String'));
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function slice_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slice_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function labelaxes(handles)

get(handles.Cell1_type_popup,'Value');
if (get(handles.Cell1_type_popup,'Value'))==1
    ylabel(handles.Whole_cell1_axes,'pA')
else
    ylabel(handles.Whole_cell1_axes,'mV')
end

if (get(handles.Cell2_type_popup,'Value'))==1
    ylabel(handles.Whole_cell2_axes,'pA')
else
    ylabel(handles.Whole_cell2_axes,'mV')
end
xlabel(handles.Whole_cell1_axes,'seconds')
xlabel(handles.Whole_cell2_axes,'seconds')
val = get(handles.Highpass_check, 'Value'); % check for highpass filtering
if (val == 1)
    ylabel(handles.Whole_cell1_axes_Rs,'spikerate')
else
    ylabel(handles.Whole_cell1_axes_Rs,'megaohm')
end
ylabel(handles.Whole_cell1_axes_Ih,'Ihold')
ylabel(handles.Whole_cell1_axes_Ir,'Ri')
xlabel(handles.Whole_cell1_axes_Ir, 'minutes')
xlabel(handles.Whole_cell2_axes_Ir, 'minutes')
xlabel(handles.stim_axes, 'seconds')
ylabel(handles.stim_axes, 'Volts')

% compute total experiment time
TotalExpTime = max(handles.data.trialtime)+0.001;

xlim(handles.Whole_cell1_axes_Rs,[0 TotalExpTime*1.33])
xlim(handles.Whole_cell1_axes_Ih,[0 TotalExpTime*1.33])
xlim(handles.Whole_cell1_axes_Ir,[0 TotalExpTime*1.33])
xlim(handles.Whole_cell2_axes_Ih,[0 TotalExpTime*1.33])
xlim(handles.Whole_cell2_axes_Ir,[0 TotalExpTime*1.33])
xlim(handles.Whole_cell2_axes_Rs,[0 TotalExpTime*1.33])

ylim(handles.Whole_cell1_axes_Rs,[0 100])
ylim(handles.Whole_cell1_axes_Ih,[-1000 0])
ylim(handles.Whole_cell1_axes_Ir,[0 300])
ylim(handles.Whole_cell2_axes_Rs,[0 70])
ylim(handles.Whole_cell2_axes_Ih,[-1000 0])
ylim(handles.Whole_cell2_axes_Ir,[0 300])

    
    
    


% --- Executes on button press in test_pulse.
function test_pulse_Callback(hObject, eventdata, handles)
% hObject    handle to test_pulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of test_pulse

trial_duration = num2str(get(handles.trial_length,'String'));

if get(hObject,'Value')
    handles.data.testpulse = ...
        makepulseoutputs(handles.defaults.testpulse_start, 1, handles.defaults.testpulse_duration, handles.defaults.testpulse_amp, 1, handles.defaults.Fs, trial_duration);
else
    handles.data.testpulse = zeros(trial_duration*Fs,1);
end


function roi_tag_Callback(hObject, eventdata, handles)
% hObject    handle to roi_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roi_tag as text
%        str2double(get(hObject,'String')) returns contents of roi_tag as a double


% --- Executes during object creation, after setting all properties.
function roi_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in run_type.
function run_type_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in run_type 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.run_type = get(eventdata.NewValue,'Tag');
guidata(hObject,handles);


% --- Executes on button press in load_sequence.
function load_sequence_Callback(hObject, eventdata, handles)
% hObject    handle to load_sequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.data.seq_filename, handles.data.seq_filepath] = uigetfile();
load([handles.data.seq_filepath '\' handles.data.seq_filename],'protocol')
handles.protocol = protocol;
handles.protocol_loaded = 1;
guidata(hObject,handles)
set(handles.sequence_file,'String',handles.data.seq_filename)


function wavelength_Callback(hObject, eventdata, handles)
% hObject    handle to wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wavelength as text
%        str2double(get(hObject,'String')) returns contents of wavelength as a double


% --- Executes during object creation, after setting all properties.
function wavelength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ITI_Callback(hObject, eventdata, handles)
% hObject    handle to ITI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ITI as text
%        str2double(get(hObject,'String')) returns contents of ITI as a double

function save_data(handles)

data = handles.data;
defaults = handles.defaults;
save(handles.data.save_name,'data','defaults')

clear data defaults


% --- Executes on button press in loop_forever.
function loop_forever_Callback(hObject, eventdata, handles)
% hObject    handle to loop_forever (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loop_forever



function loop_count_Callback(hObject, eventdata, handles)
% hObject    handle to loop_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of loop_count as text
%        str2double(get(hObject,'String')) returns contents of loop_count as a double


% --- Executes during object creation, after setting all properties.
function loop_count_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loop_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_lut.
function load_lut_Callback(hObject, eventdata, handles)
% hObject    handle to load_lut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.data.lut_filename, handles.data.lut_filepath] = uigetfile();
load([handles.data.lut_filepath '\' handles.data.lut_filename],'lut')
handles.data.lut = lut;

set(hObject,'ForegroundColor',[0 .5 .5])

guidata(hObject,handles)


% --- Executes on button press in use_lut.
function use_lut_Callback(hObject, eventdata, handles)
% hObject    handle to use_lut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_lut



function amplitude_conditions_Callback(hObject, eventdata, handles)
% hObject    handle to amplitude_conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amplitude_conditions as text
%        str2double(get(hObject,'String')) returns contents of amplitude_conditions as a double


% --- Executes during object creation, after setting all properties.
function amplitude_conditions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitude_conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duration_conditions_Callback(hObject, eventdata, handles)
% hObject    handle to duration_conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration_conditions as text
%        str2double(get(hObject,'String')) returns contents of duration_conditions as a double


% --- Executes during object creation, after setting all properties.
function duration_conditions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration_conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numpulse_conditions_Callback(hObject, eventdata, handles)
% hObject    handle to numpulse_conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numpulse_conditions as text
%        str2double(get(hObject,'String')) returns contents of numpulse_conditions as a double


% --- Executes during object creation, after setting all properties.
function numpulse_conditions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numpulse_conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function freq_conditions_Callback(hObject, eventdata, handles)
% hObject    handle to freq_conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of freq_conditions as text
%        str2double(get(hObject,'String')) returns contents of freq_conditions as a double


% --- Executes during object creation, after setting all properties.
function freq_conditions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq_conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function starttime_conditions_Callback(hObject, eventdata, handles)
% hObject    handle to starttime_conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of starttime_conditions as text
%        str2double(get(hObject,'String')) returns contents of starttime_conditions as a double


% --- Executes during object creation, after setting all properties.
function starttime_conditions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to starttime_conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in make_conditions.
function make_conditions_Callback(hObject, eventdata, handles)
% hObject    handle to make_conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

amps = strread(get(handles.amplitude_conditions,'String'));
durations = strread(get(handles.duration_conditions,'String'));
numpulses = strread(get(handles.numpulse_conditions,'String'));
freqs = strread(get(handles.freq_conditions,'String'));
starttimes = strread(get(handles.starttime_conditions,'String'));

handles.data.stim_conds.stims = zeros(length(amps),length(durations),length(numpulses),length(freqs),length(starttimes),handles.defaults.Fs * handles.defaults.trial_length);
handles.data.stim_conds.cond_inds = zeros(length(amps)*length(durations)*length(numpulses)*length(freqs)*length(starttimes),5);

cond_count = 1;
for i = 1:length(amps)
    for j = 1:length(durations)
        for k = 1:length(numpulses)
            for l = 1:length(freqs)
                for m = 1:length(starttimes)
                    if isfield(handles.data,'lut') && get(handles.use_lut,'Value')

                        amplitude = get_voltage(handles.data.lut,amps(i));
                        if isempty(amplitude)
                            amplitude = 0;
                        end
                    else
                        amplitude = amps(i);
                    end
                    handles.data.stim_conds.stims(i,j,k,l,m,:) =...
                        makepulseoutputs(starttimes(m),numpulses(k),...
                        durations(j), amplitude, freqs(l), handles.defaults.Fs, handles.defaults.trial_length);
                    handles.data.stim_conds.cond_inds(cond_count,:) = [i j k l m];
                    cond_count = cond_count + 1;
                end
            end
        end
    end
end
                    
handles.data.stim_conds.amps = amps;
handles.data.stim_conds.durations = durations;
handles.data.stim_conds.numpulses = numpulses;
handles.data.stim_conds.freqs = freqs;
handles.data.stim_conds.starttimes = starttimes;

guidata(hObject,handles)



function num_trials_Callback(hObject, eventdata, handles)
% hObject    handle to num_trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_trials as text
%        str2double(get(hObject,'String')) returns contents of num_trials as a double


% --- Executes during object creation, after setting all properties.
function num_trials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rng_seed_Callback(hObject, eventdata, handles)
% hObject    handle to rng_seed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rng_seed as text
%        str2double(get(hObject,'String')) returns contents of rng_seed as a double


% --- Executes during object creation, after setting all properties.
function rng_seed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rng_seed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in use_seed.
function use_seed_Callback(hObject, eventdata, handles)
% hObject    handle to use_seed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_seed



function cell_number_Callback(hObject, eventdata, handles)
% hObject    handle to cell_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cell_number as text
%        str2double(get(hObject,'String')) returns contents of cell_number as a double


% --- Executes during object creation, after setting all properties.
function cell_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cell_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cell_type_Callback(hObject, eventdata, handles)
% hObject    handle to cell_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cell_type as text
%        str2double(get(hObject,'String')) returns contents of cell_type as a double


% --- Executes during object creation, after setting all properties.
function cell_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cell_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in update_metadata.
function update_metadata_Callback(hObject, eventdata, handles)
% hObject    handle to update_metadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get metadata
handles.data.metadata.genotype = get(handles.genotype,'String');
handles.data.metadata.age = get(handles.age,'String');
handles.data.metadata.virus = get(handles.virus,'String');
handles.data.metadata.internal = get(handles.internal,'String');
handles.data.metadata.external = get(handles.external,'String');
handles.data.metadata.injection_age = get(handles.injection_age,'String');
handles.data.metadata.slice_number = get(handles.slice_number,'String');
handles.data.metadata.cell_number = get(handles.cell_number,'String');
handles.data.metadata.cell_type = get(handles.cell_type,'String');


clock_array = clock;
savename = [num2str(clock_array(2)) '_' num2str(clock_array(3)) '_slice' handles.data.metadata.slice_number '_cell' handles.data.metadata.cell_number '.mat'];
if iscell(savename)
    savename = [savename{:} '.mat'];
end

set(handles.ExperimentName,'String',savename);

guidata(hObject,handles)

ExperimentName_Callback(handles.ExperimentName,[],handles)
