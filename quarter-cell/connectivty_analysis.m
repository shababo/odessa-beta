function connectivty_analysis(experiment_query

% detect pscs
experiment_query = ...
        experiment_setup.groups.(this_group).psc_detect_func(this_exp_query,experiment_setup);
    
% run vi
experiment_query.(this_group) = ...
        experiment_setup.groups.(this_group).inference_func(this_exp_query,experiment_setup);
    
