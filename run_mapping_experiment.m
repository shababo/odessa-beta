function run_mapping_experiment(experiment_setup,varargin)

if strcmp(experiment_setup.experiment_type,'experiment')
    
    is_exp = 1;
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
        choice = questdlg('Initialize OED params?',...
            'Initialize OED params?', ...
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
            'Initialize OED params?', ...
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
        params = handles.data.params;
    else
        params = handles.data.params;
    end

    guidata(hObject,handles)

    % shift focus
    [acq_gui, acq_gui_data] = get_acq_gui_data;
    figure(acq_gui)

    set(handles.close_socket_check,'Value',0)
    guidata(hObject,handles);
    
else
    is_exp = 0;
    experiment_setup.enable_user_breaks = 0;
end



% params = handles.data.params;
eventdata = [];
handles = set_new_ref_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,params);
[acq_gui, acq_gui_data] = get_acq_gui_data;

% move obj to ref position (top of slice, centered on map fov)
set(handles.thenewx,'String',num2str(handles.data.ref_obj_position(1)))
set(handles.thenewy,'String',num2str(handles.data.ref_obj_position(2)))
set(handles.thenewz,'String',num2str(handles.data.ref_obj_position(3)))

[handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);

handles = take_slidebook_stack(hObject,handles,acq_gui,acq_gui_data,params);
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
                 'Z Locations?',1,{params.exp.z_depths});
    handles.data.z_offsets = strread(handles.data.z_offsets{1})';
    handles.data.obj_positions = [zeros(length(handles.data.z_offsets),1) zeros(length(handles.data.z_offsets),1) handles.data.z_offsets];
    handles.data.obj_positions = bsxfun(@plus,handles.data.obj_positions,handles.data.obj_position);
    acq_gui_data.data.obj_positions = handles.data.obj_positions;
    guidata(hObject,handles);
    guidata(acq_gui,acq_gui_data)
    exp_data = handles.data; save(handles.data.params.fullsavefile,'exp_data')
end

% Set power, TODO: add user break
user_input_powers = inputdlg('Enter desired powers (space-delimited):',...
             'Powers to run?',1,{params.exp.power_levels});
user_input_powers = strread(user_input_powers{1});
handles.data.params.exp.user_power_level = user_input_powers;
params = handles.data.params;
guidata(hObject,handles)

handles = detect_nucs_analysis_comp(hObject,handles,acq_gui,acq_gui_data,params);
[acq_gui, acq_gui_data] = get_acq_gui_data;

handles = create_neighbourhoods_caller(hObject,handles,acq_gui,acq_gui_data,params);
[acq_gui, acq_gui_data] = get_acq_gui_data;

handles = build_first_batch_stim_all_neighborhoods(hObject,handles,acq_gui,acq_gui_data,params);


% get info on patched cells while first batches prep
handles = set_cell1_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,params);
[acq_gui, acq_gui_data] = get_acq_gui_data;

handles = set_cell2_pos(hObject,eventdata,handles,acq_gui,acq_gui_data,params);
[acq_gui, acq_gui_data] = get_acq_gui_data;

handles = setup_patches(hObject,eventdata,handles,acq_gui,acq_gui_data,params);
[acq_gui, acq_gui_data] = get_acq_gui_data;


set(handles.rand_order,'Value',1);
% set(handles.num_repeats,'String',num2str(10));
set(handles.duration,'String',num2str(.003));
% set(handles.iti,'String',num2str(0.075));

set(acq_gui_data.test_pulse,'Value',1)
set(acq_gui_data.loop,'Value',1)
set(acq_gui_data.tf_on,'Value',get(handles.tf_flag,'Value'));
set(acq_gui_data.trigger_seq,'Value',1)
set(acq_gui_data.loop_count,'String',num2str(1))
num_map_locations = size(handles.data.obj_positions,1);

set_obj_pos = 0;
choice = questdlg('Start at another z-depth?', ...
	'Start at another z-depth??', ...
	'Yes','No','Yes');
% Handle response
switch choice
    case 'Yes'
        set_obj_pos = 1;
    case 'No'
        set_obj_pos = 0;
end

if set_obj_pos
    prompt = {'Enter obj position index:'};
    dlg_title = 'Obj Position';
    num_lines = 1;
    defaultans = {'2'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    start_obj_ind = str2double(answer{1});
else
    start_obj_ind = 1;
end

% else set i, other stuff?

for i = start_obj_ind:num_map_locations
    
    % move obj
    set(handles.thenewx,'String',num2str(handles.data.obj_positions(i,1)))
    set(handles.thenewy,'String',num2str(handles.data.obj_positions(i,2)))
    set(handles.thenewz,'String',num2str(handles.data.obj_positions(i,3)))
    [handles,acq_gui,acq_gui_data] = obj_go_to_Callback(handles.obj_go_to,eventdata,handles);
    
    
    % SETUP FOR ONLINE DESIGN!!!
    
    % get info for this group of cells
    cell_group_list = handles.data.cells_targets.cell_group_list{i};
    n_cell_this_plane = length(cell_group_list);
    
    pi_target_selected = handles.data.cells_targets.pi_target_selected{i};
    inner_normalized_products = handles.data.cells_targets.inner_normalized_products{i};
    target_locations_selected = handles.data.cells_targets.target_locations_selected{i};
    target_locations_nuclei = handles.data.cells_targets.target_locations_nuclei{i};
    pi_target_nuclei = handles.data.cells_targets.pi_target_nuclei{i};
    loc_to_cell_nuclei = handles.data.cells_targets.loc_to_cell_nuclei{i};
    loc_to_cell = handles.data.cells_targets.loc_to_cell{i};
    % Initialize this iteration
    
    init_obj_pos = 1;
    if experiment_setup.enable_user_breaks
        choice = questdlg('Init design for this location?', ...
            'Init design for this location?', ...
            'Yes','No','Yes');
        % Handle response
        switch choice
            case 'Yes'
                init_obj_pos = 1;
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
                init_obj_pos = 0;
        end
    end
    
    if init_obj_pos
        handles.data.design.iter=1;

        % Initialize the five cell groups
        handles.data.design.undefined_cells{i}{1}=ones(n_cell_this_plane,1);%A
        handles.data.design.potentially_disconnected_cells{i}{1}=zeros(n_cell_this_plane,1);%B
        handles.data.design.dead_cells{i}{1}=zeros(n_cell_this_plane,1);%D
        handles.data.design.potentially_connected_cells{i}{1}=zeros(n_cell_this_plane,1);%C
        handles.data.design.alive_cells{i}{1}=zeros(n_cell_this_plane,1);

        handles.data.design.mpp_undefined{i}=cell(0);
        handles.data.design.trials_locations_undefined{i}=cell(0);
        handles.data.design.trials_powers_undefined{i}=cell(0);
        handles.data.design.trials_pockels_ratios_undefined{i}=cell(0);
        handles.data.design.trials_locations_undefined_key{i}=cell(0);
        handles.data.design.trials_pockels_ratios_multi_undefined{i}=cell(0);

        handles.data.design.mpp_disconnected{i}=cell(0);
        handles.data.design.trials_locations_disconnected{i}=cell(0);
        handles.data.design.trials_powers_disconnected{i}=cell(0);

        handles.data.design.mpp_connected{i}=cell(0);
        handles.data.design.trials_locations_connected{i}=cell(0);
        handles.data.design.trials_powers_connected{i}=cell(0);

        designs_undefined=[];designs_connected=[];designs_disconnected=[];
        outputs_undefined=[];outputs_connected=[];outputs_disconnected=[];

        handles.data.design.variational_params_path{i}.pi=handles.data.params.design.var_pi_ini*ones(n_cell_this_plane,1);
        handles.data.design.variational_params_path{i}.alpha=handles.data.params.design.var_alpha_initial*ones(n_cell_this_plane,1);
        handles.data.design.variational_params_path{i}.beta=handles.data.params.design.var_beta_initial*ones(n_cell_this_plane,1);
        handles.data.design.variational_params_path{i}.alpha_gain=handles.data.params.design.var_alpha_gain_initial*ones(n_cell_this_plane,1);
        handles.data.design.variational_params_path{i}.beta_gain=handles.data.params.design.var_beta_gain_initial*ones(n_cell_this_plane,1);

        handles.data.design.mean_gamma_current{i}=zeros(n_cell_this_plane,1);
%         handles.data.design.mean_gain_current{i}=handles.data.params.template_cell.gain_template*ones(n_cell_this_plane,1);
        handles.data.design.gamma_path{i}=zeros(n_cell_this_plane,1);
        handles.data.design.var_gamma_path{i}=zeros(n_cell_this_plane,1);
        handles.data.design.gain_path{i}=zeros(n_cell_this_plane,1);
        handles.data.design.var_gain_path{i}=zeros(n_cell_this_plane,1);
        
        handles.data.design.n_trials{i}=0;
        handles.data.design.id_continue{i}=1;% an indicator

        % get this z-depth spots
        handles.data.design.loc_to_cell{i} = 1:size(target_locations_selected,1);
        
        guidata(hObject,handles)
        exp_data = handles.data; save(handles.data.params.fullsavefile,'exp_data')
        
    end
        
    
    % Online design:
    while handles.data.design.n_trials{i} < params.design.trial_max && handles.data.design.id_continue{i} > 0
        % while not exceeding the set threshold of total trials
        % and there are new cells being excluded

        handles.data.design.iter

        % Conduct random trials

        % INIT ITERATION ON THIS SLICE
        choose_stim = 1;
        if experiment_setup.enable_user_breaks
            choice = questdlg('Choose stim locations for this iteration?', ...
                'Choose stim locations for this iteration?', ...
                'Yes','No','Yes');
            % Handle response
            switch choice
                case 'Yes'
                    choose_stim = 1;
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
                    choose_stim = 0;
            end
        end
        
        if choose_stim
            
            variational_params=struct([]);
            variational_params(1).alpha = handles.data.design.variational_params_path{i}.alpha(:,handles.data.design.iter);
            variational_params(1).beta = handles.data.design.variational_params_path{i}.beta(:,handles.data.design.iter);
            variational_params(1).alpha_gain = handles.data.design.variational_params_path{i}.alpha_gain(:,handles.data.design.iter);
            variational_params(1).beta_gain = handles.data.design.variational_params_path{i}.beta_gain(:,handles.data.design.iter);
            gamma_current=handles.data.design.gamma_path{i}(:,handles.data.design.iter);

            % On the undefined cells
            handles.data.design.trials_locations_undefined{i}{handles.data.design.iter}=[];
            handles.data.design.trials_powers_undefined{i}{handles.data.design.iter}=[];
            handles.data.design.trials_pockels_ratios_undefined{i}{handles.data.design.iter}=[];
            handles.data.design.trials_locations_undefined_key{i}{handles.data.design.iter} = [];
            handles.data.design.trials_pockels_ratios_multi_undefined{i}{handles.data.design.iter} = [];


            % BUILD THIS ITER'S ALL GROUPS STIMULI

            if sum(handles.data.design.undefined_cells{i}{handles.data.design.iter})>0
                disp('designing undefined stim')
                cell_list= find(handles.data.design.undefined_cells{i}{handles.data.design.iter});
%                 gamma_estimates = 0.5*ones(length(cell_list),1);% for drawing samples...
                if length(cell_list) > params.design.single_spot_threshold
                    
                    [trials_locations, trials_powers,target_locations_key, pockels_ratio_refs, pockels_ratios] = random_design(...
                        target_locations_selected,params.exp.user_power_level,...
                        pi_target_selected, inner_normalized_products,params.design.single_spot_threshold,...
                        variational_params,params.design.n_MC_samples,params.design.gain_bound,params.template_cell.prob_trace_full,...
                        gamma_current,  params.fire_stim_threshold,params.stim_scale,...
                        loc_to_cell,...
                        cell_list,params.design.n_spots_per_trial,params.design.K_undefined,params.design.n_replicates,...
                        1,handles.data.params.exp.ratio_map,params.exp.max_power_ref,0);
                    [~, stim_size] = get_prob_and_size(...
                        pi_target_selected,trials_locations,trials_powers,params.stim_unique,params.template_cell.prob_trace);
                else
                    [trials_locations,  trials_powers,target_locations_key, pockels_ratio_refs, pockels_ratios] = random_design(...
                        target_locations_nuclei,params.exp.user_power_level,...
                        pi_target_nuclei, inner_normalized_products,params.design.single_spot_threshold,...
                        variational_params,params.design.n_MC_samples,params.design.gain_bound,...
                        params.template_cell.prob_trace_full,gamma_current,  params.fire_stim_threshold,params.stim_scale,...
                        loc_to_cell_nuclei,...
                        cell_list,params.design.n_spots_per_trial,params.design.K_undefined,params.design.n_replicates,...
                        1,handles.data.params.exp.ratio_map,params.exp.max_power_ref,0);

                    [~, stim_size] = get_prob_and_size(...
                        pi_target_nuclei,trials_locations,trials_powers,params.stim_unique,params.template_cell.prob_trace);

                end

                handles.data.design.trials_locations_undefined{i}{handles.data.design.iter}=trials_locations;
                handles.data.design.trials_powers_undefined{i}{handles.data.design.iter}=trials_powers;
                handles.data.design.trials_pockels_ratios_undefined{i}{handles.data.design.iter} = pockels_ratio_refs;
                handles.data.design.trials_locations_undefined_key{i}{handles.data.design.iter} = target_locations_key;
                handles.data.design.trials_pockels_ratios_multi_undefined{i}{handles.data.design.iter} = pockels_ratios;
                handles.data.design.stim_size_undefined{i}{handles.data.design.iter} = stim_size;
            end

            %-------
            % Conduct trials on group B, the potentially disconnected cells
            handles.data.design.trials_locations_disconnected{i}{handles.data.design.iter}=[];
            handles.data.design.trials_powers_disconnected{i}{handles.data.design.iter}=[];
            handles.data.design.trials_pockels_ratios_disconnected{i}{handles.data.design.iter}=[];
            handles.data.design.trials_locations_disconnected_key{i}{handles.data.design.iter} = [];
            handles.data.design.trials_pockels_ratios_multi_disconnected{i}{handles.data.design.iter} = [];
            if sum(handles.data.design.potentially_disconnected_cells{i}{handles.data.design.iter})>0
                disp('designing disconnected stim')
                % Find cells with close to zero gammas
                cell_list= find(handles.data.design.potentially_disconnected_cells{i}{handles.data.design.iter});
%                 gamma_estimates = 0.5*ones(length(cell_list),1);% for drawing samples...
                if length(cell_list) > params.design.single_spot_threshold
                    
                    [trials_locations, trials_powers,target_locations_key, pockels_ratio_refs, pockels_ratios] = random_design(...
                        target_locations_selected,params.exp.user_power_level,...
                        pi_target_selected, inner_normalized_products,params.design.single_spot_threshold,...
                        variational_params,params.design.n_MC_samples,params.design.gain_bound,params.template_cell.prob_trace_full,...
                        gamma_current,  params.fire_stim_threshold,params.stim_scale,...
                        loc_to_cell,...
                        cell_list,params.design.n_spots_per_trial,params.design.K_disconnected,params.design.n_replicates,...
                        1,handles.data.params.exp.ratio_map,params.exp.max_power_ref,0);
                    [~, stim_size] = get_prob_and_size(...
                        pi_target_selected,trials_locations,trials_powers,params.stim_unique,params.template_cell.prob_trace);
                else
                    [trials_locations,  trials_powers,target_locations_key, pockels_ratio_refs, pockels_ratios] = random_design(...
                        target_locations_nuclei,params.exp.user_power_level,...
                        pi_target_nuclei, inner_normalized_products,params.design.single_spot_threshold,...
                        variational_params,params.design.n_MC_samples,params.design.gain_bound,...
                        params.template_cell.prob_trace_full,gamma_current,  params.fire_stim_threshold,params.stim_scale,...
                        loc_to_cell_nuclei,...
                        cell_list,params.design.n_spots_per_trial,params.design.K_disconnected,params.design.n_replicates,...
                        1,handles.data.params.exp.ratio_map,params.exp.max_power_ref,0);

                    [~, stim_size] = get_prob_and_size(...
                        pi_target_nuclei,trials_locations,trials_powers,params.stim_unique,params.template_cell.prob_trace);

                end

                handles.data.design.trials_locations_disconnected{i}{handles.data.design.iter}=trials_locations;
                handles.data.design.trials_powers_disconnected{i}{handles.data.design.iter}=trials_powers;
                handles.data.design.trials_pockels_ratios_disconnected{i}{handles.data.design.iter} = pockels_ratio_refs;
                handles.data.design.trials_locations_disconnected_key{i}{handles.data.design.iter} = target_locations_key;
                handles.data.design.trials_pockels_ratios_multi_disconnected{i}{handles.data.design.iter} = pockels_ratios;
                handles.data.design.stim_size_disconnected{i}{handles.data.design.iter} = stim_size;
            end

            %-------
            % Conduct trials on group C, the potentially connected cells
            handles.data.design.trials_locations_connected{i}{handles.data.design.iter}=[];
            handles.data.design.trials_locations_connected_key{i}{handles.data.design.iter} = [];
            handles.data.design.trials_powers_connected{i}{handles.data.design.iter}=[];
            handles.data.design.trials_pockels_ratios_connected{i}{handles.data.design.iter}=[];
            if sum(handles.data.design.potentially_connected_cells{i}{handles.data.design.iter})>0
                disp('designing connected stim')
                % Find cells with close to zero gammas
                cell_list= find(handles.data.design.potentially_connected_cells{i}{handles.data.design.iter});
%                 gamma_estimates_confirm = 0.5*ones(length(cell_list),1);% for drawing samples...
                [trials_locations,  trials_powers,target_locations_key, pockels_ratio_refs] = random_design(...
                    target_locations_nuclei,params.exp.user_power_level,...
                    pi_target_nuclei, inner_normalized_products,Inf,...
                    variational_params,params.design.n_MC_samples,params.design.gain_bound,...
                    params.template_cell.prob_trace_full,gamma_current,  params.fire_stim_threshold,params.stim_scale,...
                    loc_to_cell_nuclei,...
                    cell_list,params.design.n_spots_per_trial,params.design.K_connected,params.design.n_replicates,...
                    1,handles.data.params.exp.ratio_map,params.exp.max_power_ref,0);
                %[cells_probabilities_connected, ~] = get_prob_and_size(...
                %    pi_target_nuclei,trials_locations,trials_powers,...
                %    stim_unique,prob_trace);
                [~, stim_size] = get_prob_and_size(...
                    pi_target_nuclei,trials_locations,trials_powers,...
                    params.stim_unique,params.template_cell.prob_trace);

                handles.data.design.trials_locations_connected{i}{handles.data.design.iter}=trials_locations;
                handles.data.design.trials_powers_connected{i}{handles.data.design.iter}=trials_powers;
                handles.data.design.trials_pockels_ratios_connected{i}{handles.data.design.iter} = pockels_ratio_refs;
                handles.data.design.trials_locations_connected_key{i}{handles.data.design.iter} = target_locations_key;
                handles.data.design.stim_size_connected{i}{handles.data.design.iter} = stim_size;
            end
            
            guidata(hObject,handles)
            exp_data = handles.data; save(handles.data.params.fullsavefile,'exp_data')
        end
        
        %------------------------------------------%
        % Run the designed trials
        
        do_create_stim_phases = 1;
        if experiment_setup.enable_user_breaks
            choice = questdlg('Design targets and compute holo?', ...
                'Design targets and compute holo?', ...
                'Yes','No','Yes');
            % Handle response
            switch choice
                case 'Yes'
                    do_create_stim_phases = 1;
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
                    do_create_stim_phases = 0;
            end
        end
        
        if do_create_stim_phases
            
            multi_spot_targs = [];
            multi_spot_pockels = [];
            pockels_ratios = [];
            single_spot_targs = [];
            single_spot_pockels_refs = [];
            handles.data.group_powers = cell(0);
            
            num_stim = 0;

            handles.data.sequence_groups = zeros(3,2);
            % add undefined targets
            handles.data.sequence_groups(1,:) = [1 length(handles.data.design.trials_pockels_ratios_undefined{i}{handles.data.design.iter})];
            if ~isempty(handles.data.design.trials_pockels_ratios_multi_undefined{i}{handles.data.design.iter})
                multi_spot_targs = cat(1,multi_spot_targs,handles.data.design.trials_locations_undefined_key{i}{handles.data.design.iter});
                multi_spot_pockels = [multi_spot_pockels handles.data.design.trials_pockels_ratios_undefined{i}{handles.data.design.iter}];
                pockels_ratios = cat(1,pockels_ratios,handles.data.design.trials_pockels_ratios_multi_undefined{i}{handles.data.design.iter});
                undefined_freq = size(handles.data.design.trials_locations_undefined_key{i}{handles.data.design.iter},1) * ...
                    params.design.n_spots_per_trial/length(handles.data.design.undefined_cells{i}{handles.data.design.iter});
                handles.data.group_repeats(1) = 1;
                num_stim = num_stim + length(handles.data.design.trials_pockels_ratios_undefined{i}{handles.data.design.iter});
                handles.data.group_powers{1} = params.exp.max_power_ref;
                handles.data.group_multi_flag(1) = 1;
            else
                single_spot_targs = cat(1,single_spot_targs,handles.data.design.trials_locations_undefined_key{i}{handles.data.design.iter});
                single_spot_pockels_refs = [single_spot_pockels_refs handles.data.design.trials_pockels_ratios_undefined{i}{handles.data.design.iter}];
                undefined_freq = params.design.K_undefined;
                handles.data.group_repeats(1) = params.design.reps_undefined_single;
                num_stim = num_stim + length(handles.data.design.trials_pockels_ratios_undefined{i}{handles.data.design.iter})*params.design.reps_undefined_single;
                handles.data.group_powers{1} = handles.data.design.trials_powers_undefined{i}{handles.data.design.iter};
                handles.data.group_multi_flag(1) = 0;
            end

            % add disconnected targets
            handles.data.sequence_groups(2,:) = [1  length(handles.data.design.trials_pockels_ratios_disconnected{i}{handles.data.design.iter})] +...
                handles.data.sequence_groups(1,2);
            if ~isempty(handles.data.design.trials_pockels_ratios_multi_disconnected{i}{handles.data.design.iter})
                multi_spot_targs = cat(1,multi_spot_targs,handles.data.design.trials_locations_disconnected_key{i}{handles.data.design.iter});
                multi_spot_pockels = [multi_spot_pockels handles.data.design.trials_pockels_ratios_disconnected{i}{handles.data.design.iter}];
                pockels_ratios = cat(1,pockels_ratios,handles.data.design.trials_pockels_ratios_multi_disconnected{i}{handles.data.design.iter});
                disconnected_freq = size(handles.data.design.trials_locations_disconnected_key{i}{handles.data.design.iter},1) * ...
                    params.design.n_spots_per_trial/length(handles.data.design.potentially_disconnected_cells{i}{handles.data.design.iter});
                handles.data.group_repeats(2) = 1;
                num_stim = num_stim + length(handles.data.design.trials_pockels_ratios_disconnected{i}{handles.data.design.iter});
                handles.data.group_powers{2} = params.exp.max_power_ref;
                handles.data.group_multi_flag(2) = 1;
            else
                single_spot_targs = cat(1,single_spot_targs,handles.data.design.trials_locations_disconnected_key{i}{handles.data.design.iter});
                single_spot_pockels_refs = [single_spot_pockels_refs handles.data.design.trials_pockels_ratios_disconnected{i}{handles.data.design.iter}];
                disconnected_freq = params.design.K_disconnected;
                handles.data.group_repeats(2) = params.design.reps_disconnected_single;
                num_stim = num_stim + length(handles.data.design.trials_pockels_ratios_disconnected{i}{handles.data.design.iter})*params.design.reps_disconnected_single;
                handles.data.group_powers{2} = handles.data.design.trials_powers_disconnected{i}{handles.data.design.iter};
                handles.data.group_multi_flag(2) = 0;
            end

            % add connected targets
            handles.data.sequence_groups(3,:) = [1  length(handles.data.design.trials_pockels_ratios_connected{i}{handles.data.design.iter})] + ...
                handles.data.sequence_groups(2,2);
            single_spot_targs = cat(1,single_spot_targs,handles.data.design.trials_locations_connected_key{i}{handles.data.design.iter});
                single_spot_pockels_refs = [single_spot_pockels_refs handles.data.design.trials_pockels_ratios_connected{i}{handles.data.design.iter}];
            handles.data.group_repeats(3) = params.design.reps_connected;%params.design.K_connected;
            num_stim = num_stim + length(handles.data.design.trials_pockels_ratios_connected{i}{handles.data.design.iter})*params.design.reps_connected;
            handles.data.group_powers{3} = handles.data.design.trials_powers_connected{i}{handles.data.design.iter};
            handles.data.group_multi_flag(3) = 0;
    %         num_stim_check = size(multi_spot_targs,1)+size(single_spot_targs,1)

            % compute maximal stim freq
            undefined_freq = num_stim/undefined_freq;
            disconnected_freq = num_stim/disconnected_freq;
            connected_freq = num_stim/params.design.K_connected;

            handles.data.stim_freq = min([[undefined_freq disconnected_freq connected_freq]*params.exp.max_spike_freq params.exp.max_stim_freq])
            set(handles.iti,'String',num2str(1/handles.data.stim_freq))

            guidata(hObject,handles)
            
            % build the holograms
            instruction = struct();
            instruction.type = 83;
            instruction.do_target = 1;
            instruction.multi_spot_targs = multi_spot_targs;
            instruction.multi_spot_pockels = multi_spot_pockels;
            instruction.pockels_ratios = pockels_ratios;
            instruction.single_spot_targs = single_spot_targs;
            instruction.single_spot_pockels_refs = single_spot_pockels_refs;

            [return_info,success,handles] = do_instruction_slidebook(instruction,handles);
            guidata(hObject,handles)
            exp_data = handles.data; save(handles.data.params.fullsavefile,'exp_data');
            set(handles.num_stim,'String',num2str(num_stim));
        end
%         set(handles.repeat_start_ind,'String',num2str(return_info.num_stim - size(instruction.single_spot_locs,1)+1));
        
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
            set(handles.tf_flag,'Value',1)
            set(handles.set_seq_trigger,'Value',0)
            set(handles.target_intensity,'String',user_input_powers)

            [handles, acq_gui, acq_gui_data] = build_seq_groups(hObject, eventdata, handles);
        %     handles = guidata(hObject);
        %     acq_gui_data = get_acq_gui_data();
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
                exp_data = handles.data; save(handles.data.params.fullsavefile,'exp_data')
        %         guidata(acq_gui,acq_gui_data)

                acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
                waitfor(acq_gui_data.run,'String','Start')
                guidata(acq_gui,acq_gui_data)

            end
        end
        
        do_oasis_and_vi = 1;
        if experiment_setup.enable_user_breaks
            choice = questdlg('Run OASIS and VI?', ...
                'Run OASIS and VI?', ...
                'Yes','No','Yes');
            % Handle response
            switch choice
                case 'Yes'
                    do_oasis_and_vi = 1;
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
                    do_oasis_and_vi = 0;
            end
        end
        
        if do_oasis_and_vi
            trials = handles.data.start_trial:acq_gui_data.data.sweep_counter;
            [traces, ~, full_seq] = get_traces(acq_gui_data.data,trials);
            if ~params.design.do_connected_vi
                traces = traces([full_seq.group] ~= 3,:);
            end
            instruction = struct();
            instruction.data = traces;
            instruction.type = 200;
            instruction.filename = [handles.data.params.map_id '_z' num2str(i) '_iter' num2str(handles.data.design.iter)];

            instruction.do_dummy_data = 0;


            handles.data.full_seq = full_seq;

            
            handles.data.design.i = i;
            handles.data.design.n_cell_this_plane = n_cell_this_plane;
            
            instruction.exp_data = handles.data;
            [return_info,success,handles] = do_instruction_analysis(instruction,handles);
            
            handles.data = return_info.data; 
            guidata(hObject,handles)
            exp_data = handles.data;
            save(handles.data.params.fullsavefile,'exp_data')
            
        end    
            
        regroup_cells = 1;
        if experiment_setup.enable_user_breaks
            choice = questdlg('Regroup cells?', ...
            'Regroup cells?', ...
            'Yes','No','Yes');
            % Handle response
            switch choice
            case 'Yes'
                regroup_cells = 1;
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
                regroup_cells = 0;
            end
        end

        if regroup_cells
            data = handles.data;
            undefined_to_disconnected = ...
                intersect(find(data.design.mean_gamma_undefined<params.design.disconnected_threshold),find( data.design.undefined_cells{i}{data.design.iter}));
            undefined_to_connected = ...
                intersect(find(data.design.mean_gamma_undefined>params.design.connected_threshold),find( data.design.undefined_cells{i}{data.design.iter}));
            % cells move together with their neighbours
%             undefined_to_disconnected=find(sum(cell_neighbours(undefined_to_disconnected,:),1)>0)';
%             undefined_to_connected =find(sum(cell_neighbours(undefined_to_connected,:),1)>0);
%             % if there are conflicts, move them to the potentially connected cells
%             undefined_to_disconnected=setdiff(undefined_to_disconnected,undefined_to_connected);

            disconnected_to_undefined = intersect(find(data.design.mean_gamma_disconnected>params.design.disconnected_confirm_threshold),...
                find(data.design.potentially_disconnected_cells{i}{data.design.iter}));
            disconnected_to_dead = intersect(find(data.design.mean_gamma_disconnected<params.design.disconnected_confirm_threshold),...
                find(data.design.potentially_disconnected_cells{i}{data.design.iter}));

%             disconnected_to_undefined=find(sum(cell_neighbours(disconnected_to_undefined,:),1)>0);
%             % if there are conflicts, move them to the potentially connected cells
%             disconnected_to_dead=setdiff(disconnected_to_dead,disconnected_to_undefined);


            connected_to_dead = intersect(find(data.design.mean_gamma_connected<params.design.disconnected_confirm_threshold),...
                find(data.design.potentially_connected_cells{i}{data.design.iter}));
            connected_to_alive = intersect(find(data.design.mean_gamma_connected>params.design.connected_confirm_threshold),...
                find(data.design.potentially_connected_cells{i}{data.design.iter}));
%             change_gamma =abs(data.design.gamma_path{i}(:,data.design.iter+1)-data.design.gamma_path{i}(:,data.design.iter));
            connected_to_alive = intersect(find(data.design.change_gamma<params.design.change_threshold),...
                connected_to_alive);

            % Eliminate the weakly identifiable pairs if they are both assign to a
            % group:
            %moved_cells = [connected_to_dead; connected_to_alive]';
            %cells_and_neighbours=find(sum(cell_neighbours(moved_cells,:),1)>0);
            %neighbours_not_included=intersect(find(data.design.potentially_connected_cells{i}{data.design.iter}), setdiff(cells_and_neighbours,moved_cells));
            %blacklist=find(sum(cell_neighbours(neighbours_not_included,:),1)>0);
            %connected_to_dead=setdiff(connected_to_dead ,blacklist);
            %connected_to_alive=setdiff(connected_to_alive,blacklist);

            % Update the cell lists:
            data.design.undefined_cells{i}{data.design.iter+1}=data.design.undefined_cells{i}{data.design.iter};
            data.design.undefined_cells{i}{data.design.iter+1}(undefined_to_disconnected)=0;data.design.undefined_cells{i}{data.design.iter+1}(undefined_to_connected)=0;
            data.design.undefined_cells{i}{data.design.iter+1}(disconnected_to_undefined)=1;

            data.design.potentially_disconnected_cells{i}{data.design.iter+1}=data.design.potentially_disconnected_cells{i}{data.design.iter};
            data.design.potentially_disconnected_cells{i}{data.design.iter+1}(disconnected_to_dead)=0;data.design.potentially_disconnected_cells{i}{data.design.iter+1}(disconnected_to_undefined)=0;
            data.design.potentially_disconnected_cells{i}{data.design.iter+1}(undefined_to_disconnected)=1;


            data.design.potentially_connected_cells{i}{data.design.iter+1}=data.design.potentially_connected_cells{i}{data.design.iter};
            data.design.potentially_connected_cells{i}{data.design.iter+1}(connected_to_dead)=0;data.design.potentially_connected_cells{i}{data.design.iter+1}(connected_to_alive)=0;
            data.design.potentially_connected_cells{i}{data.design.iter+1}(undefined_to_connected)=1;

            data.design.dead_cells{i}{data.design.iter+1}=data.design.dead_cells{i}{data.design.iter};
            data.design.dead_cells{i}{data.design.iter+1}(disconnected_to_dead)=1;data.design.dead_cells{i}{data.design.iter+1}(connected_to_dead)=1;

            data.design.alive_cells{i}{data.design.iter+1}=data.design.alive_cells{i}{data.design.iter};
            data.design.alive_cells{i}{data.design.iter+1}(connected_to_alive)=1;
            
            assignin('base','undefined_cells',data.design.undefined_cells{i})
            assignin('base','potentially_disconnected_cells',data.design.potentially_disconnected_cells{i})
            assignin('base','potentially_connected_cells',data.design.potentially_connected_cells{i})
            
            %
            if sum(data.design.dead_cells{i}{data.design.iter}+data.design.alive_cells{i}{data.design.iter})==n_cell_this_plane
                data.design.id_continue{i}=0;% terminate
            else
                data.design.id_continue{i}=1;
            end
            data.design.iter = data.design.iter + 1
            handles.data = data;
            guidata(hObject,handles)
            save(handles.data.params.fullsavefile,'exp_data')
        end
        
        
        
        % Plot the progress
        fprintf('Number of trials so far: %d; number of cells killed: %d\n',handles.data.design.n_trials{i}, sum(handles.data.design.dead_cells{i}{handles.data.design.iter}+handles.data.design.alive_cells{i}{handles.data.design.iter}))
        
        do_cont = 0;
        choice = questdlg('Continue Plane?', ...
        'Continue Plane?', ...
        'Yes','No','Yes');
        % Handle response
        switch choice
        case 'Yes'
            do_cont = 1;
        case 'No'
            do_cont = 0;
        end

        if ~do_cont   
            handles.data.design.id_continue{i} = 0;
        end
    end
end    

exp_data = handles.data; save(handles.data.params.fullsavefile,'exp_data')

set(handles.close_socket_check,'Value',1);
instruction.type = 00;
instruction.string = 'done';
[return_info,success,handles] = do_instruction_slidebook(instruction,handles);
guidata(hObject,handles)    