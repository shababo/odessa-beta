function experiment_query = ...
    add_voltage_clamp_data(experiment_query,traces,this_seq,experiment_setup)



for i = 1:length(experiment_setup.group_names)
    
    for j = 1:length(experiment_query.(experiment_setup.group_names{i}).trials)
        
        experiment_query.(experiment_setup.group_names{i}).trials(j).voltage_clamp = ...
            traces(experiment_query.(experiment_setup.group_names{i}).trials(j).trial_ID,:);
        
    end
    
end