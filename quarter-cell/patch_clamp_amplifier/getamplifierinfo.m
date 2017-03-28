function amplifierInfo = getamplifierinfo(hardwareConfiguration)
% function amplifierInfo = getamplifierinfo(hardwareConfiguration)
%
% Outputs are divided by the scaling numbers before being sent
% to the amplifier. Inputs are divided by the scaling numbers, as well as
% by the amplifier gains, before being plotted or saved to disk. 
%
% In current clamp and voltage clamp, currents are always in pA and 
% voltages are always in mV. This is why, for example, the default input
% scaling for current clamp is 1000 (700A) rather than 1. 
%
% The first entries in amplifierInfo are comprised of data obtained
% directly from an attached amplifier (e.g., the scaling values of the two
% channels of a Multiclamp amplifier). The last four entries are
% manually-entered parameters.
%
% INPUTS:
% hardwareConfiguration:    name of the file in which the hardware
%                           configuration settings are saved
%
% OUTPUTS:
% amplifierInfo:            information (e.g., scaling values) about
%                           amplifiers entered manually or obtained
%                           directly from the amplifier (Multiclamp only)

amplifierInfoDetected = [];

try
    
    warning off %#ok<*WNOFF>    % no need for warning message
                                % if there is no Multiclamp

    amplifierInfoDetected = getmulticlampinfo([]);
    
    warning on %#ok<*WNON>
   
catch
    
    % No amplifier was detected, leaving only default/manual values.
    
end

if exist(hardwareConfiguration,'file')  % check if user has entered
                                        % amplifier information previously

    load(hardwareConfiguration,'amplifierInfo')
    
    % remove saved information about attached amplifiers
    % will replace with amplifierInfoDetected obtained above
    amplifierInfo([amplifierInfo.detected]) = []; %#ok<NODEF>
    

else                                    % otherwise just use defaults

    amplifierInfo.name = 'Manual 1';
    amplifierInfo.outputScalingVoltageClamp = 20;
    amplifierInfo.outputScalingCurrentClamp = 400;
    amplifierInfo.outputScalingOther = 1;
    amplifierInfo.inputScalingVoltageClamp = 2000;
    amplifierInfo.inputScalingCurrentClamp = 1000;
    amplifierInfo.inputScalingOther = 1;
    amplifierInfo.detected = false;
    amplifierInfo(2:4) = amplifierInfo;
    amplifierInfo(2).name = 'Manual 2';
    amplifierInfo(3).name = 'Manual 3';
    amplifierInfo(4).name = 'Manual 4';

end


amplifierInfo = [amplifierInfoDetected, amplifierInfo];



