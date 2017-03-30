function [output, timebase] = makepulseoutputs(start_time, pulsenumber, pulseduration, pulseamp ,pulsefrequency, Fs, trial_length)
% Generates the analog output waveform for the LED or other analog device

%create the LED output wave
% make LEDoutput vector so that is has the right number of sampling points 
% which must be the same as test pulse
% note that the number of points in the analog outputs vectors actaully
% determines the number of points in the analog input vectors
% trial_length_samp = round();
timebase = linspace(0,trial_length - 1/Fs,Fs*trial_length)';
output = zeros(size(timebase));%linspace(0,0,ceilFs*trial_length)'; 
if all(pulseamp == 0)
    return
end
starttime = start_time*Fs + 1; % convert from seconds to points

if numel(pulseamp) < pulsenumber;
    pulseamp(1:pulsenumber) = pulseamp(1);
end

for i = 1:pulsenumber
    endtime = starttime + pulseduration*Fs - 1;
    if endtime > length(output)
        endtime = length(output);
    end
    starttime = round(starttime)
    endtime = round(endtime)
    output(starttime:endtime) = pulseamp(i);
    starttime = starttime + 1/pulsefrequency*Fs;
    if starttime > length(output)
        break
    end
end

output((length(output)-10):end)=0; % always set last 10 points to 0 to prevent LED from staying on
    
end

