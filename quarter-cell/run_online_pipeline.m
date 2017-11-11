function [experiment_query, neighbourhood] = run_online_pipeline(varargin)

if length(varargin) == 1
    
    exp_query_filename
    load(exp_query_filename)% neighbourhood, experiment_query, experiment_setup
elseif length(varargin) == 3
    neighbourhood = varargin{1};
    experiment_query = varargin{2};
    experiment_setup = varargin{3};
end
group_names = experiment_setup.group_names;

% for i = 1:length(group_names)
%     this_group = group_names{i};
%     this_exp_query = experiment_query.(this_group);
%     
%     experiment_query.(this_group) = ...
%         experiment_setup.groups.(this_group).analysis_func(this_exp_query,experiment_setup);
%     
% end

% detect pscs and run vi
num_trials = 0;
for i = 1:length(group_names)
    
    this_group = group_names{i};

    if any(get_group_inds(neighbourhood,this_group)) && ~isempty(experiment_query.(this_group).trials)
        this_exp_query = experiment_query.(this_group);
        group_profile=experiment_setup.groups.(this_group);
        experiment_query.(this_group) = ...
            experiment_setup.groups.(this_group).psc_detect_function(this_exp_query,neighbourhood, group_profile, experiment_setup);
        num_trials = num_trials + length(experiment_query.(this_group).trials);
        neighbourhood = ...
            experiment_setup.groups.(this_group).inference_function(this_exp_query,neighbourhood,group_profile, experiment_setup.prior_info);
    end
end

% regroup cells
if num_trials
    for i = 1:length(group_names)
        %for j = setdiff(1:length(group_names),i)
        this_group = group_names{i};
        %         to_group = group_names{j};
        to_groups=setdiff(group_names,this_group);
        group_profile=experiment_setup.groups.(this_group);
        %   regroup_func = experiment_setup.groups.(this_group).regroup_functions(to_group);
        neighbourhood  = experiment_setup.groups.(this_group).regroup_functions(neighbourhood,to_groups,group_profile);
    %     end
    end
end

% AT THIS POINT WRITE OUT TO EXPERIMENT RECORD



% CHECK FOR NEW MEMBERS


batch_ID = experiment_query.batch_info.batch_ID + 1;
clear experiment_query
% design trials
for i = 1:length(group_names)
    this_group = group_names{i};
    if any(get_group_inds(neighbourhood,this_group))
        
        

        group_profile=experiment_setup.groups.(this_group);


        experiment_query.(this_group) = ...
            experiment_setup.groups.(this_group).design_function(neighbourhood,group_profile);
        
    end
    
end
experiment_query.batch_info.batch_ID = batch_ID;

% compute holograms
% create_holograms_and_batch_seq
neighbourhood.batch_ID = batch_ID;

fullpathname = [experiment_setup.analysis_root experiment_setup.exp_id ...
                    '_n' num2str(neighbourhood.neighbourhood_id)...
                    '_b' num2str(experiment_query.batch_ID) '_to_acquisition.mat'];
                
save(fullpathname,'experiment_query','neighbourhood')

