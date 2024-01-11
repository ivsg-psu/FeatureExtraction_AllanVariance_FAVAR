function [output_data, output_weights] = ...
    fcn_AVAR_irregular2regularWeightedData(dependent_variable, ...
    independent_variable, decimation, min_independent_variable, ...
    max_independent_variable)
% fcn_AVAR_irregular2regularWeightedData
%   This function converts irregularly sampled data into regularly sampled
%   weighted data.
%
% FORMAT:
%   [output_data, output_weights] = ...
%       fcn_AVAR_irregular2regularWeightedData(dependent_variable, ...
%       independent_variable, decimation, min_independent_variable, ...
%       max_independent_variable)
%
% INPUTS:
%   dependent_variable: A Nx1 vector of dependent data points.
%   For example: white noise
%   independent_variable: A Nx1 vector of independent data points.
%   For example: time
%   decimation: Desired decimation of 'independent_variable'.
%   For example: sampling interval
%   min_independent_variable: Desired minimum value of
%   'independent_variable'. If the input is 'NaN' then
%   min_independent_variable = min(independent_variable);
%   max_independent_variable: Desired maximum value of
%   'independent_variable'. If the input is 'NaN' then
%   max_independent_variable = max(independent_variable);
%
% OUTPUTS:
%   output_data: A Px1 vector of averaged data. Usually P=N.
%   output_weights: A Px1 vector of weights.
%
% This function was written on 2022_02_08 by Satya Prasad
% Questions or comments? szm888@psu.edu
%

flag_do_debug = 0; % Flag to plot the results for debugging
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1, 'STARTING function: %s, in file: %s\n', st(1).name, st(1).file);
end

%% Check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _       
%  |_   _|                 | |      
%    | |  _ __  _ __  _   _| |_ ___ 
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |                  
%              |_| 
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_check_inputs
    % Are there the right number of inputs?
    if 5~=nargin
        error('Incorrect number of input arguments')
    end
    
    % Check the input type and domain
    try
        fcn_AVAR_checkInputsToFunctions(dependent_variable,'avar data');
    catch ME
        assert(strcmp(ME.message,...
            'The dependent_variable input must be a N x 1 vector of real numbers'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    try
        fcn_AVAR_checkInputsToFunctions(independent_variable,'time vector');
    catch ME
        assert(strcmp(ME.message,...
            'The independent_variable input must be a N x 1 vector of non-decreasing non-negative numbers'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    % Check the compatibility between 'dependent_variable' and 'independent_variable'
    if numel(dependent_variable)~=numel(independent_variable)
        error('The %s and %s input must be of same length', inputname(1), inputname(2));
    end
    try
        fcn_AVAR_checkInputsToFunctions(decimation,'positive');
    catch ME
        assert(strcmp(ME.message,...
            'The decimation input must be a positive number'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    if ~isnan(min_independent_variable)
        try
            fcn_AVAR_checkInputsToFunctions(min_independent_variable,'non negative');
        catch ME
            assert(strcmp(ME.message,...
                'The min_independent_variable input must be a non-negative number'));
            fprintf(1, '%s\n\n', ME.message)
            return;
        end
    end
    if ~isnan(max_independent_variable)
        try
            fcn_AVAR_checkInputsToFunctions(max_independent_variable,'positive');
        catch ME
            assert(strcmp(ME.message,...
                'The max_independent_variable input must be a positive number'));
            fprintf(1, '%s\n\n', ME.message)
            return;
        end
    end
end

%% Convert irregularly sampled data to regularly sampled weighted data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isnan(min_independent_variable)
    min_independent_variable = min(independent_variable);
end
if isnan(max_independent_variable)
    max_independent_variable = max(independent_variable);
end
reg_time_vector = (min_independent_variable:decimation:max_independent_variable)';

length_of_output_data = numel(reg_time_vector); % length of the output data
output_data    = nan(length_of_output_data,1); % initialize output data
output_weights = nan(length_of_output_data,1); % initialize output weights
for i = 1:length_of_output_data
    if i < length_of_output_data
        % `0' is replaced with `-1e-6' to avoid errors due to numerical precision
        temp_data = dependent_variable(independent_variable-reg_time_vector(i)>=-1e-6 & ...
                                       independent_variable-reg_time_vector(i+1)<-1e-6);
    else
        % `0' is replaced with `-1e-6' to avoid errors due to numerical precision
        temp_data = dependent_variable(independent_variable-reg_time_vector(i)>=-1e-6);
    end
    output_weights(i) = numel(temp_data);
    if isempty(temp_data)
        output_data(i) = 0;
    else
        output_data(i) = mean(temp_data);
    end
end % END: for loop over the all the input data

%% Any debugging?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _                 
%  |  __ \     | |                
%  | |  | | ___| |__  _   _  __ _ 
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_do_debug
    fprintf(1, 'ENDING function: %s, in file: %s\n\n', st(1).name, st(1).file);
end

end