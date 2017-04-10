function assignin_base(varargin)

for i = 1:length(varargin)
    assignin('base',vname(varargin{i}),varargin{i});
end

function vname_string = vname(var)

vname_string = inputname(1);
            