function neighbourhoods = create_neighbourhoods_caller(experiment_setup)

do_build_neighbourhooods = 1;
if experiment_setup.enable_user_breaks
    choice = questdlg('Compute Cell Groups and Optimal Targets?', ...
        'Compute Cell Groups and Optimal Targets?', ...
        'Yes','No','Yes');
    % Handle response
    switch choice
        case 'Yes'
            do_build_neighbourhooods = 1;
            choice = questdlg('Continue user control?',...
                'Continue user control?', ...
                'Yes','No','Yes');
            % Handle response
            switch choice
                case 'Yes'
                    experiment_setup.enable_user_breaks = 1;
                case 'No'
                    experiment_setup.enable_user_breaks = 0;
            end
        case 'No'
            do_build_neighbourhooods = 0;
    end
end


if do_build_neighbourhooods

    disp('computing neighbourhoods...')

    neighbourhoods = create_neighbourhoods(experiment_setup);

end