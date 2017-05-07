function nuclear_locs = detect_nuclei(filename)

peak_detection_12(filename);
load([filename '.mat'])
% params_em_reduce = filter_nuclear_detection(params_em,35);
params_em_reduce = params_em;
nuclear_locs = params_em_reduce([2 3 4],:);
nuclear_locs([1 2],:) = (nuclear_locs([1 2],:) - 129)*1.82;
nuclear_locs([3],:) = nuclear_locs([3],:)*2.0;

out_of_range = find(abs(nuclear_locs(1,:)) > 150 | ...
                    abs(nuclear_locs(2,:)) > 150);
nuclear_locs(:,out_of_range) = [];
nuclear_locs = nuclear_locs';
nuclear_locs(:,[1 2]) = nuclear_locs(:,[2 1]);