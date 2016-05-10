function [ AO0, AO1, AO2, AO3 ] = analogoutput_gen(handles)

% assign local values
testpulse=handles.data.testpulse; stim_output=handles.data.stim_output; 
ch1_output=handles.data.ch1_output; ch2_output=handles.data.ch2_output;

% check for voltage clamp, current clamp, or LFP recording for each analog
% input channel from GUI
cell1_type = get(handles.Cell1_type_popup,'Value');
cell2_type = get(handles.Cell2_type_popup,'Value');

V_CLAMP = 1;
C_CLAMP = 2;
CELL_ATTACH = 3;




% set analog outputs to appropriate arrays based on values in Rig
% Defaults set in setup_structs
if (strcmp(handles.defaults.AO0,'ch1_out')==1) % if whole cell1 on AO0
    if  (cell1_type == V_CLAMP || cell1_type == CELL_ATTACH) % if voltage clamp
        if get(handles.test_pulse,'Value')
            AO0 = testpulse;
        else
            AO0 = zeros(size(ch1_output));
        end
    else          % if currentclamp
        AO0=ch1_output;
    end
else
    AO0 = zeros(size(ch1_output));
end

if (strcmp(handles.defaults.AO1,'ch2_out')==1) % if whole cell1 on AO0
    if  (cell2_type == V_CLAMP || cell2_type == CELL_ATTACH) % if voltage clamp
        if get(handles.test_pulse,'Value')
            AO1 = testpulse;
        else
            AO1 = zeros(size(ch2_output));
        end
    else          % if currentclamp
        AO1 = ch2_output;
    end
else
    AO1 = zeros(size(ch2_output));
end

if strcmp(handles.run_type,'loop')
    AO2 = zeros(size(AO0));
    AO3 = AO2;
else

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
end

length(AO0)
length(AO1)
length(AO2)
length(AO3)

