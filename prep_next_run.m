function [batch_found, experiment_query, neighbourhood] = ...
                prep_next_run(experiment_setup,neighbourhoods,handles,varargin)

[batch_found,neighbourhood_ID] = check_for_batch(experiment_setup,neighbourhoods);

if batch_found
    neighbourhood = neighbourhoods([neighbourhoods.neighbourhood_ID]  ==  neighbourhood_ID);
    if experiment_setup.is_exp
        [experiment_query, neighbourhood] = load_phase_masks(experiment_setup,neighbourhood,handles,varargin{:});
        if isempty(experiment_query)
            batch_found = 0;
        end
    else
        % load batch from file here
        batchfile = [experiment_setup.analysis_root experiment_setup.exp_id ...
            '_n' num2str(neighbourhood.neighbourhood_ID)...
            '_b' num2str(neighbourhood.batch_ID + 1) '_to_acquisition.mat'];
        load(batchfile,'experiment_query','neighbourhood')
    end
else
    experiment_query = [];
    neighbourhood = [];
end