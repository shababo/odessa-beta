function results = fit_pockels_curves(voltages,measurements)

results = zeros(size(measurements,1),2);


for i = 1:size(measurements,1)
    
    these_measurements = measurements(i,:);
    params_init = [max(these_measurements) pi/200/2];
    
    results(i,:) = fminsearch(@(x) pockels_fit_err(x,[voltages' these_measurements']), params_init);
    
end