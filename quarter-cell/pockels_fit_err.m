function err = pockels_fit_err(params,data)

err = 0;

for i = 1:size(data,1)
    
    err = err + (data(i,2) - (params(1) * sin(params(2) * data(i,1))^2))^2;

end