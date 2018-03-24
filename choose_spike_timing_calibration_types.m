function spike_prot_choices = choose_spike_timing_calibration_types


handles_sub.f = figure('Visible','off','Position',[300 300 190 220]);

% Create options via checkboxes
handles_sub.checkboxes.power_check = uicontrol(handles_sub.f,'Style','checkbox',...
                'String','Power',...
                'Value',0,'Position',[30 180 130 20]);
            
handles_sub.checkboxes.radial_vert_check = uicontrol(handles_sub.f,'Style','checkbox',...
                'String','Radial, Vertical',...
                'Value',0,'Position',[30 140 130 20]);
            
handles_sub.checkboxes.radial_horiz_check = uicontrol(handles_sub.f,'Style','checkbox',...
                'String','Radial, Horizontal',...
                'Value',0,'Position',[30 100 130 20]);
            
handles_sub.checkboxes.axial_check = uicontrol(handles_sub.f,'Style','checkbox',...
                'String','Axial',...
                'Value',0,'Position',[30 60 130 20]);

handles_sub.checkboxes.ready_button = uicontrol(handles_sub.f,'Style','pushbutton','String','Continue',...
                'Position',[30 20 130 20],'Callback',@choose_spike_prots);

set(handles_sub.f,'Visible','on')

handles_sub.ready = 0;
            
	%ready callback
    function choose_spike_prots(source, eventdata)

        handles_sub.ready = 1;
        
    end

while ~handles_sub.ready
    pause(1)
end

spike_prot_choices.do_spike_power = get(handles_sub.checkboxes.power_check,'Value');
spike_prot_choices.do_radial_vert = get(handles_sub.checkboxes.radial_vert_check,'Value');
spike_prot_choices.do_radial_horiz = get(handles_sub.checkboxes.radial_horiz_check,'Value');
spike_prot_choices.do_axial = get(handles_sub.checkboxes.axial_check,'Value');

close(handles_sub.f)
               
end
            
            
            
            
   