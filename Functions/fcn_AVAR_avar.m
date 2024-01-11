function allan_variance = fcn_AVAR_avar(data,list_of_correlation_intervals,...
                          varargin)
%% fcn_AVAR_avar
%   This function computes allan variance of regularly sampled data over 
%   correlation interval in 'list_of_correlation_intervals'. It uses normal 
%   algorithm.
%
% FORMAT:
%   allan_variance = fcn_AVAR_avar(data,list_of_correlation_intervals)
%
% INPUTS:
%   data: A N x 1 vector of data points.
%   list_of_correlation_intervals: A M x 1 vector containing list of 
%   correlation intervals.
%   varargin: figure number for debugging.
%
% OUTPUTS:
%   allan_variance: A M x 1 vector containing allan variance corresponding 
%   to the correlation intervals.
%
% EXAMPLES:
%   See the script:
%       script_test_fcn_AVAR_avar.m for a full test suite.
%
% This function was written on 2021_05_14 by Satya Prasad
% Questions or comments? szm888@psu.edu
% Updated: 2022/02/15

%% Calculate Allan Variance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% number of data points in the INPUT data
number_of_datapoints = numel(data);
% number of interested correlation intervals
number_of_correlation_intervals = numel(list_of_correlation_intervals);

% initialize variable to store allan variance
allan_variance = nan(number_of_correlation_intervals,1);
for i = 1:number_of_correlation_intervals
    % loop over the list of correlation intervals
    
    correlation_interval = list_of_correlation_intervals(i);
    allan_variance_sum = 0; % initialize Allan Variance sum to zero
    for m = 1:(number_of_datapoints-2*correlation_interval)
        allan_variance_sum = allan_variance_sum+...
            (mean(data((m+correlation_interval):(m+2*correlation_interval-1)))...
            -mean(data(m:(m+correlation_interval-1)))).^2;
    end
    % write Allan Variance to the output
    allan_variance(i) = 0.5*allan_variance_sum/...
                        (number_of_datapoints-2*correlation_interval);
end
end