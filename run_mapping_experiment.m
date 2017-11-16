function run_mapping_experiment(experiment_setup,varargin)

switch experiment_setup.experiment_type
    case 'pilot'
    case 'experiment'
    
        experiment_setup.is_exp = 1;
        
        handles = varargin{1};
        hObject = varargin{2};

        choice = questdlg('Choose start point?',...
            'Choose start point?', ...
            'Yes','No','Yes');
        % Handle response
        switch choice
            case 'Yes'
                experiment_setup.enable_user_breaks = 1;
            case 'No'
                experiment_setup.enable_user_breaks = 0;
        end
        guidata(hObject,handles)

        reinit_oed = 0;
        if experiment_setup.enable_user_breaks
            choice = questdlg('Initialize OED experiment_setup?',...
                'Initialize OED experiment_setup?', ...
                'Yes','No','Yes');
            % Handle response
            switch choice
                case 'Yes'
                    reinit_oed = 1;
                    choice = questdlg('Continue user control?',...
                        'Continue user control?', ...
                        'Yes','No','Yes');
                    % Handle response
                    switch choice
                        case 'Yes'
                            experiment_setup.enable_user_breaks = 1;
                        case 'No'
                            experiment_setup.enable_user_breaks = 0;
                    end
                    guidata(hObject,handles)
                case 'No'
                    reinit_oed = 0;
            end
        end

        if reinit_oed
            load_map = 1;
            experiment_setup = get_experiment_setup(load_map);
            guidata(hObject,handles)
        end

        load_exp = 0;
        if experiment_setup.enable_user_breaks
            choice = questdlg('Load an experiment?',...
                'Initialize OED experiment_setup?', ...
                'Yes','No','Yes');
            % Handle response
            switch choice
                case 'Yes'
                    load_exp = 1;
                case 'No'
                    load_exp = 0;
            end
        end

        if load_exp
            [data_filename,data_pathname] = uigetfile('*.mat','Select data .mat file...');
            load(fullfile(data_pathname,data_filename),'exp_data')
            handles.data = exp_data;
            experiment_setup = handles.data.experiment_setup;
        end

        guidata(hObject,handles)

        % shift focus
        [acq_gui, acq_gui_data] = get_acq_gui_data;
        figure(acq_gui)

        set(handles.close_socket_check,'Value',0)
        guidata(hObject,handles);
    
    case {'simulation','reproduction'}
        experiment_setup.is_exp = 0;
        experiment_setup.enable_user_breaks = 0;
        handles = [];
end



% get cell locations or simulate
if experiment_setup.is_exp && ~experiment_setup.exp.sim_locs
    
    eventdata = [];
    handles = set_new_ref_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;

    % move obj to ref position (top of slice, centered on map fov)
    handles.data.obj_go_to_pos = handles.data.ref_obj_position;
%     set(handles.thenewx,'String',num2str(handles.data.ref_obj_position(1)))
%     set(handles.thenewy,'String',num2str(handles.data.ref_obj_position(2)))
%     set(handles.thenewz,'String',num2str(handles.data.ref_obj_position(3)))

    [handles,acq_gui,acq_gui_data] = obj_go_to(handles,hObject);

    [handles, experiment_setup] = take_slidebook_stack(hObject,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;

    set_depths = 1;
    choice = questdlg('Set Z-Depths?', ...
        'Set Cell Pos?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            set_depths = 1;
        case 'No'
            set_depths = 0;
    end

    if set_depths
        handles.data.z_offsets = inputdlg('Z Locations?',...
                     'Z Locations?',1,{experiment_setup.exp.z_depths});
        handles.data.z_offsets = strread(handles.data.z_offsets{1})';
        handles.data.obj_positions = [zeros(length(handles.data.z_offsets),1) zeros(length(handles.data.z_offsets),1) handles.data.z_offsets];
        handles.data.obj_positions = bsxfun(@plus,handles.data.obj_positions,handles.data.obj_position);
        acq_gui_data.data.obj_positions = handles.data.obj_positions;
        guidata(hObject,handles);
        guidata(acq_gui,acq_gui_data)
        exp_data = handles.data; save(handles.data.experiment_setup.fullsavefile,'exp_data')
    end

    % Set power, TODO: add user break
    user_input_powers = inputdlg('Enter desired powers (space-delimited):',...
                 'Powers to run?',1,{experiment_setup.exp.power_levels});
    user_input_powers = strread(user_input_powers{1});
    handles.data.experiment_setup.exp.user_power_level = user_input_powers;
    experiment_setup = handles.data.experiment_setup;
    guidata(hObject,handles)

    [handles, experiment_setup] = detect_nucs_analysis_comp(hObject,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;
else

    experiment_setup.neurons=generate_neurons(experiment_setup);
    
end

neighbourhoods = create_neighbourhoods_caller(experiment_setup);
% assignin('base','neighborhoods',neighbourhoods)
% return
if experiment_setup.is_exp
    
    handles.data.neighbourhoods = neighbourhoods;
    acq_gui_data.data.neighbourhoods = handles.data.neighbourhoods;
    guidata(acq_gui,acq_gui_data)
    guidata(hObject,handles)
    exp_data = handles.data; save(handles.data.experiment_setup.fullsavefile,'exp_data')
    [acq_gui, acq_gui_data] = get_acq_gui_data;

end

if experiment_setup.is_exp || experiment_setup.sim.do_instructions
    build_first_batch_stim_all_neighborhoods(experiment_setup,neighbourhoods,handles);
else
    [experiment_query_full, neighbourhoods] = build_first_batch_stim_all_neighborhoods(experiment_setup,neighbourhoods,handles);
end

if experiment_setup.is_exp
    % get info on patched cells while first batches prep
    handles = set_cell1_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;

    handles = set_cell2_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;

    handles = setup_patches(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;
    
    % compute bg rate from data

    set(acq_gui_data.test_pulse,'Value',1)
    set(acq_gui_data.loop,'Value',1)
    set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
    set(acq_gui_data.trigger_seq,'Value',1)
    set(acq_gui_data.loop_count,'String',num2str(1))
else
    % simulate bg rate
    experiment_setup.patched_neuron=struct;
    experiment_setup.patched_neuron.background_rate=1e-4;
    experiment_setup.patched_neuron.cell_type=[];
end
num_neighbourhoods = length(neighbourhoods);

not_terminated = 1;
loop_count = 0;
while not_terminated

    loop_count=loop_count+1;
    
    for i = 1:num_neighbourhoods
        
        neighbourhood = neighbourhoods(i);
        
        if ~experiment_setup.is_exp && ~experiment_setup.sim.do_instructions
            experiment_query = experiment_query_full(i,loop_count);
        else
            % check for batch on this neighborhood
            instruction.type = 401;
            instruction.dir = experiment_setup.analysis_root;        
            instruction.matchstr = [experiment_setup.exp_id ...
                        '_n' num2str(neighbourhood.neighbourhood_ID)...
                        '_b' num2str(neighbourhood.batch_ID + 1) '_to_acquisition'];
            if experiment_setup.is_exp
                [return_info, success, handles] = do_instruction_analysis(instruction, handles);
            else
                [return_info, success] = do_instruction_local(instruction);
            end

            if ~return_info.batch_found
                continue
            else
                neighbourhoods(i) = return_info.neighbourhood;
                neighbourhood = neighbourhoods(i);
                experiment_query = return_info.experiment_query;
            end
        end
        if experiment_setup.is_exp
            
            handles.data.obj_go_to_pos = handles.data.ref_obj_position;
            [handles,acq_gui,acq_gui_data] = obj_go_to(handles,hObject);

            do_run_trials = 1;
            if experiment_setup.enable_user_breaks
                choice = questdlg('Run the trials?', ...
                    'Run the trials?', ...
                    'Yes','No','Yes');
                % Handle response
                switch choice
                    case 'Yes'
                        do_run_trials = 1;
                        choice = questdlg('Continue user control?',...
                            'Continue user control?', ...
                            'Yes','No','Yes');
                        % Handle response
                        switch choice
                            case 'Yes'
                                experiment_setup.enable_user_breaks = 1;
                            case 'No'
                                experiment_setup.enable_user_breaks = 0;
                        end
                    case 'No'
                        do_run_trials = 0;
                end
            end

            if do_run_trials
                
                max_seq_length = str2double(get(handles.max_seq_length,'String'));
                this_seq = acq_gui_data.data.sequence;
                num_runs = ceil(length(this_seq)/max_seq_length);
                handles.data.start_trial = acq_gui_data.data.sweep_counter + 1;

                for run_i = 1:num_runs

                    this_subseq = this_seq((run_i-1)*max_seq_length+1:min(run_i*max_seq_length,length(this_seq)));
                    time_offset = this_subseq(1).start - 1000;
                    for k = 1:length(this_subseq)
                        this_subseq(k).start = this_subseq(k).start - time_offset;
                    end
                    total_duration = (this_subseq(end).start + this_subseq(end).duration)/1000 + 5;

                    set(acq_gui_data.trial_length,'String',num2str(total_duration + 1.0))
                    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
                    instruction = struct();
                    instruction.type = 32; %SEND SEQ
                    handles.sequence = this_subseq;
                    instruction.sequence = this_subseq;
                    handles.total_duration = total_duration;
                    instruction.waittime = total_duration + 120;
                    disp('sending instruction...')
                    [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
            %         acq_gui_data = get_acq_gui_data();
            %         acq_gui_data.data.stim_key =  return_info.stim_key;
                    acq_gui_data.data.sequence =  this_subseq;
            %         acq_gui = findobj('Tag','acq_gui');
                    guidata(acq_gui,acq_gui_data)

                    set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
                    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);

                    guidata(hObject,handles)
                    exp_data = handles.data; save(handles.data.experiment_setup.fullsavefile,'exp_data')
            %         guidata(acq_gui,acq_gui_data)

                    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
                    waitfor(acq_gui_data.run,'String','Start')
                    guidata(acq_gui,acq_gui_data)

                end
            end
        else
            % simulate this batch data
            switch experiment_setup.experiment_type
                case 'simulation'
                    % simulate data 
                    i_neighbourhood=i;
                    experiment_query=generate_psc_data(experiment_query,experiment_setup,neighbourhoods(i_neighbourhood));
                case 'reproduction'
                    % read data from files
            end
        end
        
        
        % RUN ONLINE MAPPING PIPELINE HERE
        if ~experiment_setup.is_exp && ~experiment_setup.sim.do_instructions

            neighbourhood_tmp = struct();
            experiment_query_temp = struct();
            [experiment_query_temp, neighbourhood_tmp] = run_online_pipeline(neighbourhood,...
                experiment_query,experiment_setup);
            neighbourhoods(i) = neighbourhood_tmp;
            experiment_query_full(i,loop_count+1)=experiment_query_temp;

        else
            instruction.type = 300; 
            instruction.experiment_query = experiment_query;
            instruction.neighbourhoods = neighbourhood;
            instruction.get_return = 0;
            instruction.experiment_setup = experiment_setup;
            
            if experiment_setup.is_exp
                [return_info, success, handles] = do_instruction_analysis(instruction, handles);
            else
                [return_info, success] = do_instruction_local(instruction);
            end
        end
        
        
        
        % Plot the progress
%         fprintf('Number of trials so far: %d; number of cells killed: %d\n',handles.data.design.n_trials{i}, sum(handles.data.design.dead_cells{i}{handles.data.design.iter}+handles.data.design.alive_cells{i}{handles.data.design.iter}))
        
%         do_cont = 0;
%         choice = questdlg('Continue Plane?', ...
%         'Continue Plane?', ...
%         'Yes','No','Yes');
%         % Handle response
%         switch choice
%         case 'Yes'
%             do_cont = 1;
%         case 'No'
%             do_cont = 0;
%         end
% 
%         if ~do_cont   
%             handles.data.design.id_continue{i} = 0;
%         end
    end
end    

exp_data = handles.data; save(handles.data.experiment_setup.fullsavefile,'exp_data')

set(handles.close_socket_check,'Value',1);
instruction.type = 00;
instruction.string = 'done';
[return_info,success,handles] = do_instruction_slidebook(instruction,handles);
guidata(hObject,handles)    