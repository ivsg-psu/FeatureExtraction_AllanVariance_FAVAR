function dynamic_allan_variance = fcn_AVAR_dFavar(data,...
                                  list_of_correlation_intervals)
% fcn_AVAR_dFavar
%   This function computes dynamic allan variance of regularly sampled data 
%   'data' for all the correlation intervals in
%   'list_of_correlation_intervals'. It's a recursive algorithm over
%   correlation intervals.
%
% FORMAT:
%
%   dynamic_allan_variance = fcn_AVAR_dFavar(data,list_of_correlation_intervals)
%
% INPUTS:
%
%   data: A Nx1 vector of data points.
%   list_of_correlation_intervals: A Mx1 vector containing list of 
%   correlation intervals.
%
% OUTPUTS:
%
%   dynamic_allan_variance: A Mx1 vector containing dynamic allan varaince 
%   corresponding to the correlation intervals.
%
% EXAMPLES:
%
%   See the script:
%       script_compare_fcn_AVAR_dFavar_with_fcn_AVAR_favar.m for a full test suite.
%
% This function was written on 2021_05_15 by Satya Prasad
% Questions or comments? szm888@psu.edu
% Updated: 2022/02/15

persistent allan_variance
%% Calculate Dynamic Allan Variance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(allan_variance)
    % Initialization Step
    allan_variance = fcn_AVAR_favar(data, list_of_correlation_intervals); % Calculate allan variance
else
    % Recurring Step
    number_of_datapoints            = numel(data); % number of data points in the INPUT data
    % number of correlation intervals
    number_of_correlation_intervals = numel(list_of_correlation_intervals);
    
    for i = 1:number_of_correlation_intervals % loop over the list of correlation_intervals
        correlation_interval = list_of_correlation_intervals(i); % correlation_interval
        
        if 1 == correlation_interval
            sub_mean_back  = data(1);
            sub_mean_front = data(2);
            add_mean_front = data(end-1);
            add_mean_back  = data(end-2);
        else
            sub_mean_back  = 0.5*(sub_mean_front+sub_mean_back);
            sub_mean_front = mean(data(1+correlation_interval:2*correlation_interval));
            add_mean_front = 0.5*(add_mean_front+add_mean_back);
            add_mean_back  = mean(data(end-2*correlation_interval:end-correlation_interval-1));
        end
        change_in_allan_variance = 0.5*((add_mean_front-add_mean_back)^2 - ...
                                        (sub_mean_front-sub_mean_back)^2)/ ...
                                        (number_of_datapoints-2*correlation_interval-1);
        
        allan_variance(i) = allan_variance(i)+change_in_allan_variance;
    end % END: For loop over correlation_intervals
end
dynamic_allan_variance = allan_variance;
end