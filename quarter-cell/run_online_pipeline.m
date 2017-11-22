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
group_names = experiment_setup.group_names;

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
for i = 1:length(group_names)
    % initialize parameters for all neurons in this neighbourhood for this
    % batch 
%      neighbourhood = n(neighbourhood);
    this_group = group_names{i};

    if any(get_group_inds(neighbourhood,this_group)) && ~isempty(experiment_query.(this_group).trials)
        
        this_exp_query = experiment_query.(this_group);
        group_profile=experiment_setup.groups.(this_group);
        experiment_query.(this_group) = ...
            experiment_setup.groups.(this_group).psc_detect_function(this_exp_query,neighbourhood, group_profile, experiment_setup);
        
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

% DESIGN NEXT BATCH OF TRIALS
clear experiment_query
% design trials
% Alwasy initialize all groups in experiment_query for a consistent format

for i = 1:length(group_names)
    
    this_group = group_names{i};
    experiment_query.(this_group)=struct([]);
    if any(get_group_inds(neighbourhood,this_group))
        
        group_profile=experiment_setup.groups.(this_group);

        experiment_query.(this_group) = ...
            experiment_setup.groups.(this_group).design_function(neighbourhood,group_profile,experiment_setup);
        
    end
    
end
experiment_query.batch_ID = batch_ID;
neighbourhood.batch_ID = batch_ID;


% create_holograms_and_batch_seq

if experiment_setup.is_exp || experiment_setup.sim.compute_phase_masks
    experiment_query = compute_phase_masks_build_seq(experiment_query, experiment_setup);
end
neighbourhood.batch_ID = batch_ID;

if experiment_setup.is_exp || experiment_setup.sim.do_instructions
    fullpathname = [experiment_setup.analysis_root experiment_setup.exp_id ...
                        '_n' num2str(neighbourhood.neighbourhood_ID)...
                        '_b' num2str(experiment_query.batch_ID) '_to_acquisition.mat'];

    save(fullpathname,'experiment_query','neighbourhood')
end

disp('done online pipe')