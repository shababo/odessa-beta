function experiment_setup = get_ground_truth_setup

experiment_setup.experiment_type = 'experiment';
experiment_setup.exp_root = 'C:\data\Shababo\';
experiment_setup.trials.Fs = 20000;
experiment_setup.trials.max_time_sec = .030;

clock_array = clock;
experiment_setup.exp_id = [num2str(clock_array(2)) '_' num2str(clock_array(3)) ...
    '_' num2str(clock_array(4)) ...
    '_' num2str(clock_array(5))];
experiment_setup.exp.fullsavefile = ...
    fullfile(experiment_setup.exp_root,[experiment_setup.exp_id '_data.mat']);

experiment_setup.enable_user_breaks = 0;

experiment_setup.image_zero_order_coord = [121.6; 120.8]; 
experiment_setup.image_um_per_px = 1.89;
experiment_setup.image_um_per_slice = 2.0;

experiment_setup.get_ch2 = 1;
experiment_setup.stack_duration = 25; %sec

experiment_setup.num_connection_test_reps = 10;
experiment_setup.mapping_bounds_rel = [-40 -20 -40; 40 20 40];

experiment_setup.num_condition_reps = 3;
