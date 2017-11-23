function experiment_query = run_oasis(experiment_query,neighbourhood,group_profile,experiment_setup)

if strcmp(experiment_setup.experiment_type,'simulation') && ~experiment_setup.sim.sim_vclamp
    
    for i = 1:length(experiment_query.trials)
        experiment_query.trials(i).event_times = ...
            experiment_query.trials(i).truth.event_times;
    end
    return
end

filename = [experiment_setup.exp_id '_z' num2str(neighbourhood.neighbourhood_ID) '_g' group_profile.group_id '_b' num2str(experiment_query.batch_id)];

cmd = 'python /home/shababo/projects/mapping/code/OASIS/run_oasis_online.py ';

fullsavepath = [experiment_setup.analysis_root filename '.mat'];
oasis_out_path = ['/media/shababo/data/' filename '_detect.mat'];

% trial_count = length(experiment_query.sequence);
% trial_length = experiment_setup.trials.max_time;

% traces = zeros(trial_count,trial_length);
trial_count = 1;
for i = 1:length(experiment_query.group_names)
    for j = 1:length(experiment_query.(experiment_setup.group_names{i}).trials)
        traces(trial_count,:) = experiment_query.(experiment_setup.group_names{i}).trials(j).voltage_clamp;
        trial_count = trial_count + 1;
    end
end
save(fullsavepath,'traces')
cmd = [cmd ' ' fullsavepath];
system(cmd)
% Wait for file to be created.
maxSecondsToWait = 60*5; % Wait five minutes...?
secondsWaitedSoFar  = 0;
while secondsWaitedSoFar < maxSecondsToWait 
  if exist(oasis_out_path, 'file')
    break;
  end
  pause(1); % Wait 1 second.
  secondsWaitedSoFar = secondsWaitedSoFar + 1;
end
if exist(oasis_out_path, 'file')
  load(oasis_out_path)
  oasis_data = reshape(event_process,size(instruction.data'))';

else
  fprintf('Warning: x.log never got created after waiting %d seconds', secondsWaitedSoFar);
%               uiwait(warndlg(warningMessage));
  oasis_data = zeros(size(instruction.traces));
end

trial_count = 1;
for i = 1:length(experiment_setup.group_names)
    for j = 1:length(experiment_query.(experiment_setup.group_names{i}).trials)
        experiment_query.trials(i).event_times = ...
            find(oasis_data(trial_count,...
                    experiment_setup.trials.min_time:experiment_setup.trials.max_time),1) + ...
                    experiment_setup.trials.min_time - 1;
    end
end
