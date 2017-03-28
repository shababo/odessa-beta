function [] = updateamplifier
% function [] = updateamplifier
%
% Uses MulticlampControl.exe to change the mode (voltage clamp or current
% clamp), gain, and offset (holding potential in voltage clamp or holding
% current in current clamp).
%
% Also uses MulticlampTelegraph (Wavesurfer, Janelia,
% wavesurfer.janelia.org) to check that the amplifier is present.
%
% Last modified: 07/19/16 (NSD)

global DAQPARS

MulticlampTelegraph('start')
ids = MulticlampTelegraph('getAllElectrodeIDs');
MulticlampTelegraph('stop')
if isempty(ids)
    disp('No amplifier found');
    return
end

% switch to folder containingMulticlampControl.exe
oldFolder = ...
    cd([DAQPARS.daqFolder,'\patch_clamp_amplifier\MulticlampControl\Debug']);

foo = DAQPARS.amplifierInfo(DAQPARS.amplifierIdx);
boo = 0;
for iCount = 1:DAQPARS.nChannels
    if strcmp(DAQPARS.status{iCount},'off') % channel turned off
        continue
    end
    if foo(iCount).detected==0 || ~strcmp(foo(iCount).name(1:5),'MC700')
        continue
    end
    
    boo = boo + 1;
    
    if strcmp(foo(iCount).name(6),'A')
        model = 0; % 700A
        startID = strfind(foo(iCount).name,'COM')+3;
        amplifierID = foo(iCount).name(startID:end); % COM port
        channelLoc = strfind(foo(iCount).name,'ch')+2;
        channelID = foo(iCount).name(channelLoc(1));
    else
        model = 1; % 700B
        startID = strfind(foo(iCount).name,'_');
        startID = startID(2)+1;
        amplifierID = foo(iCount).name(startID:end); % Serial number
        channelLoc = strfind(foo(iCount).name,'ch')+2;
        channelID = foo(iCount).name(channelLoc(1));        
    end
    
    gain = num2str(DAQPARS.gain(iCount));
    offset = num2str(DAQPARS.offset(iCount));
    
    switch DAQPARS.status{iCount}
        case 'voltage clamp'
            
            cmd = ['MulticlampControl.exe ',num2str(model),' ',...
                amplifierID,' ',channelID,' 3 ',gain,' ',offset];
            
        case 'current clamp'
            
            % setting the bridge and cap comp to 10000 means that they will
            % not be changed from whatever they already are
            cmd = ['MulticlampControl.exe ',num2str(model),' ',...
                amplifierID,' ',channelID,' 2 ',gain,' 10000 10000 ',offset];
                    
            
        case 'field potential'
            
            cmd = ['MulticlampControl.exe ',num2str(model),' ',...
                amplifierID,' ',channelID,' 6 ',gain];
            
            
        otherwise % do nothing
           
            cmd = [];
    end
    
    if ~isempty(cmd)
        [status,result] = system(cmd); %#ok<ASGLU>
    end
    
end

% switch back to original folder
cd(oldFolder)



