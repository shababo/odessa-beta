function run_online_pipeline(exp_query_filename)


load(exp_query_filename)
% neighbourhood, experiment_query, experiment_setup

group_names = fieldnames(experiment_query);

% for i = 1:length(group_names)
%     this_group = group_names{i};
%     this_exp_query = experiment_query.(this_group);
%     
%     experiment_query.(this_group) = ...
%         experiment_setup.groups.(this_group).analysis_func(this_exp_query,experiment_setup);
%     
% end

% detect pscs and run vi
for i = 1:length(group_names)
    
    this_group = group_names{i};
    this_exp_query = experiment_query.(this_group);
    group_profile=experiment_setup.groups.(this_group);
    
    experiment_query.(this_group) = ...
        experiment_setup.groups.(this_group).psc_detect_function(this_exp_query,neighbourhood, group_profile, experiment_setup);
    
    neighbourhood = ...
        experiment_setup.groups.(this_group).inference_function(this_exp_query,neighbourhood,group_profile, experiment_setup.prior_info);
    
end

% regroup cells
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

% AT THIS POINT WRITE OUT TO EXPERIMENT RECORD
clear experiment_query

% CHECK FOR NEW MEMBERS



% design trials
for i = 1:length(group_names)
    
    
    this_group = group_names{i};
    this_exp_query = experiment_query.(this_group);
    
    batch_id = this_exp_query.batch_info.batch_id + 1;
    
    group_profile=experiment_setup.groups.(this_group);

    
    experiment_query.(this_group) = ...
        experiment_setup.groups.(this_group).design_function(neighbourhood,group_profile);
    experiment_query.(this_group).batch_info.batch_id = batch_id;
    
end

% compute holograms


fullpathname = ['/media/shababo/data/' experiment_setup.exp_id ...
                    '_n' num2str(neighbourhood.neighbourhood_id)...
                    '_b' num2str(experiment_query.batch_info.batch_id) '_to_acquisition.mat'];
                
save(fullpathname,'experiment_query','neighbourhood')

