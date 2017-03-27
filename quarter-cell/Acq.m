function varargout = Acq(varargin)

% ACQ MATLAB code for Acq.fig
%      ACQ, by itself, creates a new ACQ or raises the existing
%      singleton*.
%
%      H = ACQ returns the handle to a new ACQ or the handle to
%      the existing singleton*.
%
%      ACQ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACQ.M with the given input arguments.
%
%      ACQ('Property','Value',...) creates a new ACQ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Acq_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Acq_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Acq

% Last Modified by G UIDE v2.5 13-Feb-2013 14:39:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Acq_OpeningFcn, ...
                   'gui_OutputFcn',  @Acq_OutputFcn, ...
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


% --- Executes just before Acq is made visible.
function Acq_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Acq (see VARARGIN)

% Choose default command line output for Acq
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


% UIWAIT makes Acq wait for user response (see UIRESUME)
% uiwait(handles.acq_gui);


% --- Outputs from this function are returned to the command line.
function varargout = Acq_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function current_trial_axes_CreateFcn(hObject, eventdata, handles)

% Hint: place code in OpeningFcn to populate current_trial_axes





% --- Executes on button press in run.
function handles = run_Callback(hObject, eventdata, handles)
% str2double(get(handles.ITI,'String'))
% handles.globalTimer=timer('TimerFcn', @acquire, 'TaskstoExecute', handles.defaults.total_sweeps, 'Period',str2double(get(handles.ITI,'String')), 'ExecutionMode','fixedRate','UserData',handles);
% guidata(hObject,handles)



default_color = [0.8627    0.8627    0.8627]; % grey
set(hObject,'BackgroundColor',[0 1 .5]);
if get(hObject,'Value')
    handles.run_count = handles.run_count + 1;
end
handles.is_test_trial = 0;


    
% [x,y,z] = getpos(handles.mpc200);
if isfield(handles.data,'obj_position_socket')
    handles.data.obj_position = handles.data.obj_position_socket;
else
    handles.data.obj_position = [0 0 0];%[x y z];
end

% what type of run are we going to do?
switch handles.run_type
    case 'loop'
        disp('looping...')
        
        if get(handles.loop_forever,'Value')
            while get(hObject,'Value')
%                 handles = make_stim_out(handles);
                handles.io_data = step_loop(handles);
%                 handles = process_plot_wait(handles,str2double(get(handles.ITI,'String')));
                start_time = clock;
                handles = process_plot(handles);
            
            % wait
            
                while etime(clock, start_time) < str2double(get(handles.ITI,'String'))
                end
            end
        else
            for loop_ind = 1:str2num(get(handles.loop_count,'String'))
                handles.io_data = step_loop(handles);
                start_time = clock;
                handles = process_plot(handles);
                % wait
                
                while etime(clock, start_time) < str2double(get(handles.ITI,'String'))
                end
                drawnow
                if ~get(hObject,'Value')
                    break
                end
            end
        end
        set(hObject,'Value',0)
%     case 'sequence'
%         disp('sequencing...')
%         %run sequence
%         [x,y,z] = getpos(handles.mpc200);
%         handles.data.obj_position = [x y z];
%         if handles.protocol_loaded
%             for i = 1:length(handles.protocol)
%                 handles.io_data = io(handles.s,handles.protocol(i).output);
%                 start_time = clock;
%                 handles = process_plot(handles);
%                 % wait
%                 
%                 while etime(clock, start_time) < handles.protocol(i).intertrial_interval
%                 end
%                 drawnow
%                 if ~get(hObject,'Value')
%                     break
%                 end
%             end
%         end
%         set(hObject,'Value',0)
    case 'conditions'
        disp('running conditions')
        if get(handles.use_seed,'Value')
            rng(ceil(str2double(handles.rng_seed,'String')));
        end
        conditions = repmat(1:size(handles.data.stim_conds.cond_inds,1),1,str2double(get(handles.num_trials,'String')));
        conditions = conditions(randperm(length(conditions)));
        
        if isfield(handles,'mpc200')
            [start_pos_x, start_pos_y,start_pos_z] = getpos(handles.mpc200);
        else
            start_pos_x = 0; start_pos_y = 0; start_pos_z = 0;
        end
        start_pos = [start_pos_x start_pos_y start_pos_z];
        switch handles.spatial_layout
            case 'grid'
                offset_pos = start_pos;
            case 'cross'
                offset_pos = start_pos;
            case 'locations'
                offset_x = str2double(get(handles.offset_x,'String'));
                offset_y = str2double(get(handles.offset_y,'String'));
                offset_z = str2double(get(handles.offset_z,'String'));
                offset_pos = [offset_x offset_y offset_z];
        end
        handles.data.start_pos = start_pos;
        handles.data.offset_pos = offset_pos;
        
        trials_per_test_pulse = str2double(get(handles.trials_per_pulse,'String'));
        
        handles.test_trial = 0;
        test_trial_count = 0;
        
        num_test_trials = ceil(length(conditions)/trials_per_test_pulse);
        if mod(length(conditions),trials_per_test_pulse) == 0
            num_test_trials = num_test_trials + 1;
        end
        do_test_pulse = get(handles.test_pulse,'Value');
        
        ii = 0;
        i = 1;
        repeat_test_trial = 0;
        
        run_conditions = 1;
        while run_conditions
            
            ii = ii + 1 - repeat_test_trial;

            
            start_color = get(handles.run,'BackgroundColor');
            set(handles.run,'BackgroundColor',[1 0 0]);
            set(handles.run,'String','Acq...')
            
            trials_per_test_pulse = str2double(get(handles.trials_per_pulse,'String'));
            is_test_trial = (repeat_test_trial || mod(ii-1,trials_per_test_pulse) == 0) && ~(2 == get(handles.Cell1_type_popup,'Value'));
            handles.is_test_trial = is_test_trial;
            cond_ind = handles.data.stim_conds.cond_inds(conditions(i),:);
            if is_test_trial
                
                set(handles.test_pulse,'Value',1);
                
                trial_length = 1.0;
                 
                [handles.data.stim_output,handles.data.timebase] = makepulseoutputs(handles.data.ch1.pulse_starttime,handles.data.ch1.pulsenumber, handles.data.ch1.pulseduration, 0, handles.data.ch1.pulsefrequency, handles.defaults.Fs, trial_length);
                handles.data.shutter = zeros(size(handles.data.stim_output));
                % [handles.data.stim_output,handles.data.timebase] = ...
                %     makepulseoutputs(handles.data.stimulation.pulse_starttime,handles.data.stimulation.pulsenumber, handles.data.stimulation.pulseduration,...
                %     handles.data.stimulation.pulseamp, handles.data.stimulation.pulsefrequency, handles.defaults.Fs, trial_length);


                handles.data.ch1_output=makepulseoutputs(handles.data.ch1.pulse_starttime,handles.data.ch1.pulsenumber, handles.data.ch1.pulseduration, handles.data.ch1.pulseamp, handles.data.ch1.pulsefrequency, handles.defaults.Fs, trial_length);
                handles.data.ch1_output=handles.data.ch1_output/handles.defaults.CCexternalcommandsensitivity;
                [handles.data.testpulse, handles.data.timebase] = makepulseoutputs(handles.defaults.testpulse_start, 1, handles.defaults.testpulse_duration, handles.defaults.testpulse_amp, 1, handles.defaults.Fs, trial_length);
                guidata(hObject,handles)
            else
                
                set(handles.test_pulse,'Value',do_test_pulse);
                
                trial_length = str2double(get(handles.trial_length,'String'));
                handles.data.stim_output = squeeze(handles.data.stim_conds.stims(cond_ind(1),cond_ind(2),cond_ind(3),cond_ind(4),cond_ind(5),:));
                handles.data.shutter = squeeze(handles.data.stim_conds.shutters(cond_ind(1),cond_ind(2),cond_ind(3),cond_ind(4),cond_ind(5),:));
                [handles.data.ch1_output,handles.data.timebase]=makepulseoutputs(handles.data.ch1.pulse_starttime,handles.data.ch1.pulsenumber, handles.data.ch1.pulseduration, handles.data.ch1.pulseamp, handles.data.ch1.pulsefrequency, handles.defaults.Fs, trial_length);
                handles.data.ch1_output=handles.data.ch1_output/handles.defaults.CCexternalcommandsensitivity;
                handles.test_trial = 0;
                
                handles.data.obj_position = handles.data.stim_conds.relative_target_pos(cond_ind(6),:) + offset_pos;
                
                if i == 1 && isfield(handles,'mpc200')
                    move_good = check_move(handles,  handles.data.obj_position);

                    if move_good
                        disp('good move!')
                        gotopos(handles.mpc200, handles.data.obj_position(1), handles.data.obj_position(2), handles.data.obj_position(3));
                    else
                        disp('bad move!')
                        break
                    end
                    pause(.5)
                end
                guidata(hObject,handles)
            end
            
            
            
            [AO0, AO1, AO2, AO3] = analogoutput_gen(handles);

            handles.io_data = io(handles.s,[AO0, AO1,AO2,AO3]);
%             while etime(clock, start_time) < wait_time
%             end
            handles.data.tmp.cond_ind = cond_ind;
            set(handles.run,'backgroundColor',start_color)
            guidata(handles.acq_gui,handles)
            
            if i < length(conditions) && ~is_test_trial
                
                cond_ind = handles.data.stim_conds.cond_inds(conditions(i+1),:);
                tmp_obj_position = [handles.data.stim_conds.relative_target_pos(cond_ind(6),:) + offset_pos];
%                 move_good = check_move(handles, tmp_obj_position);

%                     if move_good
                        if isfield(handles,'mpc200')
                            gotopos(handles.mpc200, tmp_obj_position(1), tmp_obj_position(2), tmp_obj_position(3));
                        end
%                     else
%                         disp('bad move!')
%                     end
                
            end
            
            if is_test_trial
                test_trial_count = test_trial_count + 1;
            else
                i = i + 1;
            end
            start_time = clock;
            handles = process_plot(handles);
            
            % wait
            
            while etime(clock, start_time) < str2double(get(handles.ITI,'String'))
            end
%             drawnow
            if ~get(hObject,'Value')
                break
            end
            if is_test_trial && check_series_resistance(handles)
                response = questdlg('Series Resistance is High... continue?');
                if strcmpi(response,'No')
                    break
                elseif strcmpi(response,'Yes')
                    repeat_test_trial = 1;
                else
                    repeat_test_trial = 0;
                end
            else
                repeat_test_trial = 0;
            end
            
            if i > length(conditions)
                run_conditions = 0;
            end
                
            
        end
        set(hObject,'Value',0)
%         gotopos(handles.mpc200,start_pos(1), start_pos(2),start_pos(3))
%         getpos_Callback(handles.getpos, [], handles)
        set(handles.test_pulse,'Value',do_test_pulse);
    end
        
        

        
set(hObject,'String','Start');
set(hObject,'BackgroundColor',default_color);

% update fields
handles = trial_length_Callback(handles.trial_length, [], handles);

guidata(hObject,handles)

function handles = process_plot(handles)


set(handles.run,'String','Process')
handles = process(handles);
guidata(handles.acq_gui,handles) % needed?
handles = plot_gui(handles);
guidata(handles.acq_gui,handles) % needed?
drawnow
% set(handles.run,'String','ITI')
% drawnow




% --- Executes during object creation, after setting all properties.
function ITI_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function handles = trial_length_Callback(hObject, eventdata, handles)

disp('updating trial length stuff')
trial_length = str2double(get(hObject,'String'))
handles.defaults.trial_length = trial_length;

handles = make_stim_out(handles);

% [handles.data.stim_output,handles.data.timebase] = ...
%     makepulseoutputs(handles.data.stimulation.pulse_starttime,handles.data.stimulation.pulsenumber, handles.data.stimulation.pulseduration,...
%     handles.data.stimulation.pulseamp, handles.data.stimulation.pulsefrequency, handles.defaults.Fs, trial_length);

 
handles.data.ch1_output=makepulseoutputs(handles.data.ch1.pulse_starttime,handles.data.ch1.pulsenumber, handles.data.ch1.pulseduration, handles.data.ch1.pulseamp, handles.data.ch1.pulsefrequency, handles.defaults.Fs, trial_length);
handles.data.ch2_output=makepulseoutputs(handles.data.ch2.pulse_starttime,handles.data.ch2.pulsenumber, handles.data.ch2.pulseduration, handles.data.ch2.pulseamp, handles.data.ch2.pulsefrequency, handles.defaults.Fs, trial_length);
handles.data.ch1_output=handles.data.ch1_output/handles.defaults.CCexternalcommandsensitivity;
handles.data.ch2_output=handles.data.ch2_output/handles.defaults.CCexternalcommandsensitivity;
[handles.data.testpulse, handles.data.timebase] = makepulseoutputs(handles.defaults.testpulse_start, 1, handles.defaults.testpulse_duration, handles.defaults.testpulse_amp, 1, handles.defaults.Fs, trial_length);
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
function Rs_axes_CreateFcn(hObject, eventdata, handles)



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

handles.data.stimulation.pulseamp=0;%str2double(get(handles.pulseamp,'String'));
handles.data.stimulation.pulseduration=0;%str2double(get(handles.pulseduration,'String'));
handles.data.stimulation.pulsenumber=1;%str2double(get(handles.pulsenumber,'String'));
handles.data.stimulation.pulsefrequency=1;%str2double(get(handles.pulsefrequency,'String'));
handles.data.stimulation.pulse_starttime=0;%str2double(get(handles.pulse_starttime,'String'));

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
    ylabel(handles.current_trial_axes,'mV')
    % ylabel(handles.CCoutput_axes,'pA')
    if get(handles.LFP_check, 'Value')~=1 
        handles.data.ch1.user_gain=20; % set gain to 20 for whole cell current clamp
    else
        handles.data.ch1.user_gain=500; % set gain to 500 for LFP recording
    end
    
else
    
    handles.data.ch1.user_gain=1;
    ylabel(handles.current_trial_axes,'pA')  
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

val = get(handles.Highpass_cell1_check, 'Value'); % check for highpass filtering

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
%     thissweep=thissweep-mean(thissweep(1:20000));
    thissweep = thissweep - thissweep(1);
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
    
    val = get(handles.Highpass_cell1_check, 'Value');


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
            thissweep=highpass_filter(thissweep,1/20000); % if checked highpass filter
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
    if get(handles.use_LED,'Value')
        thissweep2=thissweep(:,3);
    else
        thissweep2=thissweep(:,4);
    end
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

% --- Executes on button press in Highpass_cell1_check.
function Highpass_cell1_check_Callback(hObject, eventdata, handles)

% Hint: get(hObject,'Value') returns toggle state of Highpass_cell1_check


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
%         ylabel(handles.current_trial_axes,'pA')
        handles.data.ch1.externalcommandsensitivity=20;
    case 2
        handles.data.ch1.user_gain=20;
%         ylabel(handles.current_trial_axes,'mV')
        handles.data.ch1.externalcommandsensitivity=400;
    case 3
        handles.data.ch1.user_gain=1;
%         ylabel(handles.current_trial_axes,'mV')
        handles.data.ch1.externalcommandsensitivity=20;
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


% val = get(hObject,'Value');
% switch val
%     case 1
%         handles.data.ch2.user_gain=1;
%         ylabel(handles.Whole_cell2_axes,'pA')
%         handles.data.ch2.externalcommandsensitivity=20;
%     case 2
%         handles.data.ch2.user_gain=20;
%         ylabel(handles.Whole_cell2_axes,'mV')
%         handles.data.ch2.externalcommandsensitivity=400;
%     case 3
%         handles.data.ch2.user_gain=500;
%         ylabel(handles.Whole_cell2_axes,'mV')
%     case 4
%         handles.data.ch2.user_gain=1; % should be 1 but set to 1/1000 to correct for multiplication in acquire function
%         ylabel(handles.Whole_cell2_axes, 'Volts')
% end 
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
handles.data.analysis_limits.cell1 = dualcursor(handles.current_trial_axes);
end
if (get(handles.addcursors_radio2,'Value')==1)
handles.data.analysis_limits.cell2 = dualcursor(handles.Whole_cell2_axes);
end


% --- Executes on button press in loadexp_button.
function loadexp_button_Callback(hObject, eventdata, handles)


loadname=handles.data.SaveName;


load(loadname, 'handles.data.sweeps', 'handles.defaults', 'handles.data', 'LED', 'Ramp', 'cell1', 'cell2'); %, 'motor'); 
% plot
plot(handles.current_trial_axes,handles.data.timebase,handles.data.cell1sweep);
plot(handles.Ih_axes,handles.data.ch1.holding_i,'o');
plot(handles.Rs_axes,handles.data.ch1.series_r,'o');
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

% if (get(handles.Cell1_type_popup,'Value'))==1
%     ylabel(handles.current_trial_axes,'pA')
% else
%     ylabel(handles.current_trial_axes,'mV')
% end


% xlabel(handles.current_trial_axes,'seconds')

ylabel(handles.Rs_axes,'megaohm')

ylabel(handles.Ih_axes,'Ihold')
xlabel(handles.Ih_axes, 'minutes')

% compute total experiment time
TotalExpTime = max(handles.data.trialtime)+0.001;

xlim(handles.Rs_axes,[0 TotalExpTime*1.33])
xlim(handles.Ih_axes,[0 TotalExpTime*1.33])



% --- Executes on button press in test_pulse.
function test_pulse_Callback(hObject, eventdata, handles)
% hObject    handle to test_pulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of test_pulse

trial_duration = str2double(get(handles.trial_length,'String'));

if get(hObject,'Value')
    handles.data.testpulse = ...
        makepulseoutputs(handles.defaults.testpulse_start, 1, handles.defaults.testpulse_duration, handles.defaults.testpulse_amp, 1, handles.defaults.Fs, trial_duration);
else
    handles.data.testpulse = zeros(trial_duration*handles.defaults.Fs,1);
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
save(handles.data.save_name,'data','defaults','-v7.3')

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
handles.data.ratio_map = ratio_map;

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

if get(handles.use_obj_spatial,'Value')
    disp(handles.spatial_layout)
    switch handles.spatial_layout
        case 'grid'

            % code me up, yo!
            spacing = str2num(get(handles.grid_spacing,'String'))
            z_spacing = str2num(get(handles.grid_spacing_z,'String'))
            x_min = str2num(get(handles.x_obj_min,'String'));
            x_max = str2num(get(handles.x_obj_max,'String'));
            y_min = str2num(get(handles.y_obj_min,'String'));
            y_max = str2num(get(handles.y_obj_max,'String'));
            z_min = str2num(get(handles.z_obj_min,'String'));
            z_max = str2num(get(handles.z_obj_max,'String'));
            
            x_range = x_max - x_min;
            y_range = y_max - y_min;
            z_range = z_max - z_min;
            
            x_points = floor(x_range/spacing) + 1;
            y_points = floor(y_range/spacing) + 1;
            z_points = floor(z_range/z_spacing) + 1;
            
%             num_targets = x_points*y_points*z_points;
%             relative_target_pos = zeros(0,3);
            
            protect_range = str2double(get(handles.protection_range,'String'));
            count = 1;
            for i = 1:x_points
                for j = 1:y_points
                    for k = 1:z_points
                        relative_pos = [x_min + spacing*(i-1) y_min + spacing*(j-1) z_min + z_spacing*(k-1)]
                        if (get(handles.protect_cell,'Value') && ~all(abs(relative_pos) <= protect_range))...
                                || ~get(handles.protect_cell,'Value') 
                            disp('adding target')
                            relative_pos
                            relative_target_pos(count,:) = relative_pos;
                            count = count + 1;
                        else
                            'boo'
                        end  
                    end
                end
            end
            num_targets = size(relative_target_pos,1)
            
            assignin('base','positions',relative_target_pos)
            handles.data.stim_conds.relative_target_pos = relative_target_pos;

        case 'cross'

            radii_step = str2num(get(handles.radii_step,'String')); % in micrometers
            num_circles = str2num(get(handles.num_circles,'String'));
            points_per_circle = 4; % hard coded to make this protocol into "cross"

            relative_target_pos_base = zeros(points_per_circle,3);
            relative_target_pos_base(1,:) = [radii_step 0 0];

            theta = 2 * pi / points_per_circle;
            rotation_matrix = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 0];

            for i = 2:points_per_circle

                relative_target_pos_base(i,:) = round(relative_target_pos_base(i-1,:)*rotation_matrix');

            end
            
            if get(handles.do_circle_z,'Value')
                
%                 z_min = str2num(get(handles.z_obj_circles_min,'String'));
%                 z_max = str2num(get(handles.z_obj_circles_max,'String'));

%                 z_range = z_max - z_min;
%                 z_points = floor(z_range/radii_step) + 1;
                z_points = num_circles*2 + 1;
                z_min = -radii_step*num_circles;
%                 num_targets = z_points*(1+points_per_circle*num_circles);
                num_targets = points_per_circle*num_circles+z_points;
                relative_target_pos = zeros(num_targets,3);
%                 for i = 1:num_circles
%                     for j = 1:z_points
%                         relative_target_pos((i-1)*points_per_circle+2:i*points_per_circle+1,:) = [i*relative_target_pos_base z_min + radii_step*(j-1)];
%                     end
%                 end
                for i = 1:num_circles
                    relative_target_pos((i-1)*points_per_circle+1:i*points_per_circle,:) = i*relative_target_pos_base;
                end
                count = 1;
                for i = points_per_circle*num_circles+1:points_per_circle*num_circles+z_points
                    relative_target_pos(i,:) = [0 0 z_min + radii_step*(count-1)];
                    count = count + 1;
                end

                handles.data.stim_conds.relative_target_pos = relative_target_pos;
                
            else

                num_targets = 1+points_per_circle*num_circles;

                relative_target_pos = zeros(num_targets,3);
                for i = 1:num_circles
                    relative_target_pos((i-1)*points_per_circle+2:i*points_per_circle+1,:) = i*relative_target_pos_base;
                end

                handles.data.stim_conds.relative_target_pos = relative_target_pos;
            end
            assignin('base','relative_target_pos',relative_target_pos)
        case 'locations'
            handles.data.stim_conds.relative_target_pos = handles.data.marked_locs(cell2mat(handles.data.stim_loc),:);
            num_targets = size(handles.data.stim_conds.relative_target_pos,1)
    end
else
    disp('no spatial')
    handles.data.stim_conds.relative_target_pos = [0 0 0];
    num_targets = 1;
end

handles.data.stim_conds.stims = zeros(length(amps),length(durations),length(numpulses),length(freqs),length(starttimes),handles.defaults.Fs * handles.defaults.trial_length);
handles.data.stim_conds.cond_inds = zeros(length(amps)*length(durations)*length(numpulses)*length(freqs)*length(starttimes)*num_targets,6);
handles.data.stim_conds.shutters = zeros(size(handles.data.stim_conds.stims));

cond_count = 1;
for i = 1:length(amps)
    for j = 1:length(durations)
        for k = 1:length(numpulses)
            for l = 1:length(freqs)
                for m = 1:length(starttimes)
                    if isfield(handles.data,'lut') && get(handles.use_lut,'Value')
                        if get(handles.tf_on,'Value')
                            amplitude = get_voltage(handles.data.lut_tf,amps(i))
                        else
                            amplitude = get_voltage(handles.data.lut,amps(i))
                        end
                        if isempty(amplitude)
                            amplitude = 0;
                        end
                    else
                        amplitude = amps(i);
                    end
                    [handles.data.stim_conds.stims(i,j,k,l,m,:), handles.data.timebase] =...
                        makepulseoutputs(starttimes(m),numpulses(k),...
                        durations(j), amplitude, freqs(l), handles.defaults.Fs, handles.defaults.trial_length);
                    [handles.data.stim_conds.shutters(i,j,k,l,m,:), handles.data.timebase] =...
                        makepulseoutputs(starttimes(m) - .0017,numpulses(k),...
                        durations(j) + .0017, 3.0, freqs(l), handles.defaults.Fs, handles.defaults.trial_length);
                    for n = 1:num_targets
                        handles.data.stim_conds.cond_inds(cond_count,:) = [i j k l m n];
                        cond_count = cond_count + 1;
                    end
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
handles.data.metadata.cell2_type = get(handles.cell_2_type,'String');

clock_array = clock;
savename = [num2str(clock_array(2)) '_' num2str(clock_array(3)) '_slice' handles.data.metadata.slice_number '_cell' handles.data.metadata.cell_number '.mat'];
if iscell(savename)
    savename = [savename{:} '.mat'];
end

set(handles.ExperimentName,'String',savename);

guidata(hObject,handles)

ExperimentName_Callback(handles.ExperimentName,[],handles)


% --- Executes on button press in checkbox32.
function checkbox32_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox32


% --- Executes on button press in Highpass_cell2_check.
function Highpass_cell2_check_Callback(hObject, eventdata, handles)
% hObject    handle to Highpass_cell2_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Highpass_cell2_check



function edit78_Callback(hObject, eventdata, handles)
% hObject    handle to edit78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit78 as text
%        str2double(get(hObject,'String')) returns contents of edit78 as a double


% --- Executes during object creation, after setting all properties.
function edit78_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function notes_Callback(hObject, eventdata, handles)
% hObject    handle to notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of notes as text
%        str2double(get(hObject,'String')) returns contents of notes as a double


% --- Executes during object creation, after setting all properties.
function notes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hologram_id_Callback(hObject, eventdata, handles)
% hObject    handle to hologram_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hologram_id as text
%        str2double(get(hObject,'String')) returns contents of hologram_id as a double


% --- Executes during object creation, after setting all properties.
function hologram_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hologram_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function exp_notes_Callback(hObject, eventdata, handles)
% hObject    handle to exp_notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exp_notes as text
%        str2double(get(hObject,'String')) returns contents of exp_notes as a double

handles.data.experiment_notes = get(hObject,'String');
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function exp_notes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function comnum_Callback(hObject, eventdata, handles)
% hObject    handle to comnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comnum as text
%        str2double(get(hObject,'String')) returns contents of comnum as a double
handles.comnumber=get(hObject,'String');%Get COM port number
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function comnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in connect.
function connect_Callback(hObject, eventdata, handles)
% hObject    handle to connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.mpc200 = serial(strcat('COM',handles.comnumber),'BaudRate',128000,'Terminator','CR');
fopen(handles.mpc200);
handles.mpc200.Parity = 'none';
set(handles.mpc200_status,'String','Connected to MPC-200/NOT Calib');
qstring=sprintf('Connected to Sutter Instrument ROE. ROE must be calibrated to work properly.\n\nWould you like to calibrate now?');
Cali=questdlg(qstring,'Calibration Required','Yes','Not now','Yes');
switch Cali
    case 'Yes'
        fprintf(handles.mpc200,'%c','N');
        set(handles.mpc200_status,'String','Connected to MPC-200/Calib');
end
% getpos_Callback(handles.getpos, eventdata, handles)
guidata(hObject, handles);

% --- Executes on button press in getpos.
function getpos_Callback(hObject, eventdata, handles)
% hObject    handle to getpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y,z]=getpos(handles.mpc200)
try_times = 0
while any([x,y,z] > 21500) || any([x,y,z] < 0)
    [x,y,z]=getpos(handles.mpc200);
    try_times = try_times + 1;
    if try_times > 5
        break
    end
end

set(handles.currentx,'String',num2str(x));
set(handles.currenty,'String',num2str(y));
set(handles.currentz,'String',num2str(z));
guidata(hObject, handles);


function setx_Callback(hObject, eventdata, handles)
% hObject    handle to setx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setx as text
%        str2double(get(hObject,'String')) returns contents of setx as a double


% --- Executes during object creation, after setting all properties.
function setx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sety_Callback(hObject, eventdata, handles)
% hObject    handle to sety (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sety as text
%        str2double(get(hObject,'String')) returns contents of sety as a double


% --- Executes during object creation, after setting all properties.
function sety_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sety (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function setz_Callback(hObject, eventdata, handles)
% hObject    handle to setz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setz as text
%        str2double(get(hObject,'String')) returns contents of setz as a double


% --- Executes during object creation, after setting all properties.
function setz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gotopos.
function gotopos_Callback(hObject, eventdata, handles)
% hObject    handle to gotopos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.x=str2double(get(handles.setx,'String'));
handles.y=str2double(get(handles.sety,'String'));
handles.z=str2double(get(handles.setz,'String'));

move_good = check_move(handles, [handles.x handles.y handles.z]);

if move_good
    disp('good move!')
    gotopos(handles.mpc200, handles.x, handles.y, handles.z);
else
    disp('bad move!')
end
guidata(hObject, handles);
% now_time = clock;
% elapse = clock - now_time;
% while ~(handles.mpc200.BytesAvailable > 1) && elapse(4) < 1, elapse = clock - now_time, end
% pause(.5)
% getpos_Callback(handles.getpos, eventdata, handles)



function transx_Callback(hObject, eventdata, handles)
% hObject    handle to transx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of transx as text
%        str2double(get(hObject,'String')) returns contents of transx as a double


% --- Executes during object creation, after setting all properties.
function transx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function transy_Callback(hObject, eventdata, handles)
% hObject    handle to transy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of transy as text
%        str2double(get(hObject,'String')) returns contents of transy as a double


% --- Executes during object creation, after setting all properties.
function transy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function transz_Callback(hObject, eventdata, handles)
% hObject    handle to transz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of transz as text
%        str2double(get(hObject,'String')) returns contents of transz as a double


% --- Executes during object creation, after setting all properties.
function transz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in translate.
function translate_Callback(hObject, eventdata, handles)
% hObject    handle to translate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
[curr_x,curr_y,curr_z]=getpos(handles.mpc200);
trans_x=str2double(get(handles.transx,'String'));
trans_y=str2double(get(handles.transy,'String'));
trans_z=str2double(get(handles.transz,'String'));
new_x = curr_x + trans_x;
new_y = curr_y + trans_y;
new_z = curr_z + trans_z;

move_good = check_move(handles, [new_x new_y new_z]);

if move_good
    disp('good move!')
    gotopos(handles.mpc200, new_x, new_y, new_z);
else
    disp('bad move!')
end
guidata(hObject, handles);
% pause(0.1);
% getpos_Callback(handles.getpos, eventdata, handles)



% --- Executes on button press in calibrate.
function calibrate_Callback(hObject, eventdata, handles)
% hObject    handle to calibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf(handles.mpc200,'%c','N');
set(handles.mpc200_status,'String','Connected to MPC-200/Calib');
% pause(0.1);
% getpos_Callback(handles.getpos, eventdata, handles)
guidata(hObject,handles)


% --- Executes on button press in use_obj_spatial.
function use_obj_spatial_Callback(hObject, eventdata, handles)
% hObject    handle to use_obj_spatial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_obj_spatial


% --- Executes on button press in disconnect.
function disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fclose(instrfind)



function grid_spacing_Callback(hObject, eventdata, handles)
% hObject    handle to grid_spacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grid_spacing as text
%        str2double(get(hObject,'String')) returns contents of grid_spacing as a double


% --- Executes during object creation, after setting all properties.
function grid_spacing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grid_spacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function radii_step_Callback(hObject, eventdata, handles)
% hObject    handle to radii_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radii_step as text
%        str2double(get(hObject,'String')) returns contents of radii_step as a double


% --- Executes during object creation, after setting all properties.
function radii_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radii_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_obj_min_Callback(hObject, eventdata, handles)
% hObject    handle to y_obj_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_obj_min as text
%        str2double(get(hObject,'String')) returns contents of y_obj_min as a double


% --- Executes during object creation, after setting all properties.
function y_obj_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_obj_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_obj_max_Callback(hObject, eventdata, handles)
% hObject    handle to y_obj_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_obj_max as text
%        str2double(get(hObject,'String')) returns contents of y_obj_max as a double


% --- Executes during object creation, after setting all properties.
function y_obj_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_obj_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_obj_min_Callback(hObject, eventdata, handles)
% hObject    handle to x_obj_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_obj_min as text
%        str2double(get(hObject,'String')) returns contents of x_obj_min as a double


% --- Executes during object creation, after setting all properties.
function x_obj_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_obj_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_obj_max_Callback(hObject, eventdata, handles)
% hObject    handle to x_obj_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_obj_max as text
%        str2double(get(hObject,'String')) returns contents of x_obj_max as a double


% --- Executes during object creation, after setting all properties.
function x_obj_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_obj_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function points_per_circle_Callback(hObject, eventdata, handles)
% hObject    handle to points_per_circle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of points_per_circle as text
%        str2double(get(hObject,'String')) returns contents of points_per_circle as a double


% --- Executes during object creation, after setting all properties.
function points_per_circle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to points_per_circle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_circles_Callback(hObject, eventdata, handles)
% hObject    handle to num_circles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_circles as text
%        str2double(get(hObject,'String')) returns contents of num_circles as a double


% --- Executes during object creation, after setting all properties.
function num_circles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_circles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in spatial_layout.
function spatial_layout_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in spatial_layout 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.spatial_layout = get(eventdata.NewValue,'Tag');
disp(handles.spatial_layout)
guidata(hObject,handles);


% --- Executes on button press in set_cell_pos.
function set_cell_pos_Callback(hObject, eventdata, handles)
% hObject    handle to set_cell_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y,z]=getpos(handles.mpc200);
x
y
z
handles.data.cell_pos = [x y z];
set(handles.cell_x,'String',num2str(x));
set(handles.cell_y,'String',num2str(y));
set(handles.cell_z,'String',num2str(z));
guidata(hObject, handles);




function z_obj_min_Callback(hObject, eventdata, handles)
% hObject    handle to z_obj_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_obj_min as text
%        str2double(get(hObject,'String')) returns contents of z_obj_min as a double


% --- Executes during object creation, after setting all properties.
function z_obj_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_obj_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_obj_max_Callback(hObject, eventdata, handles)
% hObject    handle to z_obj_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_obj_max as text
%        str2double(get(hObject,'String')) returns contents of z_obj_max as a double


% --- Executes during object creation, after setting all properties.
function z_obj_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_obj_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in do_circle_z.
function do_circle_z_Callback(hObject, eventdata, handles)
% hObject    handle to do_circle_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of do_circle_z


% --- Executes on button press in protect_cell.
function protect_cell_Callback(hObject, eventdata, handles)
% hObject    handle to protect_cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of protect_cell



function protection_range_Callback(hObject, eventdata, handles)
% hObject    handle to protection_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of protection_range as text
%        str2double(get(hObject,'String')) returns contents of protection_range as a double


% --- Executes during object creation, after setting all properties.
function protection_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protection_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in goto_cell.
function goto_cell_Callback(hObject, eventdata, handles)
% hObject    handle to goto_cell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cell_pos = handles.data.cell_pos;
handles.x=cell_pos(1);
handles.y=cell_pos(2);
handles.z=cell_pos(3);
move_good = check_move(handles, [handles.x handles.y handles.z]);

if move_good
    disp('good move!')
    gotopos(handles.mpc200, handles.x, handles.y, handles.z);
else
    disp('bad move!')
end
guidata(hObject, handles);

function move_good = check_move(handles,new_pos)

if isfield(handles,'mpc200')
    [curr_x,curr_y,curr_z]=getpos(handles.mpc200);
    abs([curr_x,curr_y,curr_z]-new_pos)
    move_good = ~any( abs([curr_x,curr_y,curr_z]-new_pos) > [5000 5000 1500]);
else
    move_good = 1;
end
    


% --- Executes on button press in translate_back.
function translate_back_Callback(hObject, eventdata, handles)
% hObject    handle to translate_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 
[curr_x,curr_y,curr_z]=getpos(handles.mpc200);
trans_x=str2double(get(handles.transx,'String'));
trans_y=str2double(get(handles.transy,'String'));
trans_z=str2double(get(handles.transz,'String'));
new_x = curr_x - trans_x;
new_y = curr_y - trans_y;
new_z = curr_z - trans_z;

move_good = check_move(handles, [new_x new_y new_z]);

if move_good
    disp('good move!')
    gotopos(handles.mpc200, new_x, new_y, new_z);
else
    disp('bad move!')
end
guidata(hObject, handles);



function trials_per_pulse_Callback(hObject, eventdata, handles)
% hObject    handle to trials_per_pulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trials_per_pulse as text
%        str2double(get(hObject,'String')) returns contents of trials_per_pulse as a double


% --- Executes during object creation, after setting all properties.
function trials_per_pulse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trials_per_pulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function series_r_max_Callback(hObject, eventdata, handles)
% hObject    handle to series_r_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of series_r_max as text
%        str2double(get(hObject,'String')) returns contents of series_r_max as a double


% --- Executes during object creation, after setting all properties.
function series_r_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to series_r_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tf_on.
function tf_on_Callback(hObject, eventdata, handles)
% hObject    handle to tf_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tf_on


% --- Executes on button press in locations.
function locations_Callback(hObject, eventdata, handles)
% hObject    handle to locations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of locations




% --- Executes on button press in cross.
function cross_Callback(hObject, eventdata, handles)
% hObject    handle to cross (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cross


% --- Executes on button press in set_cell2_pos.
function set_cell2_pos_Callback(hObject, eventdata, handles)
% hObject    handle to set_cell2_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y,z]=getpos(handles.mpc200);
x
y
z
handles.data.cell2_pos = [x y z];
set(handles.cell2_x,'String',num2str(x));
set(handles.cell2_y,'String',num2str(y));
set(handles.cell2_z,'String',num2str(z));
guidata(hObject, handles);


% --- Executes on button press in gotocell2.
function gotocell2_Callback(hObject, eventdata, handles)
% hObject    handle to gotocell2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cell2_pos = handles.data.cell2_pos;
handles.x=cell2_pos(1);
handles.y=cell2_pos(2);
handles.z=cell2_pos(3);
move_good = check_move(handles, [handles.x handles.y handles.z]);

if move_good
    disp('good move!')
    gotopos(handles.mpc200, handles.x, handles.y, handles.z);
else
    disp('bad move!')
end
guidata(hObject, handles);


% --- Executes on button press in settransform.
function settransform_Callback(hObject, eventdata, handles)
% hObject    handle to settransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,y,z]=getpos(handles.mpc200);
x
y
z
x= x - str2double(get(handles.currentx,'String'));
y= y - str2double(get(handles.currenty,'String'));
z= z - str2double(get(handles.currentz,'String'));

set(handles.transx,'String',num2str(x))
set(handles.transy,'String',num2str(y))
set(handles.transz,'String',num2str(z))
guidata(hObject, handles);





% --- Executes on button press in goto_marked_loc.
function goto_marked_loc_Callback(hObject, eventdata, handles)
% hObject    handle to goto_marked_loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

loc_i = str2double(get(handles.marked_loc_i,'String'));

pos = handles.data.marked_locs(loc_i,:);
handles.x=pos(1);
handles.y=pos(2);
handles.z=pos(3);
move_good = check_move(handles, [handles.x handles.y handles.z]);

if move_good
    disp('good move!')
    gotopos(handles.mpc200, handles.x, handles.y, handles.z);
else
    disp('bad move!')
end
guidata(hObject, handles);



function marked_loc_i_Callback(hObject, eventdata, handles)
% hObject    handle to marked_loc_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of marked_loc_i as text
%        str2double(get(hObject,'String')) returns contents of marked_loc_i as a double


% --- Executes during object creation, after setting all properties.
function marked_loc_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to marked_loc_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in remove_marked_loc.
function remove_marked_loc_Callback(hObject, eventdata, handles)
% hObject    handle to remove_marked_loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

loc_i = str2double(get(handles.marked_loc_i,'String'));

handles.data.marked_locs(loc_i,:) = [];
handles.data.stim_loc(loc_i) = [];

set(handles.marked_locs_table,'Data',[num2cell(handles.data.marked_locs) handles.data.stim_loc])
guidata(hObject, handles);


% --- Executes on button press in mark_loc.
function mark_loc_Callback(hObject, eventdata, handles)
% hObject    handle to mark_loc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y,z]=getpos(handles.mpc200);

if isfield(handles.data,'marked_locs')
    locs_tmp = [handles.data.marked_locs; x y z];
    stim_loc_tmp = [handles.data.stim_loc; {true}];
else
    locs_tmp = [x y z];
    stim_loc_tmp = {true};
end

handles.data.marked_locs = locs_tmp;
handles.data.stim_loc = stim_loc_tmp;

set(handles.marked_locs_table,'Data',[num2cell(handles.data.marked_locs) handles.data.stim_loc])
guidata(hObject, handles);




% --- Executes on button press in clear_locs.
function clear_locs_Callback(hObject, eventdata, handles)
% hObject    handle to clear_locs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.data.marked_locs = [];
handles.data.stim_loc = {};

set(handles.marked_locs_table,'Data',[num2cell(handles.data.marked_locs) handles.data.stim_loc])
guidata(hObject, handles);


% --- Executes when entered data in editable cell(s) in marked_locs_table.
function marked_locs_table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to marked_locs_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

tmp_data = get(hObject,'data');

if eventdata.Indices(2) == 4 % stim or don't
    tmp_stim_loc = handles.data.stim_loc;
    tmp_stim_loc{eventdata.Indices(1)} = tmp_data{eventdata.Indices(1),eventdata.Indices(2)};
    handles.data.stim_loc = tmp_stim_loc;
else % changing location
    tmp_marked_locs = handles.data.marked_locs;
    tmp_marked_locs(eventdata.Indices(1),eventdata.Indices(2)) = tmp_data{eventdata.Indices(1),eventdata.Indices(2)};
    handles.data.marked_locs = tmp_marked_locs;
end

guidata(hObject,handles);
    


% --- Executes on button press in load_locs.
function load_locs_Callback(hObject, eventdata, handles)
% hObject    handle to load_locs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname] = uigetfile('*.mat','Select the data file to load locs from...');
in_data = load([pathname '/' filename],'data');

handles.data.marked_locs = in_data.data.marked_locs;
handles.data.stim_loc = in_data.data.stim_loc;

set(handles.marked_locs_table,'Data',[num2cell(handles.data.marked_locs) handles.data.stim_loc])
guidata(hObject, handles);





function grid_spacing_z_Callback(hObject, eventdata, handles)
% hObject    handle to grid_spacing_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grid_spacing_z as text
%        str2double(get(hObject,'String')) returns contents of grid_spacing_z as a double


% --- Executes during object creation, after setting all properties.
function grid_spacing_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grid_spacing_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function offset_x_Callback(hObject, eventdata, handles)
% hObject    handle to offset_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offset_x as text
%        str2double(get(hObject,'String')) returns contents of offset_x as a double


% --- Executes during object creation, after setting all properties.
function offset_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function offset_y_Callback(hObject, eventdata, handles)
% hObject    handle to offset_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offset_y as text
%        str2double(get(hObject,'String')) returns contents of offset_y as a double


% --- Executes during object creation, after setting all properties.
function offset_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function offset_z_Callback(hObject, eventdata, handles)
% hObject    handle to offset_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offset_z as text
%        str2double(get(hObject,'String')) returns contents of offset_z as a double


% --- Executes during object creation, after setting all properties.
function offset_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cell_2_type_Callback(hObject, eventdata, handles)
% hObject    handle to cell_2_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cell_2_type as text
%        str2double(get(hObject,'String')) returns contents of cell_2_type as a double


% --- Executes during object creation, after setting all properties.
function cell_2_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cell_2_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in roi_id.
function roi_id_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in roi_id 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.roi_id = get(eventdata.NewValue,'Tag');
disp(handles.roi_id)

switch handles.roi_id
    case 'roi1'

        load(handles.defaults.lut_file1,'lut')
        

   case 'roi2'

        load(handles.defaults.lut_file2,'lut')

    case 'roi3'
 
        load(handles.defaults.lut_file3,'lut')

end

handles.data.lut = lut;
set(handles.load_lut,'ForegroundColor',[0 .5 .5])


guidata(hObject,handles);



function series_r2_max_Callback(hObject, eventdata, handles)
% hObject    handle to series_r2_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of series_r2_max as text
%        str2double(get(hObject,'String')) returns contents of series_r2_max as a double


% --- Executes during object creation, after setting all properties.
function series_r2_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to series_r2_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in spatial_power.
function spatial_power_Callback(hObject, eventdata, handles)
% hObject    handle to spatial_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warndlg('Have you opened the socket?','Open Socket','modal')
rng(1234)
spatial_power_output = spatial_power_measure(handles.data.lut,handles.data.ratio_map');

set(handles.trial_length,'String',num2str(spatial_power_output.total_duration))
handles = trial_length_Callback(handles.trial_length, [], handles);

spatial_power_output.trial_create = handles.run_count + 1;

if isfield(handles.data,'spatial_stim_info')
    handles.data.spatial_stim_info(end + 1) = spatial_power_output;
else
    handles.data.spatial_stim_info = spatial_power_output;
end

guidata(hObject,handles);
mssend(handles.sock,spatial_power_output)






% --- Executes on button press in open_socket.
function open_socket_Callback(hObject, eventdata, handles)
% hObject    handle to open_socket (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

srvsock = mslisten(3000);
warndlg('Please connect Slidebook client...','Connect Client','modal')

handles.sock = msaccept(srvsock);
msclose(srvsock); 

guidata(hObject,handles);


% --- Executes on button press in close_socket.
function close_socket_Callback(hObject, eventdata, handles)
% hObject    handle to close_socket (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msclose(handles.sock);
guidata(hObject,handles);


% --- Executes on button press in set_pia_pos.
function set_pia_pos_Callback(hObject, eventdata, handles)
% hObject    handle to set_pia_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,y,z]=getpos(handles.mpc200);
x
y
z
handles.data.pia_pos = [x y z];
set(handles.pia_x,'String',num2str(x));
set(handles.pia_y,'String',num2str(y));
set(handles.pia_z,'String',num2str(z));
guidata(hObject, handles);


% --- Executes on button press in trigger_seq.
function trigger_seq_Callback(hObject, eventdata, handles)
% hObject    handle to trigger_seq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of trigger_seq
