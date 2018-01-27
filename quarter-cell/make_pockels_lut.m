function lut = make_pockels_lut(pockels_data,voltages,savename)

pockels_fit = fit_pockels_curves(pockels_data(:,1)',pockels_data(:,2)')
lut = sin_sq(voltages,pockels_fit);
lut = [voltages; lut];
if ~isempty(savename)
    save(savename,'lut')
end