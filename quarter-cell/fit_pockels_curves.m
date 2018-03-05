function results = fit_pockels_curves(voltages,measurements)

results = zeros(size(measurements,1),3);


for i = 1:size(measurements,1)
    
    these_measurements = measurements(i,:);
    params_init = [max(these_measurements) pi/100/2 min(these_measurements)];
    results(i,:) = fmincon(@(x) pockels_fit_err(x,[voltages' these_measurements']), params_init,[],[],[],[],[min(these_measurements)-2 .5 5],[max(these_measurements)+10 1.5 20])
%     results(i,:) = fminsearch(@(x) pockels_fit_err(x,[voltages' these_measurements']), params_init);
    
end