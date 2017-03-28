function [amplifierOkay] = checkamplifier(amplifierInfo,amplifierIdx)
% function [amplifierOkay] = checkamplifier(amplifierInfo,amplifierIdx)
%
% Checks that amplifier settings are okay. In the case a Multiclamp
% amplifier is used, also checks that the amplifier can be deteced.
%
% INPUTS
% amplifierInfo:    information about available amplifier settings,
%                   including input/output scaling (e.g., V/pA, V/mV); 
%                   these numbers come from hardwareGUI.m 
% amplifierIdx:     indices to the amplifier settings each of the four DAQ
%                   channels uses
%
% OUTPUTS
% amplifierOkay:     true or false   (amplifier)

global DAQPARS

amplifierOkay = true;

if isempty(amplifierInfo)
    amplifierInfo = DAQPARS.amplifierInfo;
    amplifierIdx = DAQPARS.amplifierIdx;
end

ampIdx = unique(amplifierIdx);

for ii = 1:numel(ampIdx)
    
    ampInfo = amplifierInfo(ampIdx(ii));
    
    % For manual configurations, just check that all the numbers
    % are greater than zero.
    if (ampInfo.detected==0)
        
        scalingNames = fieldnames(ampInfo);
        for jj = 1:numel(scalingNames)
            fname = scalingNames{jj};
            if strcmp(fname,'name') || strcmp(fname,'detected')
                continue
            end
            scaling = ampInfo.(fname);
            if scaling<=0
                amplifierOkay = false;
                disp('One of the manual scaling factors is <= 0.')
            end
        end     
        
    % For automatic (detected) configurations, check that we can
    % communicate with the amplifier.
    else
        
        try % this one is only for Multiclamp
        
            model700 = ampInfo.name(6); % 'A' or 'B'
            slashLoc = strfind(ampInfo.name,'_');
            hardwareType = ['MultiClamp ',...
                ampInfo.name(slashLoc(1)-4:slashLoc(1)-1)];
            if strcmp(model700,'A')
                startID = strfind(ampInfo.name,'COM')+3;
                amplifierID = str2double(ampInfo.name(startID:end)); % COM port
            else
                amplifierID = ampInfo.name(slashLoc(2)+1:end); % Serial No
            end
            
            % start messaging session and get ids
            MulticlampTelegraph('start')
            ids = MulticlampTelegraph('getAllElectrodeIDs');
            
            amplifierFound = false;
            for jj = 1:numel(ids)
                r = MulticlampTelegraph('getElectrodeState',ids(jj));
                if strcmp(model700,'A')                
                    if strcmp(r.HardwareType,hardwareType) ...
                            && (r.ComPortID==amplifierID)
                        amplifierFound = true;
                    end
                else
                    r.SerialNumber = strtok(r.SerialNumber);
                    if strcmp(r.HardwareType,hardwareType) ...
                            && strcmp(r.SerialNumber,amplifierID)
                        amplifierFound = true;
                    end
                end
                if amplifierFound
                    break
                end
            end
            
            if ~amplifierFound
                amplifierOkay = false;
                disp('Multiclamp amplifier or Commander not found.')
            end
            
            
        catch
            
            amplifierOkay = false;
            disp('Multiclamp amplifier or Commander not found.')
            
        end
        
    end
    
end

if amplifierOkay    
    DAQPARS.amplifierInfo = amplifierInfo;
    DAQPARS.amplifierIdx = amplifierIdx;
end