%% current-response

rng(1234)

amplitudes = [0.54 0.70 0.99];% 1.18];% roi1: [.48 .68 0.98 1.26];
mean_power = 80;
std_power = 15;
clamp_type = 'current';

trials_per_noise = 3;

trials = 10;
trial_length = 2.0;
Fs = 20000; 

noise_length = .5;
noise_start = .3;


tag = ['reachrcitrine-current-response-circle-roi1-0921-white-' clamp_type];

trial_count = 1;

for k = 1:trials_per_noise
    for i = 1:trials
    
    
            
            if strcmp(clamp_type,'voltage')
                ch1_out = makepulseoutputs(.05, 1, .05, -.2 ,1, Fs, trial_length);
            elseif strcmp(clamp_type,'current')
                ch1_out =  makepulseoutputs(.05, 1, .05, 0 ,1, Fs, trial_length);
            end
            
            noise = normrnd(mean_power,std_power,[Fs*noise_length 1]);
            for j = 1:length(noise)
                [min_val, min_ind] = min(abs(pockels_curve - noise(j)));
                noise(j) = volts(min_ind);
            end
            
            stim_out = zeros(size(ch1_out));
            stim_out(floor(noise_start*Fs):floor(noise_start*Fs) + length(noise) - 1) = noise;
            
            protocol(trial_count).output = [ ch1_out...
                                            zeros(Fs*trial_length,1) ...
                                            stim_out ...
                                            zeros(Fs*trial_length,1)];
            protocol(trial_count).intertrial_interval = 2.0;
            trial_count = trial_count + 1;
    end
end


save_name = ['C:\data\Shababo\' tag '.mat'];
save(save_name,'protocol')
