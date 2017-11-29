function run_mapping_experiment(experiment_setup,varargin)

disp('Experiment start...')    

switch experiment_setup.experiment_type
    case 'pilot'
        
    case 'experiment'
        
        handles = varargin{1};
        hObject = varargin{2};
        
        handles.data.experiment_setup = experiment_setup;
        handles.data.neighbourhoods = [];
        handles.data.experiment_query = [];
        
        experiment_setup.is_exp = 1;
        set(handles.close_socket_check,'Value',0)
        
        

        experiment_setup.enable_user_breaks = 0;
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
                            enable_user_breaks = 1;
                        case 'No'
                            enable_user_breaks = 0;
                    end
                    guidata(hObject,handles)
                case 'No'
                    reinit_oed = 0;
            end
        end

        if reinit_oed
            experiment_setup = get_experiment_setup('millennium_falcon');
            experiment_setup.enable_user_breaks = enable_user_breaks;
            experiment_setup.is_exp = 1;
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
                    choice = questdlg('Continue user control?',...
                        'Continue user control?', ...
                        'Yes','No','Yes');
                    % Handle response
                    switch choice
                        case 'Yes'
                            enable_user_breaks = 1;
                        case 'No'
                            enable_user_breaks = 0;
                    end
                    guidata(hObject,handles)
                case 'No'
                    load_exp = 0;
            end
        end

        if load_exp
            [data_filename,data_pathname] = uigetfile('*.mat','Select data .mat file...');
            load(fullfile(data_pathname,data_filename),'exp_data')
            handles.data = exp_data;
            experiment_setup = handles.data.experiment_setup;
            if isfield(handles.data,'neighbourhoods')
                neighbourhoods = handles.data.neighbourhoods;
            end
            if isfield(handles.data,'experiment_query')
                experiment_query = handles.data.experiment_query;
            end
            experiment_setup.enable_user_breaks = enable_user_breaks;
            experiment_setup.is_exp = 1;
            experiment_setup.terminator=@check_all_learned;
            
        end

        guidata(hObject,handles)

        % shift focus
        [acq_gui, acq_gui_data] = get_acq_gui_data;
        figure(acq_gui)

        experiment_setup.close_socket = 0;
        guidata(hObject,handles);
    
    case {'simulation','reproduction'}
        
        experiment_setup.is_exp = 0;
        experiment_setup.enable_user_breaks = 0;
        handles = [];
end



% get cell locations or simulate
disp('Get presynaptic neurons...')
if experiment_setup.is_exp
    
    eventdata = [];
    disp('Get objective ref position...')
    [experiment_setup, handles] = set_new_ref_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;
    
    disp('Take stack...')
    [handles, experiment_setup] = take_slidebook_stack(hObject,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;


end

if ~experiment_setup.exp.sim_locs
    
    disp('Detect nuclei...')
    [handles, experiment_setup.neurons] = detect_nucs_analysis_comp(hObject,handles,acq_gui,acq_gui_data,experiment_setup);
    [acq_gui, acq_gui_data] = get_acq_gui_data;
    
    
    
    % COULD POTENTIALLY COLLECT SOME DATA HERE...
    % MAYBE RUN A TRIAL FOR BG RATE!
    
elseif ~isfield(experiment_setup,'neurons')

    % simulate the neurons
    disp('Simulate neurons...')
    experiment_setup.neurons=generate_neurons(experiment_setup);
    
end

if ~exist('neighbourhoods','var')
    disp('Create neighbourhoods...')
    neighbourhoods = create_neighbourhoods_caller(experiment_setup);
end

if experiment_setup.is_exp
    disp('Save...')
    handles.data.experiment_setup = experiment_setup;
    handles.data.neighbourhoods = neighbourhoods;
    guidata(acq_gui,acq_gui_data)
    guidata(hObject,handles)
    exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
    [acq_gui, acq_gui_data] = get_acq_gui_data;

end

init_first_batches = 1;
if experiment_setup.enable_user_breaks
    choice = questdlg('Initialize first batches for each neighbourhood?',...
        'Initialize first batches for each neighbourhood?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            init_first_batches = 1;
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
            init_first_batches = 0;
    end
end

if init_first_batches       
    if experiment_setup.is_exp || experiment_setup.sim.do_instructions
        build_first_batch_stim_all_neighborhoods(experiment_setup,neighbourhoods,handles,hObject);
        handles = guidata(hObject)
    else
        [experiment_query_full, neighbourhoods] = build_first_batch_stim_all_neighborhoods(experiment_setup,neighbourhoods,handles,hObject);
    end
end

if experiment_setup.is_exp
    do_ephys = 1;
    if experiment_setup.enable_user_breaks
        choice = questdlg('Initialize first batches for each neighbourhood?',...
            'Initialize first batches for each neighbourhood?', ...
            'Yes','No','Yes');
        % Handle response
        switch choice
            case 'Yes'
                do_ephys = 1;
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
                do_ephys = 0;
        end
    end



    if do_ephys
        % get info on patched cells while first batches prep
    %     handles = set_cell1_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
    %     [acq_gui, acq_gui_data] = get_acq_gui_data;
    % 
    %     handles = set_cell2_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
    %     [acq_gui, acq_gui_data] = get_acq_gui_data;

        handles = setup_patches(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
        [acq_gui, acq_gui_data] = get_acq_gui_data;

        % compute bg rate from data

        set(acq_gui_data.test_pulse,'Value',1)
        set(acq_gui_data.loop,'Value',1)
        set(acq_gui_data.trigger_seq,'Value',1)
        set(acq_gui_data.loop_count,'String',num2str(1))
        
    end
    experiment_setup.patched_neuron=struct;
    experiment_setup.patched_neuron.background_rate=1e-4;
    experiment_setup.patched_neuron.cell_type=[];
           
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
    loop_count=loop_count+1
    
    % CHOOSE TO ENTER START N AND B HERE
    for i = 1:num_neighbourhoods
        
        neighbourhood = neighbourhoods(i);
        
        if ~experiment_setup.is_exp && ~experiment_setup.sim.do_instructions
            experiment_query = experiment_query_full(i,loop_count);
        else
            % check for batch on this neighborhood
            send_phase_masks = 1;
            if experiment_setup.enable_user_breaks
                choice = questdlg('Send phase masks?', ...
                    'Send phase masks?', ...
                    'Yes','No','Yes');
                % Handle response
                switch choice
                    case 'Yes'
                        send_phase_masks = 1;
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
                        send_phase_masks = 0;
                end
            end
            if send_phase_masks
                instruction.type = 401;
                instruction.dir = experiment_setup.analysis_root;   
                instruction.get_return = 1;
                instruction.matchstr = [experiment_setup.exp_id ...
                            '_n' num2str(neighbourhood.neighbourhood_ID)...
                            '_b' num2str(neighbourhood.batch_ID + 1) '_to_acquisition'];
                if experiment_setup.is_exp
                    [return_info, success, handles] = do_instruction_analysis(instruction, handles);
    %                 batch_found = return_info.batch_found;
                else
                    [return_info, success] = do_instruction_local(instruction);
                end
                if ~isfield(return_info,'batch_found')
                    disp('no field...')
                    continue
                end
                switch return_info.batch_found %~isfield(return_info,'batch_found') || ~
                    case 'no'
                        continue
                    case 'yes'

                    experiment_setup_bu = experiment_setup;
                    neighbourhoods_bu = neighbourhoods;
    %                 experiment_query_bu = experiment_query;
                    try
                        disp('loading phase masks')
                        load(['X:\shababo\' instruction.matchstr '.mat'])

                        neighbourhoods(i) = neighbourhood;
                        neighbourhood = neighbourhoods(i);
        %                 experiment_query = experiment_query;


                        handles.data.experiment_setup = experiment_setup;
                        handles.data.experiment_query = experiment_query;
                        handles.data.neighbourhoods = neighbourhoods;
                        exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
                    catch e
                         experiment_setup= experiment_setup_bu;
                         neighbourhoods = neighbourhoods_bu;
    %                      experiment_query = experiment_query_bu;
                        continue
                    end
                end
                disp('sending phase masks')
                instruction = struct();
                instruction.type = 84;
                instruction.precomputed_target = experiment_query.phase_masks;
                [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
                guidata(hObject,handles)
                experiment_query = rmfield(experiment_query,'phase_masks');
                handles.data.experiment_setup = experiment_setup;
                handles.data.experiment_query = experiment_query;
                handles.data.neighbourhoods = neighbourhoods;
                exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
            end
        end
        
        if experiment_setup.is_exp
            
%             handles.data.obj_go_to_pos = handles.data.ref_obj_position + neighbourhoods(i).center;
%             [handles,acq_gui,acq_gui_data] = obj_go_to(handles,hObject);

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
                
                disp('running trials')
                max_seq_length = experiment_setup.exp.max_trials_per_sweep;
                [experiment_query, this_seq] = make_slidebook_sequence(experiment_query,experiment_setup);
                num_runs = ceil(length(this_seq)/max_seq_length);
                
                handles.data.start_trial = acq_gui_data.data.sweep_counter + 1;
                
                
                seqs = cell(num_runs,1);
                for run_i = 1:num_runs

                    this_subseq = this_seq((run_i-1)*max_seq_length+1:min(run_i*max_seq_length,length(this_seq)));
                    time_offset = this_subseq(1).start - 1000;
                    for k = 1:length(this_subseq)
                        this_subseq(k).start = this_subseq(k).start - time_offset;
                    end
                    total_duration = (this_subseq(end).start + this_subseq(end).duration)/1000 + experiment_setup.exp.sweep_time_padding;

                    set(acq_gui_data.trial_length,'String',num2str(total_duration))
                    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
                    
                    instruction = struct();
                    instruction.type = 32; %SEND SEQ
                    handles.sequence = this_subseq;
                    seqs{run_i} = this_subseq;
%                     guidata(acq_gui,acq_gui_data);
                    instruction.sequence = this_subseq;
                    handles.total_duration = total_duration;
                    instruction.waittime = total_duration + 120;
                    disp('sending instruction...')
                    [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
                    acq_gui_data.data.sequence =  this_subseq;
                    guidata(acq_gui,acq_gui_data)

                    set(acq_gui_data.trial_length,'String',num2str(handles.total_duration + 1.0))
                   
                    acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);

                    guidata(hObject,handles)
%                     exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
            %         guidata(acq_gui,acq_gui_data)

                    acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
                    waitfor(acq_gui_data.run,'String','Start')
                    guidata(acq_gui,acq_gui_data)

                end
                acq_gui_data = guidata(acq_gui);
                trials = handles.data.start_trial:acq_gui_data.data.sweep_counter;
                traces = ...
                    get_traces(acq_gui_data.data,trials,seqs,experiment_setup.trials.max_time_sec,20000);
                experiment_query = add_voltage_clamp_data(experiment_query,traces,experiment_setup);

            end
        end
%         if experiment_setup.exp.sim_response || strcmp(experiment_setup.experiment_type,'simulation')
%             % simulate this batch data
% %             switch experiment_setup.experiment_type
% %                 case 'experiment'
% %                     i_neighbourhood=i;
% %                     experiment_query=generate_psc_data(experiment_query,experiment_setup,neighbourhoods(i_neighbourhood));
% %                 case 'simulation'
%                     % simulate data 
%                     i_neighbourhood=i;
%                     experiment_query=generate_psc_data(experiment_query,experiment_setup,neighbourhoods(i_neighbourhood));
% %                 case 'reproduction'
%                     % read data from files
% %             end
%         end
        
        
        % RUN ONLINE MAPPING PIPELINE HERE
        if ~experiment_setup.is_exp && ~experiment_setup.sim.do_instructions

            neighbourhood_tmp = struct();
            experiment_query_tmp = struct();
            [experiment_query_tmp, neighbourhood_tmp] = run_online_pipeline(neighbourhood,...
                experiment_query,experiment_setup);
            neighbourhoods(i) = neighbourhood_tmp;
            experiment_query_full(i,loop_count+1)=experiment_query_tmp;

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
        
        % check if all cells in this neighbourhood are alive or
        % disconnected 
        
        
        
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
        handles.data.experiment_setup = experiment_setup;
        handles.data.experiment_query = experiment_query;
        handles.data.neighbourhoods = neighbourhoods;
        exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')
        
    end
    
    not_terminated = experiment_setup.terminator(neighbourhoods);
  
end    



set(handles.close_socket_check,'Value',1);
instruction.type = 00;
instruction.string = 'done';
[return_info,success,handles] = do_instruction_slidebook(instruction,handles);
guidata(hObject,handles)    