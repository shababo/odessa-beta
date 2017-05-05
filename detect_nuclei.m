function nuclear_locs = detect_nuclei(filename)

peak_detection_12(filename);
load([filename '.mat'])
params_em_reduce = filter_nuclear_detection(params_em,35);
nuclear_locs = params_em_reduce([2 3 4],:);