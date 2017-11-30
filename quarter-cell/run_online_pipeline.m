function [experiment_query, neighbourhood] = run_online_pipeline(varargin)

disp('running online pipe')

if length(varargin) == 1
    
    exp_query_filename = varargin{1};
    load(exp_query_filename) % neighbourhood, experiment_query, experiment_setup
    
    
elseif length(varargin) == 3
    
    neighbourhood = varargin{1};
    experiment_query = varargin{2};
    experiment_setup = varargin{3};
    
end



% rebuild function links :(
group_names = experiment_setup.group_names;
for i = 1:length(group_names)
    experiment_setup.groups.(group_names{i}) = eval(['get_' group_names{i}]);
end
experiment_setup.prior_info.induced_intensity.linkfunc={@link_sig, @derlink_sig, @invlink_sig,@derinvlink_sig};

if strcmp(experiment_setup.experiment_type,'experiment') && experiment_setup.exp.sim_response
    experiment_query=generate_psc_data(experiment_query,experiment_setup,neighbourhood);
end

% FOR LOOP BELOW IS GENERAL ANALYSIS CASE (NOT DEBUGGED)
% for i = 1:length(group_names)
%     this_group = group_names{i};
%     this_exp_query = experiment_query.(this_group);
%     
%     experiment_query.(this_group) = ...
%         experiment_setup.groups.(this_group).analysis_func(this_exp_query,experiment_setup);
%     
% end

% RUN ANALYSIS (IN THIS CASE SPECIFICALLY SPLIT AS DETECT PSCS, RUN
% CONNECTIVITY INF
num_trials = 0;
neighbourhood = initialize_neurons_new_batch(neighbourhood);



for i = 1:length(group_names)
    % initialize parameters for all neurons in this neighbourhood for this
    % batch 

    this_group = group_names{i};

    if any(get_group_inds(neighbourhood,this_group)) && ...
            (isfield(experiment_query.(this_group),'trials') && ~isempty(experiment_query.(this_group).trials))
        
        this_exp_query = experiment_query.(this_group);
        group_profile=experiment_setup.groups.(this_group);
        experiment_query.(this_group) = ...
            experiment_setup.groups.(this_group).psc_detect_function(...
                    this_exp_query,neighbourhood,this_group, experiment_setup,experiment_query.batch_ID);
        
        num_trials = num_trials + length(experiment_query.(this_group).trials);
        
        neighbourhood = ...
            experiment_setup.groups.(this_group).inference_function(experiment_query.(this_group),neighbourhood,group_profile, experiment_setup);
    end
    

end

% regroup cells
if num_trials
    for i = 1:length(group_names)

        this_group = group_names{i};
        to_groups=setdiff(group_names,this_group);
        group_profile=experiment_setup.groups.(this_group);
        
        if isfield(group_profile,'regroup_function')
            for j = 1:length(to_groups)
                to_group = to_groups{j};
                if isfield(group_profile.regroup_function,to_group)
                    regroup_func = group_profile.regroup_function.(to_group);
                    neighbourhood  = regroup_func(neighbourhood,group_profile);
                end
            end
        end
        
    end
end

% AT THIS POINT WRITE OUT TO EXPERIMENT RECORD
batchsavepath = [experiment_setup.analysis_root experiment_setup.exp_id ...
                    '_n' num2str(neighbourhood.neighbourhood_ID)...
                    '_b' num2str(experiment_query.batch_ID) '_complete.mat'];
save(batchsavepath,'neighbourhood', 'experiment_query', 'experiment_setup')

% CHECK FOR NEW NEIGHBOURHOOD MEMBERS

% INCREMENT BATCH_ID HERE!
batch_ID = experiment_query.batch_ID + 1; 

% save('loading phases.mat','batch_ID')
% DESIGN NEXT BATCH OF TRIALS
clear experiment_query
if ~isfield(experiment_setup,'disk_grid_phase')
    load('phase-mask-base-v6.mat')
    experiment_setup.disk_grid_phase = cat(3,disk_grid_phase1,disk_grid_phase2);
    experiment_setup.fine_spots_grid_phase = fine_spots_grid_phase;
    clear disk_grid_phase1 disk_grid_phase2 fine_spots_grid_phase
end
% design trials
% Alwasy initialize all groups in experiment_query for a consistent format
% save('designing stim.mat','batch_ID')
for i = 1:length(group_names)
    
    this_group = group_names{i};
    experiment_query.(this_group)=struct([]);
    if any(get_group_inds(neighbourhood,this_group))
        
        group_profile=experiment_setup.groups.(this_group);
        if isfield(group_profile,'design_function')
            experiment_query.(this_group) = ...
                group_profile.design_function(neighbourhood,group_profile,experiment_setup);
        end
    end
    
end
experiment_query.batch_ID = batch_ID;
neighbourhood.batch_ID = batch_ID;
% save('tmp.mat','experiment_query')


% compute phase masks and other values related to running data acq
if experiment_setup.is_exp || experiment_setup.sim.compute_phase_masks
    disp('computing phase masks')
%     save('tmp.mat','experiment_query')
    experiment_query = ...
        compute_phase_masks_build_seq(experiment_query, experiment_setup, neighbourhood);
end
neighbourhood.batch_ID = batch_ID;

experiment_setup = rmfield(experiment_setup,'disk_grid_phase');
experiment_setup = rmfield(experiment_setup,'fine_spots_grid_phase');

if experiment_setup.is_exp

    fullpathname = [experiment_setup.ephys_mapped_drive experiment_setup.exp_id ...
                        '_n' num2str(neighbourhood.neighbourhood_ID)...
                        '_b' num2str(experiment_query.batch_ID) '_to_acquisition.mat'];
%                         filename = [experiment_setup.exp_id ...
%                             '_n' num2str(neighbourhood.neighbourhood_ID)...
%                             '_b' num2str(experiment_query.batch_ID) '_to_acquisition.mat'];
    disp('writing file')
    good_write = 0;
    while ~good_write
        try
            save(fullpathname,'experiment_query','neighbourhood','experiment_setup','-v6')
            load(fullpathname)
            good_write = 1;
        catch e
        end
    end
    %         status = -1;
    %         while status
    %         status = system(['smbclient //adesnik2.ist.berkeley.edu/excitation adesnik110623 -c ''cd /shababo ; '...
    %                 'put ' fullpathname ' ' filename ''''])
    %         end
    %         save(fullpathname,'experiment_query','neighbourhood','experiment_setup','-v7.3')
    fullpathname = [experiment_setup.ephys_mapped_drive experiment_setup.exp_id ...
                    '_n' num2str(neighbourhood.neighbourhood_ID)...
                    '_b' num2str(experiment_query.batch_ID) '_batch_ready.mat'];
    tmp = 'woot';
    good_write = 0;
    while ~good_write
        try
            save(fullpathname,'tmp')
            load(fullpathname)
            good_write = 1;
        catch e
        end
    end
    

elseif experiment_setup.sim.do_instructions
    
    fullpathname = [experiment_setup.analysis_root experiment_setup.exp_id ...
                        '_n' num2str(neighbourhood.neighbourhood_ID)...
                        '_b' num2str(experiment_query.batch_ID) '_batch _ready.mat'];
    save(fullpathname,'experiment_query','neighbourhood','experiment_setup','-v6')
        
end

disp('done online pipe')