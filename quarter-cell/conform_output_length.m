function all_outs = conform_output_length(handles)

testpulse=handles.data.testpulse; stim_output=handles.data.stim_output; 
ch1_output=handles.data.ch1_output; ch2_output=handles.data.ch2_output;

all_outs = {testpulse,stim_output,ch1_output,ch2_output};

timebase = linspace(0,handles.defaults.trial_length - 1/handles.defaults.Fs,...
    handles.defaults.Fs*handles.defaults.trial_length)';
trial_length = length(timebase);

for i = 1:length(all_outs)
    if length(all_outs{i}) > trial_length
        all_outs{i} = all_outs{i}(1:trial_length);
    elseif length(all_outs{i}) < trial_length
        all_outs{i} = ...
            [all_outs{i}; zeros(trial_length - length(all_outs{i}),1)];
    end
end
        
