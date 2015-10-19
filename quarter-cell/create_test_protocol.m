%% current-response
clear protocol
amplitudes = [0.50 0.67 0.93 1.18];%[0.60 0.89 1.14];% 1.18];% roi1: [.48 .68 0.98 1.26];

clamp_type = 'voltage';

durations = [5 25 50]/1000;
trial_per_condtion = 3;
trial_length = 1.0;
Fs = 20000;

tag = ['chronos-current-response-circle-roi1-0924-25-50-100-150-' clamp_type];

trial_count = 1;
for j = 1:length(durations)
    for i = 1:length(amplitudes)
   
        for k = 1:trial_per_condtion
            i
            j
            trial_count
            if strcmp(clamp_type,'voltage')
                ch1_out = makepulseoutputs(.05, 1, .05, -.2 ,1, Fs, trial_length);
            elseif strcmp(clamp_type,'current')
                ch1_out =  makepulseoutputs(.05, 1, .05, 0 ,1, Fs, trial_length);
            end
            
            protocol(trial_count).output = [ ch1_out...
                                            zeros(Fs*trial_length,1) ...
                                            makepulseoutputs(.3, 1, durations(j), amplitudes(i) ,1, Fs, trial_length) ...
                                            zeros(Fs*trial_length,1)];
            protocol(trial_count).intertrial_interval = .8;
            trial_count = trial_count + 1;
        end
    end
end

save_name = ['C:\data\Shababo\' tag '.mat'];
save(save_name,'protocol')
