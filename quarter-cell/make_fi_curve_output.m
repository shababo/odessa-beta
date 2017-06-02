function [output, timebase, trial_length] = make_fi_curve_output(Fs)

% makes a hard coded intrinsic ephys trial with current steps
baseline_duration = 5.0;
pulse_duration = 1.0;
interpulse_duration = 2.0;


pulse_amps = [-200 -100 50:50:200 300 400];


trial_length = 2*baseline_duration + (pulse_duration + interpulse_duration)*length(pulse_amps);
timebase = linspace(0,trial_length - 1/Fs,Fs*trial_length)';

output = linspace(0,0,Fs*trial_length)'; 

current_ind = baseline_duration*Fs;
pulse_wait_samples = (pulse_duration + interpulse_duration)*Fs;
pulse_samples = pulse_duration*Fs;

for i = 1:length(pulse_amps)
    
    output(current_ind:current_ind + pulse_samples -1) = pulse_amps(i);
    current_ind = current_ind + pulse_wait_samples;
    
end