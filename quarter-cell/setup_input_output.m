function data = setup_input_output(data, defaults)

% % set initial values for the stimulation output here
pulseamp=0; % in volts%
%pulseamp=[0 0.2 .4 .6 .8 1 1.2 1.4]; % in volts
pulseduration=.010; % in seconds
%pulsenumber=8;
pulsenumber=1;
pulsefrequency=0.5; % in Hz
pulse_starttime=.300; % in seconds
% 
% 
[data.stim_output, data.timebase] = makepulseoutputs(0, 1, 0, 0 ,1, defaults.Fs, defaults.trial_length);


% setup testpulse for votlage clamp
data.testpulse = makepulseoutputs(defaults.testpulse_start, 1, defaults.testpulse_duration, defaults.testpulse_amp, 1, defaults.Fs, defaults.trial_length);

% setup current injection params for cell1
ccpulseamp1=0;
ccpulse_dur1=0;
ccnumpulses1=1;
ccpulsefreq1=0.5;
ccpulsestarttime1=0;
deltacurrentpulseamp1=0;
ch1_output=makepulseoutputs(ccpulsestarttime1, ccnumpulses1, ccpulse_dur1, ccpulseamp1 ,ccpulsefreq1, defaults.Fs, defaults.trial_length);%makepulseoutputs(ccpulsestarttime1,ccnumpulses1, ccpulse_dur1, ccpulseamp1, ccpulsefreq1, defaults.Fs, defaults.trial_length);
data.ch1_output=ch1_output/defaults.CCexternalcommandsensitivity; % scale by externalcommand sensitivity under Current clamp

% setup current injection params for cell2
ccpulseamp2=0;
ccpulse_dur2=0;
ccnumpulses2=1;
ccpulsefreq2=20;
ccpulsestarttime2=0;
deltacurrentpulseamp2=0;
ch2_output=makepulseoutputs(ccpulsestarttime2, ccnumpulses2, ccpulse_dur2, ccpulseamp2 ,ccpulsefreq2, defaults.Fs, defaults.trial_length);%makepulseoutputs(ccpulsestarttime2,ccnumpulses2, ccpulse_dur2, ccpulseamp2, ccpulsefreq2, defaults.Fs, defaults.trial_length);
data.ch2_output=ch2_output/defaults.CCexternalcommandsensitivity; % scale by externalcommand sensitivity under Current clamp

highpass_freq1 = 500;
highpass_freq2 = 500;

series_r1=[];
holding_i1=[];
input_r1=[];

series_r2=[];
holding_i2=[];
input_r2=[];



  
data.ch1 = struct('series_r', series_r1, 'holding_i', holding_i1, 'input_r', input_r1, 'pulseamp', ...
    ccpulseamp1, 'pulseduration', ccpulse_dur1, 'pulsenumber', ccnumpulses1, 'pulsefrequency', ccpulsefreq1, ...
    'pulse_starttime', ccpulsestarttime1, 'deltacurrentpulseamp1',deltacurrentpulseamp1, ...
    'highpass_freq', highpass_freq1,'user_gain',1);

data.ch2 = struct('series_r', series_r2, 'holding_i', holding_i2, 'input_r', input_r2, 'pulseamp', ...
    ccpulseamp2, 'pulseduration', ccpulse_dur2, 'pulsenumber', ccnumpulses2, 'pulsefrequency', ccpulsefreq2, ...
    'pulse_starttime', ccpulsestarttime2, 'deltacurrentpulseamp2',deltacurrentpulseamp2,...
    'highpass_freq', highpass_freq2,'user_gain',1);

data.stimulation = struct('pulseamp', pulseamp, 'pulseduration', pulseduration, 'pulsefrequency', pulsefrequency, ...
    'pulsenumber', pulsenumber, 'pulse_starttime', pulse_starttime);



