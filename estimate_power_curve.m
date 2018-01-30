function [power_ests, volt_in] = estimate_power_curve(power_measure, stim_data, first_measure, interstim, stim_length, num_meas)

% power_measure = power_measure - mean(power_measure(1:250));
% power_measure = power_measure - mean(power_measure(1:400));
% power_measure(stim_data < stim_thresh) = 0;
% first_measure = find(power_measure,1,'first')
window_length = .750*500;
% first_measure = first_measure + (1.0+stim_length*500;

i = first_measure;
% side = sqrt(1089);
power_ests = zeros(num_meas,1);
volt_in = zeros(num_meas,1);
for ii = 1:num_meas
%     ii

% while any(power_measure(i:end) > 0)
%     i
%     i*2
    end_i = i + window_length;
    if end_i > length(power_measure)
        end_i = length(power_measure);
    end
    power_ests(ii) = mean(power_measure(i:end_i));
    volt_in(ii) = mean(stim_data(i:end_i));
%     power_ests(ii,j) = this_est; %[power_ests this_est];
    i = i + interstim + stim_length ;
    
end
% end

% power_map = power_ests;

