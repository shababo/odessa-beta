function labelaxes(handles)

% % get(handles.Cell1_type_popup,'Value');
% if (get(handles.Cell1_type_popup,'Value'))==1
%     ylabel(handles.current_trial_axes(1),'pA')
% else
%     ylabel(handles.current_trial_axes(1),'mV')
% end
% 
% if get(handles.use_lut,'Value') && length(handles.current_trial_axes > 1)
%     ylabel(handles.current_trial_axes(2),'mW')
% elseif ~get(handles.use_lut,'Value') && length(handles.current_trial_axes > 1)
%     ylabel(handles.current_trial_axes(2),'V')
% end
    


% xlabel(handles.Whole_cell1_axes,'seconds')
% xlabel(handles.Whole_cell2_axes,'seconds')
% val = get(handles.Highpass_check, 'Value'); % check for highpass filtering
% if (val == 1)
%     ylabel(handles.Whole_cell1_axes_Rs,'spikerate')
% else
%     ylabel(handles.Whole_cell1_axes_Rs,'megaohm')
% end
% ylabel(handles.Whole_cell1_axes_Ih,'Ihold')
% ylabel(handles.Whole_cell1_axes_Ir,'Ri')
% xlabel(handles.Whole_cell1_axes_Ir, 'minutes')
% xlabel(handles.Whole_cell2_axes_Ir, 'minutes')
% xlabel(handles.stim_axes, 'seconds')
% ylabel(handles.stim_axes, 'Volts')
% 
% % compute total experiment time
% TotalExpTime = max(handles.data.trialtime)+0.001;
% 
% xlim(handles.Whole_cell1_axes_Rs,[0 TotalExpTime*1.33])
% xlim(handles.Whole_cell1_axes_Ih,[0 TotalExpTime*1.33])
% xlim(handles.Whole_cell1_axes_Ir,[0 TotalExpTime*1.33])
% xlim(handles.Whole_cell2_axes_Ih,[0 TotalExpTime*1.33])
% xlim(handles.Whole_cell2_axes_Ir,[0 TotalExpTime*1.33])
% xlim(handles.Whole_cell2_axes_Rs,[0 TotalExpTime*1.33])
% 
% ylim(handles.Whole_cell1_axes_Rs,[0 100])
% ylim(handles.Whole_cell1_axes_Ih,[-1000 0])
% ylim(handles.Whole_cell1_axes_Ir,[0 300])
% ylim(handles.Whole_cell2_axes_Rs,[0 70])
% ylim(handles.Whole_cell2_axes_Ih,[-1000 0])
% ylim(handles.Whole_cell2_axes_Ir,[0 300])


