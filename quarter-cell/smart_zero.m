function [ zeroed_trace ] = smart_zero( trace,handles )
% Finds period of least variance in the baseline of a trace and uses that
% period to subtract off the mean


% convert limits in seconds into limits in samples
% leftlimit = leftlimit*handles.defaults.Fs;
% rightlimit = rightlimit*Exp_Deafults.Fs;

% extract baseline portion to average, usually half to one second
% baseline = trace(1); 
% 
% % break baseline into 20 50-ms segments and analyze the variance
% 
% var_vector = zeros(1,15);
% 
% for i=1:15
%     temp = baseline((i*(handles.defaults.Fs/20):((i+1)*(handles.defaults.Fs/20)-1)));
%     var_vector(i) = var(temp); 
% end
% % find which segment has the lowest variance
% min_var_segment = find(var_vector==min(var_vector));
% 
% % compute the mean value of the least variable segment
% newbaseline = baseline(round((min_var_segment*0.05*handles.defaults.Fs)):round((min_var_segment+1)*0.05*handles.defaults.Fs));
% DCoffset = mean(newbaseline);
% zeroed_trace = trace-DCoffset;  
zeroed_trace = trace - trace(1);
end

