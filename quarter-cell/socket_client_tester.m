
function varargout = socket_client_tester(varargin)
% SOCKET_CLIENT_TESTER MATLAB code for socket_client_tester.fig
%      SOCKET_CLIENT_TESTER, by itself, creates a new SOCKET_CLIENT_TESTER or raises the existing
%      singleton*.
%
%      H = SOCKET_CLIENT_TESTER returns the handle to a new SOCKET_CLIENT_TESTER or the handle to
%      the existing singleton*.
%
%      SOCKET_CLIENT_TESTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOCKET_CLIENT_TESTER.M with the given input arguments.
%
%      SOCKET_CLIENT_TESTER('Property','Value',...) creates a new SOCKET_CLIENT_TESTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before socket_client_tester_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to socket_client_tester_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help socket_client_tester

% Last Modified by GUIDE v2.5 13-Mar-2017 14:24:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @socket_client_tester_OpeningFcn, ...
                   'gui_OutputFcn',  @socket_client_tester_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...c
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


% --- Executes just before socket_client_tester is made visible.
function socket_client_tester_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to socket_client_tester (see VARARGIN)

% Choose default command line output for socket_client_tester
handles.output = hObject;

if ~isempty(varargin) && ~isempty(varargin{1})
    server_location = varargin{1};
else
    server_location = 'ephys';
end

if length(varargin) > 1 && ~isempty(varargin{2})
    client_location = varargin{2};
else
    client_location = 'slidebook';
end

switch server_location
    case 'ephys'
        handles.server_ipaddress = '128.32.177.239';
    case 'c'
        handles.server_ipaddress = '128.32.177.238';
end

switch client_location
    case 'slidebook'
        handles.port_num = 3000;
        handles.data = struct();
    case 'analysis'
        handles.port_num = 3001;
        handles.data.params = init_oed(0);
end



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes socket_client_tester wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = socket_client_tester_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.start,'BackgroundColor',[.8 .8 .8])
drawnow
disp('init socket if not...')
if ~isfield(handles,'sock') 
    handles.sock = -1;
% elseif isfield(handles,'sock') && isfield(handles,'close_socket') && handles.close_
end
disp('attempting to open socket')

while handles.sock < 0

% sock = -1;
% while sock < 0

    handles.sock = msconnect(handles.server_ipaddress,handles.port_num);
%     sock = msconnect('128.32.177.239',3000);
    drawnow
end


disp('waiting for instruction...')
% if ~isfield(handles,'waittime')
%     handles.waittime = 120;
% end
instruction = [];
disp('check for instruction...')
pause(.1)
while isempty(instruction)

    disp('check for instruction...')
    [instruction, success] = msrecv(handles.sock,.5);

end
disp('got instruction')
if isempty(instruction)
    disp('no instruction!!')
    msclose(handles.sock)
    handles = rmfield(handles,'sock');
    guidata(hObject,handles)
    return
end

assignin('base','instruction',instruction)
disp('got info...')

MOVE_OBJ = 10;
GET_OBJ_POS_STEP0 = 20;
GET_OBJ_POS_STEP1 = 21;
GET_SEQ = 30;
RETRIGGER_SEQ = 31;
SET_TRIGGER_SEQ = 32;
GET_VAR = 40;
PRECOMPUTE_PHASE = 50;
OBJ_GO_TO = 60;
DETECT_NUC = 70;
DETECT_NUC_LOCAL = 71;
DETECT_NUC_SERVE = 72;
CLICK_LOCS = 73;
DETECT_NUC_SERVE_W_STACK = 74;
DETECT_NUC_FROM_MAT = 75;
COMPUTE_GROUPS_AND_OPTIM_LOCS = 76;
PRECOMPUTE_PHASE_NUCLEAR = 81;
PRECOMPUTE_PHASE_MULTI_W_COMBO_SELECT = 82;
PRECOMPUTE_PHASE_MULTI = 83;
TAKE_SNAP = 91;
TAKE_STACK = 92;
DETECT_EVENTS_OASIS = 100;
PRINT = 00;

instruction.type
return_info = struct();
if success >= 0
    disp('doing something...')
    instruction.type
    switch instruction.type
        case PRINT
            disp(instruction.string)
            return_info.test = 1;
        case OBJ_GO_TO
            disp('moving obj...')
            vars{1} = instruction.theNewX';
            names{1} = 'theNewX';
            vars{2} = instruction.theNewY;
            names{2} = 'theNewY';
            vars{3} = instruction.theNewZ;
            names{3} = 'theNewZ';
%             vars{4} = 1;
%             names{4} = 'isMoveStageAbsolute';
            assignin_base(names,vars);
            evalin('base','move_stage_absolute')
            
%             pause(1)
%             pause(1)
%             pause(1)
%             pause(1)
%             java.lang.Thread.sleep(5*1000);
%             return_info.currX = getVariable('base','currentStageX');
%             return_info.currY = getVariable('base','currentStageY');
%             return_info.currZ = getVariable('base','currentStageZ');
%             pause(2)
%             assignin_base({'isGetStageLocation'},{1})
%             pause(3)
            return_info.currX = evalin('base','currentStageX');
            return_info.currY = evalin('base','currentStageY');
            return_info.currZ = evalin('base','currentStageZ');
            handles.data.currX = return_info.currX;
            handles.data.currY = return_info.currY;
            handles.data.currZ = return_info.currZ;
            return_info.success = 1;
        case MOVE_OBJ
            disp('moving obj...')
            vars{1} = instruction.deltaX;
            names{1} = 'deltaX';
            vars{2} = instruction.deltaY;
            names{2} = 'deltaY';
            vars{3} = instruction.deltaZ;
            names{3} = 'deltaZ';
%             vars{4} = 1;
%             names{4} = 'isMoveStageRelative';
            assignin_base(names,vars);
            evalin('base','move_stage_relative');
%             pause(1)
%             pause(1)
%             pause(1)
%             pause(1)
%             java.lang.Thread.sleep(5*1000);
%             return_info.currX = getVariable('base','currentStageX');
%             return_info.currY = getVariable('base','currentStageY');
%             return_info.currZ = getVariable('base','currentStageZ');
% %             pause(2)
%             assignin_base({'isGetStageLocation'},{1})
%             pause(3)
            return_info.currX = evalin('base','currentStageX');
            return_info.currY = evalin('base','currentStageY');
            return_info.currZ = evalin('base','currentStageZ');
            handles.data.currX = return_info.currX;
            handles.data.currY = return_info.currY;
            handles.data.currZ = return_info.currZ;
            return_info.success = 1;
            
        case GET_OBJ_POS_STEP0
            disp('prepping ws')
            evalin('base','clear currentStageX')
            evalin('base','clear currentStageY')
            evalin('base','clear currentStageZ')
%             assignin_base({'isGetStageLocation'},{1})
            evalin('base','get_stage_location')
            return_info.currX = evalin('base','currentStageX');
            return_info.currY = evalin('base','currentStageY');
            return_info.currZ = evalin('base','currentStageZ');
            handles.data.currX = return_info.currX;
            handles.data.currY = return_info.currY;
            handles.data.currZ = return_info.currZ;
            return_info.success = 1;

        case GET_OBJ_POS_STEP1
            disp('getting pos vars')
            return_info.currX = evalin('base','currentStageX');
            return_info.currY = evalin('base','currentStageY');
            return_info.currZ = evalin('base','currentStageZ');
            handles.data.currX = return_info.currX;
            handles.data.currY = return_info.currY;
            handles.data.currZ = return_info.currZ;
            return_info.success = 1;
        case GET_SEQ
            disp('setting seq')
            sequence = instruction.sequence;
            handles.data.tf_flag = instruction.tf_flag;
            if sequence(1).power > 2
                if handles.data.tf_flag
                    handles.data.lut = evalin('base','lut_tf');
                    handles.data.pockels_ratio_refs = evalin('base','pockels_ratio_refs_tf');
                else
                    handles.data.lut = evalin('base','lut_notf');
                    handles.data.pockels_ratio_refs = evalin('base','pockels_ratio_refs_notf');                
                end
            end
%             pockels_ratio_refs = [pockels_ratio_refs pockels_ratio_refs];
            for i = 1:length(sequence)
                if sequence(i).power > 2
                    ind = sequence(i).precomputed_target_index;
                    sequence(i).target_power = sequence(i).power;
                    sequence(i).power = 100*get_voltage(handles.data.lut,...
                        handles.data.pockels_ratio_refs(ind)*sequence(i).power);
                else
                    sequence(i).power = sequence(i).power*100;
                end
            end
            %sequence(i).precomputed_target_index
            if instruction.set_trigger
                vars{1} = sequence;
                names{1} = 'sequence';
    %             vars{2} = 1;
    %             names{2} = 'isTriggeredSequenceReady';
                assignin_base(names,vars);
                evalin('base','set_seq_trigger')
            end
%             pause(1)
            return_info.success = 1;
            if handles.data.tf_flag
                return_info.stim_key = evalin('base','tf_stim_key');
            else
                return_info.stim_key = evalin('base','notf_stim_key');
            end
            return_info.sequence = sequence;
            handles.data.sequence= sequence;
            handles.data.stim_key = return_info.stim_key;
        case RETRIGGER_SEQ
%             vars{1} = 1;
%             names{1} = 'isTriggeredSequenceReady';
%             assignin_base(names,vars);
%             pause(1)
            evalin('base','set_seq_trigger')
            return_info.success = 1;
        case SET_TRIGGER_SEQ
%             vars{1} = 1;
%             names{1} = 'i25sTriggeredSequenceReady';
%             assignin_base(names,vars);
%             pause(1)
            vars{1} = instruction.sequence;
            names{1} = 'sequence';
            assignin_base(names,vars);
            evalin('base','set_seq_trigger')
            return_info.success = 1;
            handles.data.set_sequence = instruction.sequence;
        case GET_VAR
            assignin_base({instruction.name},{instruction.value})
            return_info.success = 1;
        case DETECT_NUC_LOCAL
%             return_info = evalin('base','return_info');
%             detect_img = evalin('base','detect_img');
%             nuclear_locs = evalin('base','nuclear_locs');
            system(['smbclient //adesnik2.ist.berkeley.edu/excitation adesnik110623 -c ''cd /shababo ; '...
                'get ' instruction.stackname '.tif ' '/media/shababo/data/' instruction.stackname '.tif''']);
            pause(1)
            if ~instruction.dummy_targs
                [nuclear_locs,] = ...
                    detect_nuclei(['/media/shababo/data/' instruction.stackname],...
                    instruction.image_um_per_px,instruction.image_zero_order_coord,...
                    instruction.stack_um_per_slice);
            end
            if instruction.dummy_targs || isempty(nuclear_locs) || any(isnan(nuclear_locs(:)))
                nuclear_locs = [randi([-150 150],[100 1]) randi([-150 150],[100 1]) randi([0 100],[100 1])];
                detect_img = zeros(256,256);
            end
            return_info.nuclear_locs = nuclear_locs;
            return_info.detect_img = zeros(256,256);
        case DETECT_NUC_FROM_MAT
%             system(['smbclient //adesnik2.ist.berkeley.edu/excitation adesnik110623 -c ''cd /shababo ; '...
%                 'get ' instruction.stack_id '.mat ' '/media/shababo/data/' instruction.stack_id '.mat''']);
%             load(['/media/shababo/data/' instruction.stack_id '.mat'])
%             filename = ['/media/shababo/data/' instruction.filename '.tif'];
%             write_tiff_stack(filename,imagemat)
            disp('into main function')
            filename = ['/media/shababo/data/' instruction.filename '.tif'];
            disp('writing tif')
            write_tiff_stack(filename,instruction.stackmat)
            if ~isfield(instruction,'dummy_targs')
                instruction.dummy_target = 0;
            end
            if ~instruction.dummy_targs
                disp('detecting nucs')
                [nuclear_locs, fluor_vals] = ...
                    detect_nuclei(filename,...
                    instruction.image_um_per_px,instruction.image_zero_order_coord,...
                    instruction.stack_um_per_slice);
            end
            if instruction.dummy_targs || isempty(nuclear_locs) || any(isnan(nuclear_locs(:)))
                disp('creating dummy nucs')
                if isfield(instruction,'num_dummy_targs')
                    num_targs = instruction.num_dummy_targs;
                else
                    num_targs = 100;
                end
                nuclear_locs = [randi([-150 150],[num_targs 1]) randi([-150 150],[num_targs 1]) randi([0 100],[num_targs 1])];
                fluor_vals = zeros(num_targs,1);
            end
            return_info.nuclear_locs = nuclear_locs;
            return_info.fluor_vals = fluor_vals;
%             return_info.detect_img = detect_img;
        case DETECT_NUC_SERVE
            instruction_out.type = DETECT_NUC_LOCAL;
            instruction_out.stackname = instruction.stackname;
            instruction_out.image_zero_order_coord = round(evalin('base','image_zero_order_coord'));
            instruction_out.image_um_per_px = evalin('base','image_um_per_px');
            instruction_out.stack_um_per_slice = evalin('base','stack_um_per_slice');
            instruction_out.dummy_targs = 0;
            copyfile([instruction.stackname '_C0.tif'], ['Y:\shababo\' instruction.stackname '.tif']);
            pause(1)
            [return_info,success,handles] = do_instruction(instruction_out,handles) ;
            figure
            imagesc(return_info.detect_img)
%              locs_test = evalin('base','locs_test');
%              return_info.nuclear_locs = locs_test(1:200,:);
%              return_info.detect_img = zeros(256,256);
        case DETECT_NUC_SERVE_W_STACK
            evalin('base','take_stack')
            instruction_out.type = DETECT_NUC_LOCAL;
            instruction_out.stackname = instruction.stackname;
            instruction_out.image = evalin('base','acquiredImage');
            instruction_out.image_zero_order_coord = round(evalin('base','image_zero_order_coord'));
            instruction_out.image_um_per_px = evalin('base','image_um_per_px');
            instruction_out.stack_um_per_slice = evalin('base','stack_um_per_slice');
            instruction_out.dummy_targs = 0;
            instruction_out.get_return = 1;
            [return_info,success,handles] = do_instruction(instruction_out,handles);
            figure
            imagesc(return_info.detect_img)
        case COMPUTE_GROUPS_AND_OPTIM_LOCS
            handles.data.cells_targets = get_groups_and_stim_locs(...
                instruction.cell_locations, handles.data.params,...
                instruction.z_locs, instruction.z_slice_width);
            return_info.cells_targets = handles.data.cells_targets;
        case CLICK_LOCS
             evalin('base','take_snap')
             handles.snap_image = evalin('base','temp');
             return_info.snap_image = evalin('base','temp');
             this_image = evalin('base','temp');
             figure; imagesc(this_image)
             if instruction.num_targs
                 num_targs = instruction.num_targs;
             else
                 num_targs = input('How many targets?');
             end
             
             [y, x] = ginput(num_targs);
             zero_order_pos = evalin('base','image_zero_order_coord')';
             image_px_per_um = evalin('base','image_um_per_px');
             click_locs = [(bsxfun(@minus,[x y],zero_order_pos))*image_px_per_um zeros(size(x))];
             return_info.nuclear_locs = click_locs;
        case PRECOMPUTE_PHASE
            tf_flag = instruction.tf_flag;
            if tf_flag
                spots_phase = evalin('base','tf_all_spots_phase');
%                 pockels_ratio_refs = evalin('base','pockels_ratio_refs_tf');
            else
                spots_phase = evalin('base','notf_all_spots_phase');
%                 pockels_ratio_refs = evalin('base','pockels_ratio_refs_notf');                
            end
%             diskRadii = evalin('base','diskRadii');
%             diskPhase = evalin('base','diskPhase');
            
        case PRECOMPUTE_PHASE_NUCLEAR
            pockels_ratio_refs_tf_full_map = evalin('base','pockels_ratio_refs_tf_full_map');
            coarse_disks = evalin('base','tf_disk_grid');
            disk_key = evalin('base','tf_disk_key');
            fine_spot_grid = evalin('base','tf_fine_grid_spots_phase');
            fine_spot_key = evalin('base','tf_fine_grid_spots_key');
            do_target = instruction.do_target;
            [phase_masks_target, dec_ind] = ...
                build_single_loc_phases(instruction.target_locs,coarse_disks,disk_key,...
                fine_spot_grid,fine_spot_key,do_target);
            pockels_ratio_refs_tf = pockels_ratio_refs_tf_full_map(dec_ind);
            vars{1} = pockels_ratio_refs_tf;
            names{1} = 'pockels_ratio_refs_tf';
            vars{2} = instruction.target_locs;
            names{2} = 'tf_stim_key';
            if do_target
                vars{3} = phase_masks_target;
                names{3} = 'precomputed_target';
                assignin_base(names,vars);
                evalin('base','set_precomp_target_ready')
            else
                vars{3} = phase_masks_target;
                names{3} = 'phase_masks_target';
                assignin_base(names,vars);
            end
%             clear phase_masks_target
        case PRECOMPUTE_PHASE_MULTI_W_COMBO_SELECT
            ratio_map = evalin('base','power_map_upres');
            coarse_disks = evalin('base','tf_disk_grid');
            disk_key = evalin('base','tf_disk_key');
            fine_spot_grid = evalin('base','tf_fine_grid_spots_phase');
            fine_spot_key = evalin('base','tf_fine_grid_spots_key');
            do_target = instruction.do_target;
%             [phase_masks_target, dec_ind] = ...
%                 build_single_loc_phases(instruction.target_locs,coarse_disks,disk_key,...
%                 fine_spot_grid,fine_spot_key,do_target);
            [phase_masks_target,stim_key,pockels_ratio_refs_multi] = ...
                build_multi_loc_phases_w_combos(instruction.multitarg_locs,instruction.num_stim,instruction.single_spot_locs,...
                instruction.targs_per_stim,instruction.repeat_target,coarse_disks,disk_key,ratio_map,...
                fine_spot_grid,fine_spot_key,do_target,1);
            pockels_ratio_refs_tf = pockels_ratio_refs_multi;
            vars{1} = pockels_ratio_refs_tf;
            names{1} = 'pockels_ratio_refs_tf';
            vars{2} = stim_key;
            names{2} = 'tf_stim_key';
            if do_target
                vars{3} = phase_masks_target;
                names{3} = 'precomputed_target';
                assignin_base(names,vars);
                evalin('base','set_precomp_target_ready')
            else
                vars{3} = phase_masks_target;
                names{3} = 'phase_masks_target';
                assignin_base(names,vars);
            end
            return_info.num_stim = size(stim_key,1);
            clear phase_masks_target
        case PRECOMPUTE_PHASE_MULTI
%             ratio_map = evalin('base','power_map_upres');
            coarse_disks = evalin('base','tf_disk_grid');
            disk_key = evalin('base','tf_disk_key');
            fine_spot_grid = evalin('base','tf_fine_grid_spots_phase');
            fine_spot_key = evalin('base','tf_fine_grid_spots_key');
            do_target = instruction.do_target;
%             [phase_masks_target, dec_ind] = ...
%                 build_single_loc_phases(instruction.target_locs,coarse_disks,disk_key,...
%                 fine_spot_grid,fine_spot_key,do_target);
            [phase_masks_target,stim_key,pockels_ratio_refs_multi] = ...
                build_multi_loc_phases(instruction.multi_spot_targs,instruction.multi_spot_pockels,...
                    instruction.pockels_ratios, instruction.single_spot_targs, ...
                    instruction.single_spot_pockels_refs,...
                    coarse_disks,disk_key,fine_spot_grid,fine_spot_key,instruction.do_target);
            pockels_ratio_refs_tf = pockels_ratio_refs_multi;
            vars{1} = pockels_ratio_refs_tf;
            names{1} = 'pockels_ratio_refs_tf';
            vars{2} = stim_key;
            names{2} = 'tf_stim_key';
            if do_target
                vars{3} = phase_masks_target;
                names{3} = 'precomputed_target';
                assignin_base(names,vars);
                evalin('base','set_precomp_target_ready')
            else
                vars{3} = phase_masks_target;
                names{3} = 'phase_masks_target';
                assignin_base(names,vars);
            end
            return_info.num_stim = size(stim_key,1);
            clear phase_masks_target    
        case TAKE_SNAP
            evalin('base','take_snap')
            handles.snap_image = evalin('base','temp');
            return_info.snap_image = evalin('base','temp');
            return_info.success = 1;
        case TAKE_STACK
            evalin('base','take_stack_prep')
            pause(.1)
            evalin('base','take_stack')
            return_info.image = evalin('base','acquiredImage');
            return_info.image_zero_order_coord = round(evalin('base','image_zero_order_coord'));
            return_info.image_um_per_px = evalin('base','image_um_per_px');
            return_info.stack_um_per_slice = evalin('base','stack_um_per_slice');
        case DETECT_EVENTS_OASIS
            
            cmd = 'python /home/shababo/projects/mapping/code/OASIS/run_oasis_online.py ';
            if instruction.do_dummy_data
                instruction.filename = '1120traces_sub';
            end
            fullsavepath = ['/media/shababo/data/' instruction.filename '.mat'];
            oasis_out_path = ['/media/shababo/data/' instruction.filename '_detect.mat'];
            if ~instruction.do_dummy_data
                traces = instruction.data;
            else
                load('/media/shababo/data/1120traces.mat')
                traces = traces(1:size(instruction.data,1),:);
            end
            save(fullsavepath,'traces')
            cmd = [cmd ' ' fullsavepath];
            system(cmd)
            % Wait for file to be created.
            maxSecondsToWait = 60*5; % Wait five minutes...?
            secondsWaitedSoFar  = 0;
            while secondsWaitedSoFar < maxSecondsToWait 
              if exist(oasis_out_path, 'file')
                break;
              end
              pause(1); % Wait 1 second.
              secondsWaitedSoFar = secondsWaitedSoFar + 1;
            end
            return_info.time_est = secondsWaitedSoFar;
            if exist(oasis_out_path, 'file')
              load(oasis_out_path)
              return_info.oasis_data = reshape(event_process,size(instruction.data'))';
              
            else
              fprintf('Warning: x.log never got created after waiting %d seconds', secondsWaitedSoFar);
%               uiwait(warndlg(warningMessage));
              return_info.oasis_data = zeros(size(instruction.traces));
            end
    end
    
    
end
% return_info.test_turing = 1;
if instruction.type == DETECT_NUC_LOCAL
    
    clear return_info
    % return_info.test_turing = 1;
    
    return_info.nuclear_locs = nuclear_locs;
    return_info.detect_img = detect_img;

end
assignin('base','return_info',return_info)
disp('sending return info')
mssend(handles.sock,return_info);
handles.close_socket = instruction.close_socket;
% if isfield(instruction,'waittime')
%     handles.waittime = instruction.waittime
% else
%     handles.waittime = 120
% end

handles.data.return_info = return_info;
guidata(hObject,handles)

pause(10);

if isfield(instruction,'close_socket') && instruction.close_socket
    disp('closing socket')
    msclose(handles.sock)
%     handles.sock = -1;
    handles = rmfield(handles,'sock');
elseif ~isfield(instruction,'close_socket')
    disp('closing socket')
    msclose(handles.sock)
    handles = rmfield(handles,'sock');
else
    disp('socket open')
    
    start_Callback(hObject, eventdata, handles)
%     warndlg('restart socket!')
%     set(handles.start,'BackgroundColor','Red')
%     
%     drawnow
end
guidata(hObject,handles)

% %recur!
% if isfield(instruction,'reset') && instruction.reset
%     start_Callback(hObject, eventdata, handles)
% end


function assignin_base(names,vars)

for i = 1:length(names)
    assignin('base',names{i},vars{i});
end

% function vname_string = vname(var)
% 
% vname_string = inputname(1);
            
            
            
            
            
            
            


% --- Executes on button press in check_socket.
function check_socket_Callback(hObject, eventdata, handles)
% hObject    handle to check_socket (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in close_socket.
function close_socket_Callback(hObject, eventdata, handles)
% hObject    handle to close_socket (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'sock') && handles.sock > 0
    disp('closing socket')
    msclose(handles.sock)
    handles = rmfield(handles,'sock');
    guidata(hObject,handles)
else
    disp('no socket')
end


if isfield(handles,'sock_out') && handles.sock_out > 0
    disp('closing socket out')
    msclose(handles.sock_out)
    handles = rmfield(handles,'sock_out');
    guidata(hObject,handles)
else
    disp('no socket')
end

set(handles.socket_status,'String','Socket: Closed')

function [return_info, success, handles] = do_instruction(instruction, handles)

instruction.close_socket = 1;
% if instruction.type == 21
%     handles.sock
% end
if ~isfield(handles,'sock_out')
    disp('opening socket...')
    srvsock = mslisten(handles.client_port);
%     handles.sock = -1;
    handles.sock_out = msaccept(srvsock);
    disp('socket open..')
    msclose(srvsock);
end
% if isfield(handles,'close_socket')
%     instruction.close_socket = get(handles.close_socket_check,'Value');
% else
%     instruction.close_socket = 1;
% end
if isfield(instruction,'get_return')
    get_return = instruction.get_return;
else
    get_return = 1;
end
pause(.1)
disp('sending instruction...')
mssend(handles.sock_out,instruction);
if get_return
    disp('getting return info...')
    pause(.1)
    return_info = [];
    while isempty(return_info)
        [return_info, success] = msrecv(handles.sock_out,5);
    end
    assignin('base','return_info',return_info)
else
    return_info = [];
end
% success = 1;

if instruction.close_socket
    disp('closing socket')
    msclose(handles.sock_out)
    handles = rmfield(handles,'sock_out');
end
