function [defaults, s, data] = setup_structs()


%%--set Rig Defaults Values here----%%

% set default path for saving files here
save_path='C:\data\Shababo\';
experiment_name = ['tmp-' regexprep(mat2str(clock),'[| |\]|\d\d\.\d*','') '.mat'];
save_name = [save_path experiment_name];

% set amplifier info
amplifier = 'Axon CNS'; % or Multiclamp

% set sampling frequency in Hz
Fs = 20000;  

% set default inter-stimulus-interval; this is the total time between
% successive trigers from the timer fcn, not the time between trials
ISI = 2.0; %in sec

% set default sweep duration (in seconds)
sweepduration = 1.0;

% set default state for saving after each trial, 0 for no saving, 1 for saving after each trial
% may want no saving if will hang up computer on long experiments with long
% trial durations
ifsave=0; 
     
% set total sweeps (use high number so timer function doensn't stop)
total_sweeps=Inf; 

% set default voltage clamp external command sensititivty (fixed for Axon
% amplifiers at 20 mV/mV)
VCexternalcommandsensitivity = 20; 
CCexternalcommandsensitivity = 400;  % for multiclamp

% set default type of output for each analog output channel
AO0 = 'ch1-primary'; 
AO1 = 'ch2-primary';
AO2 = 'stimulation';
AO3 = 'stimulation';
 

%%--end setting Rig Defaults Values----%%

% get info about DAQ device 
device=daq.getDevices;
daqModel = device.Model;

%initialize sweep counter to 1
sweep_counter = 1; 

% setup other fields
ch1_output=[]; ch2_output=[]; exp_name=''; stimulation=[]; save_name=save_name; save_path = save_path;
SetSweepNumber=1; ch1sweep=[]; ch2sweep=[]; 
stims=[]; sweeps={}; testpulse=[]; thissweep=[]; timebase=[];

% create time vector for plotting across trials
trialtime=0;

running = [];


defaults = struct('Fs', Fs,'sweepduration', sweepduration,'ISI', ISI, 'daqModel', device.Model, ...
    'total_sweeps', total_sweeps, 'amplifier', amplifier, ...
    'VCexternalcommandsensitivity', VCexternalcommandsensitivity, 'CCexternalcommandsensitivity', ...
    CCexternalcommandsensitivity, 'ifsave', ifsave, ...
    'AO0', AO0, 'AO1', AO1, 'AO2', AO2,'AO3',AO3);
data = struct('ch1_output', ch1_output, 'ch2_output', ch2_output, 'exp_name', exp_name, 'stimulation', stimulation,...
    'save_name', save_name, 'save_path', save_path, 'experiment_name', experiment_name, 'SetSweepNumber', SetSweepNumber, 'ch1sweep', ch1sweep, 'ch2sweep', ch2sweep, ...
     'stims', stims, 'sweep_counter', sweep_counter, 'testpulse', testpulse, ...
    'thissweep', thissweep, 'timebase', timebase, 'trialtime', trialtime, 'running', running);



s = daq.createSession('ni');
s.Rate = Fs;
s.addAnalogInputChannel('dev1',0:2,'Voltage');
s.Channels(1).InputType = 'SingleEnded';
s.Channels(2).InputType = 'SingleEnded';
s.Channels(3).InputType = 'SingleEnded';

s.addAnalogOutputChannel('dev1',0:3,'Voltage');
