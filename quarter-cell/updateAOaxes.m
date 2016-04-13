function handles = updateAOaxes(handles)

% plot(handles.stim_axes,handles.data.timebase,handles.data.stim_output);%,handles.data.timebase, handles.data.piezooutput);
% % axis(handles.stim_axes, [0 handles.defaults.trial_length -6  6])
% % axis(handles.stim_axes, [0 handles.defaults.trial_length -1  max(handles.data.LEDoutput)])
% xlabel(handles.stim_axes, 'seconds')
% ylabel(handles.stim_axes, 'V')

ch1_output=handles.data.ch1_output*handles.defaults.CCexternalcommandsensitivity;
if isempty(handles.data.ch2_output)~=1
    ch2_output=handles.data.ch2_output*handles.defaults.CCexternalcommandsensitivity; % reverse scale just for plotting
    plot(handles.CCoutput_axes,handles.data.timebase,ch1_output,handles.data.timebase,ch2_output);
elseif isempty(handles.data.CCoutput1)~=1
    plot(handles.CCoutput_axes,handles.data.timebase,ch1_output);

    
end

    
if max(ch1_output)>600
    axis(handles.CCoutput_axes, [0 handles.defaults.trial_length -200 1.1*max(ch1_output)]);
else
    axis(handles.CCoutput_axes, [0 handles.defaults.trial_length -200 700]);
end
xlabel(handles.CCoutput_axes, 'seconds')
ylabel(handles.CCoutput_axes, 'pA')
% axis(handles.CCoutput_axes, [0 handles.defaults.trial_length -6  6])

    