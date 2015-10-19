function [ AO0, AO1, AO2, AO3 ] = analogoutput_gen(handles)

% assign local values
testpulse=handles.data.testpulse; stim_output=handles.data.stim_output; 
ch1_output=handles.data.ch1_output; ch2_output=handles.data.ch2_output;

% check for voltage clamp, current clamp, or LFP recording for each analog
% input channel from GUI
value1 = get(handles.Cell1_type_popup,'Value');
value2 = get(handles.Cell2_type_popup,'Value');



% set analog outputs to appropriate arrays based on values in Rig
% Defaults set in setup_structs
if (strcmp(handles.defaults.AO0,'ch1_out')==1) % if whole cell1 on AO0
    if  value1==1 % if voltage clamp
        AO0=testpulse;
    else          % if currentclamp
        AO0=ch1_output;
    end
end

if (strcmp(handles.defaults.AO1,'ch2_out')==1) % if whole cell1 on AO0
    if  value2==1 % if voltage clamp
        AO1=testpulse;
    else          % if currentclamp
        AO1=ch2_output;
    end
end

if (strcmp(handles.defaults.AO1,'stimulation')==1)
    AO1=handles.data.stim_output;
end

if (strcmp(handles.defaults.AO2,'stimulation')==1)
    AO2=handles.data.stim_output;
end

if (strcmp(handles.defaults.AO3,'stimulation')==1)
    AO3=handles.data.stim_output;
end

if (strcmp(handles.defaults.AO3,'none')==1)
    AO3=zeros(size(AO2));
end
