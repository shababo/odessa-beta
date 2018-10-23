function handles = setup_patches(hObject,eventdata,handles,acq_gui,acq_gui_data,params)


% whole cell or cell-attached?
% Construct a questdlg with three options
clamp_choice1 = questdlg('Cell 1 Patch Type?', ...
	'Patch type?', ...
	'Voltage Clamp','Current Clamp','Cell Attached','Voltage Clamp');
% Handle response
switch clamp_choice1
    case 'Voltage Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',1)
%         set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell1 = 1;
    case 'Current Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',2)
%         set(acq_gui_data.Cell2_type_popup,'Value',2)
        whole_cell1 = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell1_type_popup,'Value',3)
%         set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell1 = 0;
end

clamp_choice2 = questdlg('Cell 2 Patch Type?', ...
	'Patch type?', ...
	'Voltage Clamp','Current Clamp','Cell Attached','Voltage Clamp');
% Handle response
switch clamp_choice2
    case 'Voltage Clamp'
        set(acq_gui_data.Cell2_type_popup,'Value',1)
%         set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell2 = 1;
    case 'Current Clamp'
        set(acq_gui_data.Cell2_type_popup,'Value',2)
%         set(acq_gui_data.Cell2_type_popup,'Value',2)
        whole_cell2 = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell2_type_popup,'Value',3)
%         set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
        whole_cell2 = 0;
end

% if handles.data.set_cell2_pos
%     clamp_choice2 = questdlg('Cell 2 Patch Type?', ...
%         'Patch type?', ...
%         'Voltage Clamp','Current Clamp','Cell Attached','Voltage Clamp');
%     % Handle response
%     switch clamp_choice2
%         case 'Voltage Clamp'
%             set(acq_gui_data.Cell2_type_popup,'Value',1)
%             set(acq_gui_data.test_pulse,'Value',1)
%             whole_cell2 = 1;
%         case 'Current Clamp'
%             set(acq_gui_data.Cell2_type_popup,'Value',2)
%             whole_cell2 = 1;
%         case 'Cell Attached'
%             set(acq_gui_data.Cell2_type_popup,'Value',3)
%             set(acq_gui_data.test_pulse,'Value',1)
%             whole_cell2 = 0;
%     end
% else
%     clamp_choice2 = 'Cell Attached';
%     set(acq_gui_data.Cell2_type_popup,'Value',3)
%     set(acq_gui_data.test_pulse,'Value',0)
%     whole_cell2 = 0;
% end


if whole_cell1 %|| whole_cell2
    
    do_whole_cell_stuff = 0;
    choice = questdlg('Get patch ready and take baseline/instrinsics?', ...
        'Get patch ready and take baseline/instrinsics?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            do_whole_cell_stuff = 1;
        case 'No'
            do_whole_cell_stuff = 0;
    end
    
    if do_whole_cell_stuff
        
        user_confirm = msgbox('Break in! Rs okay? Test pulse off? In v-clamp?');
        waitfor(user_confirm)


    %     acq_gui = findobj('Tag','acq_gui');
    %     acq_gui_data = guidata(acq_gui);


        % do single testpulse trial to get Rs
        % set acq params
        set(acq_gui_data.run,'String','Prepping...')
        set(acq_gui_data.Cell1_type_popup,'Value',1)
        set(acq_gui_data.Cell2_type_popup,'Value',1)

        set(acq_gui_data.trial_length,'String',5.0)
        acq_gui_data = Acq('trial_length_Callback',acq_gui_data.trial_length,eventdata,acq_gui_data);
        set(acq_gui_data.test_pulse,'Value',1)
        set(acq_gui_data.loop,'Value',1)
        set(acq_gui_data.loop_count,'String',num2str(1))
        set(acq_gui_data.trigger_seq,'Value',0)
        % run trial
        Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
        waitfor(acq_gui_data.run,'String','Start')
        [acq_gui, acq_gui_data] = get_acq_gui_data;
%         guidata(acq_gui,acq_gui_data)


        do_intrinsics = 0;
        choice = questdlg('Do intrinsics?', ...
            'Do intrinsics?', ...
            'Cell 1','None','Cell 1 & 2','None');
        % Handle response
        switch choice
            case 'Cell 1'
                do_intrinsics = 1;
                set(acq_gui_data.Cell1_type_popup,'Value',2)
                acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
            case 'Cell 2'
                do_intrinsics = 1;
                set(acq_gui_data.Cell2_type_popup,'Value',2)
                acq_gui_data = Acq('cell2_intrinsics_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
            case 'Cell 1 & 2'
                do_intrinsics = 1;
                set(acq_gui_data.Cell1_type_popup,'Value',2)
                set(acq_gui_data.Cell2_type_popup,'Value',2)
                acq_gui_data = Acq('cell1_intrinsics_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
                acq_gui_data = Acq('cell2_intrinsics_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
            case 'None'
                do_intrinsics = 0;
        end

        if do_intrinsics
            % tell user to switch to I=0
            user_confirm = msgbox('Please switch Multiclamp to CC with I = 0 for intrinsics cells');
            waitfor(user_confirm)

            % run intrinsic ephys
            % set acq params
            set(acq_gui_data.run,'String','Prepping...')

    %         guidata(acq_gui,acq_gui_data);
            set(acq_gui_data.test_pulse,'Value',0)
            set(acq_gui_data.trigger_seq,'Value',0)
            % run trial

            acq_gui_data = Acq('run_Callback',acq_gui_data.run,eventdata,acq_gui_data);
            waitfor(acq_gui_data.run,'String','Start')
            [acq_gui, acq_gui_data] = get_acq_gui_data;
%             guidata(acq_gui,acq_gui_data)

             switch choice
                case 'Cell 1'
                    do_intrinsics = 1;
    %                 set(acq_gui_data.Cell1_type_popup,'Value',2)
    %                 acq_gui_data.data.ch1.pulseamp = 0;
                    set(acq_gui_data.ccpulseamp1,'String','0');
                    acq_gui_data = Acq('ccpulseamp1_Callback',acq_gui_data.ccpulseamp1,eventdata,acq_gui_data);
                    acq_gui_data = Acq('update_cc_cell1_button_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
                case 'Cell 2'
                    do_intrinsics = 1;
    %                 set(acq_gui_data.Cell2_type_popup,'Value',2)
    %                 acq_gui_data.data.ch2.pulseamp = 0;
                    set(acq_gui_data.ccpulseamp2,'String','0');
                    acq_gui_data = Acq('ccpulseamp2_Callback',acq_gui_data.ccpulseamp2,eventdata,acq_gui_data);
                    acq_gui_data = Acq('update_cc_cell2_button_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
                case 'Cell 1 & 2'
                    do_intrinsics = 1;
    %                 set(acq_gui_data.Cell1_type_popup,'Value',2)
    %                 set(acq_gui_data.Cell2_type_popup,'Value',2)
                    set(acq_gui_data.ccpulseamp1,'String','0');
                    acq_gui_data = Acq('ccpulseamp1_Callback',acq_gui_data.ccpulseamp1,eventdata,acq_gui_data);
                    set(acq_gui_data.ccpulseamp2,'String','0');
                    acq_gui_data = Acq('ccpulseamp2_Callback',acq_gui_data.ccpulseamp2,eventdata,acq_gui_data);
                    acq_gui_data = Acq('update_cc_cell1_button_Callback',acq_gui_data.cell1_intrinsics,eventdata,acq_gui_data);
                    acq_gui_data = Acq('update_cc_cell2_button_Callback',acq_gui_data.cell2_intrinsics,eventdata,acq_gui_data);
            end
        end

    end
    user_confirm = msgbox('Please switch Multiclamp to VC with desired holding current. Rs is good?');
    waitfor(user_confirm)
end

% Handle response
switch clamp_choice1
    case 'Voltage Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',1)
%         set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 1;
    case 'Current Clamp'
        set(acq_gui_data.Cell1_type_popup,'Value',2)
%         set(acq_gui_data.Cell2_type_popup,'Value',2)
%         whole_cell = 1;
    case 'Cell Attached'
        set(acq_gui_data.Cell1_type_popup,'Value',3)
%         set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 0;
end

switch clamp_choice2
    case 'Voltage Clamp'
%         set(acq_gui_data.Cell1_type_popup,'Value',1)
        set(acq_gui_data.Cell2_type_popup,'Value',1)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 1;msaccept
    case 'Current Clamp'
%         set(acq_gui_data.Cell1_type_popup,'Value',2)
        set(acq_gui_data.Cell2_type_popup,'Value',2)
%         whole_cell = 1;
    case 'Cell Attached'
%         set(acq_gui_data.Cell1_type_popup,'Value',3)
        set(acq_gui_data.Cell2_type_popup,'Value',3)
        set(acq_gui_data.test_pulse,'Value',1)
%         whole_cell = 0;
end

guidata(hObject,handles);
guidata(acq_gui,acq_gui_data)