function experiment_setup = get_response_model_calib_setup

experiment_setup.exp_root = 'C:\data\Shababo\';
experiment_setup.trials.Fs = 20000;
experiment_setup.trials.max_time_sec = .050;

clock_array = clock;
experiment_setup.exp_id = [num2str(clock_array(2)) '_' num2str(clock_array(3)) ...
    '_' num2str(clock_array(4)) ...
    '_' num2str(clock_array(5))];
experiment_setup.exp.fullsavefile = ...
    fullfile(experiment_setup.exp_root,[experiment_setup.exp_id '_data.mat']);

experiment_setup.enable_user_breaks = 0;

experiment_setup.zero_order
experiment_setup.um_per_px
experiment_setup.um_per_slice

