function run_mapping_experiment(experiment_setup,varargin)

disp('Experiment start...')    

switch experiment_setup.experiment_type
    case 'pilot'
        
    case 'experiment'
        
        handles = varargin{1};
        hObject = varargin{2};
        
        if length(varargin) > 2 && ~isempty(varargin{3})
            fast_start = varargin{3};
        else
            fast_start = 0;
        end
        
        handles.data.experiment_setup = experiment_setup;
        handles.data.neighbourhoods = [];
        handles.data.experiment_query = [];
        
        experiment_setup.is_exp = 1;
        set(handles.close_socket_check,'Value',0)
        
        

        experiment_setup.enable_user_breaks = 0;
        if ~fast_start
            choice = questdlg('Choose start point?',...
                'Choose start point?', ...
                'Yes','No','Yes');
            % Handle response
            switch choice
                case 'Yes'

                    experiment_setup = handles.data.experiment_setup;
                    if isfield(handles.data,'neighbourhoods')
                        neighbourhoods = handles.data.neighbourhoods;
                    end
                    if isfield(handles.data,'experiment_query')
                        experiment_query = handles.data.experiment_query;
                    end
                    experiment_setup.is_exp = 1;
                    experiment_setup.terminator=@check_all_learned;
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

        end
        
        
        % shift focus
        [acq_gui, acq_gui_data] = get_acq_gui_data;
        figure(acq_gui)

        experiment_setup.close_socket = 0;
        guidata(hObject,handles);
    
    case {'simulation','reproduction'}
        
        experiment_setup.is_exp = 0;
        experiment_setup.enable_user_breaks = 0;
        handles = [];
        hObject = [];
        
end


get_neurons = 1;
if experiment_setup.enable_user_breaks
    choice = questdlg('Get presynaptic neurons?',...
        'Get presynaptic neurons?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            get_neurons = 1;
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
            get_neurons = 0;
    end
end
% get cell locations or simulate
disp('Get presynaptic neurons...')

if get_neurons
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

    else

        % simulate the neurons
        disp('Simulate neurons...')
        experiment_setup.neurons=generate_neurons(experiment_setup);

    end
end


if ~exist('neighbourhoods','var')
    disp('Create neighbourhoods...')
    neighbourhoods = create_neighbourhoods_caller(experiment_setup);
    handles.fighandle = figure;
    for i = 1:length(neighbourhoods)
        plot_one_neighbourhood(neighbourhoods(i),handles.fighandle)
    end
end

experiment_setup = rmfield(experiment_setup,'stack');

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
        handles = guidata(hObject);
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


not_terminated = 1;
loop_count = 0;
batch_found = 0;


while not_terminated
    
    loop_count = loop_count + 1;
	
    % FIND BATCH AND LOAD PHASE MASKS IF NEEDED
    if ~experiment_setup.is_exp && ~experiment_setup.sim.do_instructions   
        
        neighbourhood = neighbourhoods(mod(loop_count,length(neighbourhoods))+1);
        experiment_query = experiment_query_full(neighbourhood.neighbourhood_ID,neighbourhood.batch_ID-1);   
        
    else
        drawnow
        disp('getting batch...')
        while ~batch_found
            
            [batch_found, experiment_query_next, neighbourhood_next] = ...
                prep_next_run(experiment_setup,neighbourhoods,handles);
        end
        batch_found = 0;
        
        neighbourhood = neighbourhood_next;
        neighbourhoods(neighbourhood.neighbourhood_ID) = neighbourhood;
        experiment_query = experiment_query_next;
    end  
    
    % Update neuron info in experiment_setup from neighbourhood 
    for i_cell = 1:length(neighbourhood.neurons)
        if ~strcmp(neighbourhood.neurons(i_cell).group_ID{end},'secondary')
            experiment_setup.neurons(neighbourhood.neurons(i_cell).cell_ID).PR_params=...
                neighbourhood.neurons(i_cell).PR_params;
            experiment_setup.neurons(neighbourhood.neurons(i_cell).cell_ID).gain_params=...
                neighbourhood.neurons(i_cell).gain_params;
        end
    end
    
    % Update secondary neurons in all neighbourhoods 
    i_cell_group_to_nhood= find(get_group_inds(neighbourhood,'secondary'));

    for i_cell = i_cell_group_to_nhood
        temp_ID=neighbourhood.neurons(i_cell).cell_ID;
        if isfield(experiment_setup.neurons(temp_ID),'PR_params')
            if ~isempty(experiment_setup.neurons(temp_ID).PR_params)
         neighbourhood.neurons(i_cell).PR_params(end)=...
             experiment_setup.neurons(temp_ID).PR_params(end);
            end
        end
        if  isfield(experiment_setup.neurons(temp_ID),'gain_params')
               if ~isempty(experiment_setup.neurons(temp_ID).gain_params)
         neighbourhood.neurons(i_cell).gain_params(end)=...
             experiment_setup.neurons(temp_ID).gain_params(end);
               end
        end
    end
    
    %Update plots
    plot_one_neighbourhood(neighbourhood,handles.fighandle)
%     drawnow
    
    % ACQ OR SIM DATA
    if experiment_setup.is_exp

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
                instruction.sequence = rmfield(instruction.sequence,{'group_ID','group_trial_ID'})
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

                Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
                drawnow
                disp('looking for batch in bg')
                count = 1;
                pause(1.0)
                while ~batch_found && acq_gui_data.s.IsRunning
                    drawnow
%                     otherhoods = setdiff(1:length(neighbourhoods),find([neighbourhoods.neighbourhood_ID] == neighbourhood.neighbourhood_ID));
                    [batch_found, experiment_query_next, neighbourhood_next] = ...
                        prep_next_run(experiment_setup,neighbourhoods,handles);
                    count = count + 1;
                    if ~mod(count,500)
                        disp('still checking in bg')
                    end
                end
                
                while acq_gui_data.s.IsRunning
                    count = count + 1;
                    if ~mod(count,500)
                        drawnow
                    end
                end
                drawnow
%                 acq_gui_data = guidata(acq_gui);
%                 guidata(acq_gui,acq_gui_data)
            end

            acq_gui_data = guidata(acq_gui);
            trials = handles.data.start_trial:acq_gui_data.data.sweep_counter;
            traces = ...
                get_traces(acq_gui_data.data,trials,experiment_setup.trials.Fs,experiment_setup.trials.max_time_sec);
            experiment_query = add_voltage_clamp_data(experiment_query,traces,experiment_setup);

        end

    end
    
        % simulate this batch data
    switch experiment_setup.experiment_type
%         case 'experiment'
%             if experiment_setup.exp.sim_response
%                 experiment_query=generate_psc_data(experiment_query,experiment_setup,neighbourhood);
%             end
        case 'simulation'
            experiment_query=generate_psc_data(experiment_query,experiment_setup,neighbourhood);
        case 'reproduction'

    end
    


    % RUN ONLINE MAPPING PIPELINE
    if ~experiment_setup.is_exp && ~experiment_setup.sim.do_instructions

        neighbourhood_tmp = struct();
        experiment_query_tmp = struct();
        [experiment_query_tmp, neighbourhood_tmp] = run_online_pipeline(neighbourhood,...
            experiment_query,experiment_setup);
        neighbourhoods(neighbourhood.neighbourhood_ID) = neighbourhood_tmp;
        experiment_query_full(neighbourhood.neighbourhood_ID,neighbourhood.batch_ID)=experiment_query_tmp;
     
         % Visualization 
        if strcmp(experiment_setup.experiment_type,'simulation') && experiment_setup.sim.visualize 
            digits_batch=max(ceil(log10(neighbourhood.batch_ID)), floor(log10(neighbourhood.batch_ID))+1);
            figure_index=neighbourhood.neighbourhood_ID*10^(digits_batch+1)+neighbourhood.batch_ID;

            save_path=experiment_setup.exp_root;
            experiment_setup.sim.plotting_funcs(neighbourhood, save_path,figure_index);
        end 
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
    
    
    % SAVE!
    handles.data.experiment_setup = experiment_setup;
    handles.data.experiment_query = experiment_query;
    handles.data.neighbourhoods = neighbourhoods;
    exp_data = handles.data; save(experiment_setup.exp.fullsavefile,'exp_data')

     
    
    
    % CHECK IF WE ARE DONE
    not_terminated = experiment_setup.terminator(neighbourhoods);
  
end    


set(handles.close_socket_check,'Value',1);
instruction.type = 00;
instruction.string = 'done';
[return_info,success,handles] = do_instruction_slidebook(instruction,handles);
guidata(hObject,handles)    