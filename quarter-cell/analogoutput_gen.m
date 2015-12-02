function [ AO0, AO1, AO2, AO3 ] = analogoutput_gen(handles)

% assign local values
testpulse=handles.data.testpulse; stim_output=handles.data.stim_output; 
ch1_output=handles.data.ch1_output; ch2_output=handles.data.ch2_output;

% check for voltage clamp, current clamp, or LFP recording for each analog
% input channel from GUI
cell1_vc = get(handles.Cell1_type_popup,'Value');
cell2_vc = get(handles.Cell2_type_popup,'Value');



% set analog outputs to appropriate arrays based on values in Rig
% Defaults set in setup_structs
if (strcmp(handles.defaults.AO0,'ch1_out')==1) % if whole cell1 on AO0
    if  cell1_vc==1 || cell1_vc ==3 % if voltage clamp
        AO0=testpulse;
    else          % if currentclamp
        AO0=ch1_output;
    end
else
    AO0 = zeros(size(testpulse));
end

if (strcmp(handles.defaults.AO1,'ch2_out')==1) % if whole cell1 on AO0
    if  cell2_vc==1 % if voltage clamp
        AO1=testpulse;
    else          % if currentclamp
        AO1=ch2_output;
    end
else
    AO1 = zeros(size(AO0));
end


if (strcmp(handles.defaults.AO2,'LED')==1) && get(handles.use_LED,'Value')
    AO2=handles.data.stim_output;
else
    AO2=zeros(size(AO0));
end

if (strcmp(handles.defaults.AO3,'2P')==1) && get(handles.use_2P,'Value')
    AO3=handles.data.stim_output;
else
    AO3=zeros(size(AO0));
end


