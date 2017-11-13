function [return_info, varargout] = do_instruction(instruction, varargin)

if ~isempty(varargin) && ~isempty(varargin{1})
    handles = varargin{1};
else
    handles = [];
end

PRINT = 00;
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
RUN_VI = 110;
DETECT_EVENTS_OASIS_AND_RUN_VI = 200;
RUN_FULL_ONLINE_PIPELINE = 300;
CHECK_FOR_BATCH = 401;

success = 1;

% instruction.type
return_info = struct();
if success >= 0
%     disp('doing something...')
%     instruction.type
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
                    sequence(i).power = round(100*get_voltage(handles.data.lut,...
                        handles.data.pockels_ratio_refs(ind)*sequence(i).power));
                    if isfield(sequence,'waveform')
                        sequence(i).waveform = sprintf(sequence(i).waveform,sequence(i).power);
                    end
                else
                    sequence(i).power = sequence(i).power*100;
                end
                if isfield(sequence,'waveform')
                    sequence(i).waveform = sprintf(sequence(i).waveform,sequence(i).power);
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
%                 'get ' instruction.filename '.tif ' '/media/shababo/data/' instruction.filename '.tif''']);
%             load(['/media/shababo/data/' instruction.stack_id '.mat'])
%             filename = ['/media/shababo/data/' instruction.filename '.tif'];
%             write_tiff_stack(filename,imagemat)
            disp('into main function')
            filename = ['/media/shababo/data/' instruction.filename '.tif'];
            disp('writing tif')
            write_tiff_stack(filename,uint16(instruction.stackmat))
            if ~isfield(instruction,'dummy_targs')
                instruction.dummy_target = 0;
            end
            if ~instruction.dummy_targs
                disp('detecting nucs')
                [nuclear_locs, fluor_vals] = ...
                    detect_nuclei(['/media/shababo/data/' instruction.filename],...
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
            if instruction.make_neurons_struct
                neurons = build_neurons_struct(nuclear_locs,fluor_vals,instruction.experiment_setup);
                return_info.neurons = neurons;
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
%             evalin('base','take_stack_prep')
%             pause(.1)
            evalin('base','take_stack')
            image_all_ch = evalin('base','acquiredImage');
            return_info.image = image_all_ch(:,:,:,1)/9999*2^16; % scale to 16-bit
            return_info.image_zero_order_coord = round(evalin('base','image_zero_order_coord'));
            return_info.image_um_per_px = evalin('base','image_um_per_px');
            return_info.stack_um_per_slice = evalin('base','stack_um_per_slice');
%             write_tiff_stack([instruction.filename '.tif'],uint16(image_all_ch(:,:,:,1)));
%             copyfile([instruction.filename '.tif'], ['Y:\shababo\' instruction.filename '.tif']);
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
        case RUN_VI
            return_info.data = run_vi_online(instruction.data);
        case DETECT_EVENTS_OASIS_AND_RUN_VI
            
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
              handles.data.oasis_data = reshape(event_process,size(instruction.data'))';
              
            else
              fprintf('Warning: x.log never got created after waiting %d seconds', secondsWaitedSoFar);
%               uiwait(warndlg(warningMessage));
              handles.data.oasis_data = zeros(size(instruction.traces));
            end
            instruction.exp_data.oasis_data = handles.data.oasis_data;
            return_info.data = run_vi_online(instruction.exp_data);
        case RUN_FULL_ONLINE_PIPELINE
            
            experiment_setup = instruction.experiment_setup;
            for i = 1:length(instruction.neighbourhoods)
                neighbourhood = instruction.neighbourhoods(i);
                experiment_query = instruction.experiment_query(i);
                
                fullpathname = [experiment_setup.analysis_root experiment_setup.exp_id ...
                    '_n' num2str(neighbourhood.neighbourhood_ID)...
                    '_b' num2str(experiment_query.batch_ID) '_to_analysis.mat'];
                save(fullpathname,'neighbourhood','experiment_query','experiment_setup')
                cmd = ['matlab -nodesktop -nodisplay -nosplash -r '...
                    '"run_online_pipeline(''' fullpathname ''');" &'];
                system(cmd);
            end
%         case QUEUE_FULL_ONLINE_PIPELINE
%             
%             for i = 1:length(instruction.neighbourhoods)
%                 neighbourhood = instruction.neighbourhoods(i);
%                 experiment_query = instruction.experiment_query(i);
%                 fullpathname = [instruction.experiment_setup.analysis_root instruction.experiment_setup.exp_id ...
%                     '_n' num2str(neighbourhood.neighbourhood_ID)...
%                     '_b' num2str(experiment_query.batch_ID) '_to_analysis.mat'];
%                 save(fullpathname,'neighbourhood','experiment_query','experiment_setup')
% 
%             end
        case CHECK_FOR_BATCH
            
            files = dir(instruction.dir);
            matchfile_ind = find(cellfun(@(x) ~isempty(x),...
                regexp({files.name},instruction.matchstr)));
            if length(matchfile_ind) > 1
                warndlg('more than one file found that matches :(')
            end
            if ~isempty(matchfile_ind)
                filename = files(matchfile_ind(1)).name;
                load([instruction.dir filename])
                return_info.batch_found = 1;
                return_info.experiment_query = experiment_query;
                return_info.neighbourhood = neighbourhood;
            else
                return_info.batch_found = 0;
            end
           
            
        case CHECK_FOR_ANALYSIS
                
            % CHECK FOR FILE
            cmd = ['matlab -nojvm -nodisplay -nosplash '...
                '"run_online_pipeline(' fullpathname ')"';];
            system(cmd)
            
    end 
    
    
end
% return_info.test_turing = 1;
if instruction.type == DETECT_NUC_LOCAL
    
    clear return_info
    % return_info.test_turing = 1;
    
    return_info.nuclear_locs = nuclear_locs;
    return_info.detect_img = detect_img;

end

varargout{1} = handles;