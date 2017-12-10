function [experiment_query, sequence] = make_slidebook_sequence(experiment_query,experiment_setup)

group_names = experiment_setup.group_names;
sequence = struct();

% build unique phase masks
trial_count = 1;
for i = 1:length(group_names)
    
    if isfield(experiment_query.(group_names{i}),'trials')
        trials = experiment_query.(group_names{i}).trials;

        for j = 1:length(trials)
            sequence(trial_count).start = trials(j).start;
            sequence(trial_count).duration = trials(j).duration;
            sequence(trial_count).power = trials(j).power;
            sequence(trial_count).filter_configuration = experiment_setup.exp.filter_config;
            sequence(trial_count).precomputed_target_index = trials(j).precomputed_target_index;
            sequence(trial_count).group_trial_ID = j;
            sequence(trial_count).group_ID = experiment_query.(group_names{i}).group_ID;
            z_options = trials(j).locations(:,3);
            z_pos = z_options(find(~isnan(z_options),1,'first'));
            if ~isempty(z_pos)
                sequence(trial_count).piezo_z = z_pos;% %round(100*rand)
            else
                sequence(trial_count).piezo_z = 50;
            end
            experiment_query.(group_names{i}).trials(j).trial_ID = trial_count;

            trial_count = trial_count + 1;
        end        
    end
end

% randomize order
order = randperm(length(sequence));
sequence = sequence(order);

sequence(1).start = round(experiment_setup.exp.first_stim_time*1000);
for i = 2:length(sequence)
    iti = round(1000*(i-1)*(1/experiment_query.batch_trial_rate));
    sequence(i).start = ...
        round(1000*experiment_setup.exp.first_stim_time) + iti;
end