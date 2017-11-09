
function [ filtered_sweep ] = highpass_filter(inputsweep,Fs)
% This function implements a forwards and backwards butterwoth filter
% following UltraMegaSort2000 (Kleinfeld lab)
disp('boop')
Wp = [ 200 4000] * 2 / Fs; % pass band for filtering
Ws = [ 150 5000] * 2 / Fs; % transition zone
[N,Wn] = buttord( Wp, Ws, 3, 20); % determine filter parameters
[B,A] = butter(N,Wn); % builds filter
filtered_sweep = filtfilt( B, A, inputsweep ); % runs filter


end

