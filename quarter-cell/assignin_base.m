function assignin_base(names,vars)

for i = 1:length(names)
    assignin('base',names{i},vars{i});
end