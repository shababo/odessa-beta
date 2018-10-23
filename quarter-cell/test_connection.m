function [experiment_setup, handles] = test_connection(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup)

ch1_pre = 0;
ch2_pre = 0;

choice = questdlg('Which direction to test?', 'Test direction?', ...
	'1>2','2>1','both','2>1');
% Handle response
switch choice
    case '1>2'
        ch1_pre = 1;
        ch2_pre = 0;
    case '2>1'
        ch1_pre = 0;
        ch2_pre = 1;
    case 'both'
        ch1_pre = 1;
        ch2_pre = 1;
end

experiment_setup.ch1_pre = ch1_pre;
experiment_setup.ch2_pre = ch2_pre;

loose_patch_pre = 0;

choice = questdlg('What type of patch for presynpatic cell?', ...
    'What type of patch for presynpatic cell?', ...
	'whole','loose','whole');
% Handle response
switch choice
    case 'whole'
        loose_patch_pre = 0;
    case 'loose'
        loose_patch_pre = 1;
end

experiment_setup.loose_patch_pre = loose_patch_pre;

if experiment_setup.loose_patch_pre
    [experiment_setup, handles] = test_connection_optical(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
else 
    [experiment_setup, handles] = test_connection_ephys(hObject,eventdata,handles,acq_gui,acq_gui_data,experiment_setup);
end

waitfor(experiment_setup.datafig)
experiment_setup.abort = 1;

choice = questdlg('Continue experiment or abort?', ...
    'Continue experiment or abort?', ...
	'continue','abort','continue');
% Handle response
switch choice
    case 'continue'
        experiment_setup.abort = 0;
    case 'abort'
        experiment_setup.abort = 1;
end

