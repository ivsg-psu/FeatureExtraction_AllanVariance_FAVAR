function allan_variance = fcn_AVAR_favar(data,list_of_correlation_intervals,...
                          varargin)
%% fcn_AVAR_favar
%   This function computes allan variance of regularly sampled data 'data'
%   for all the correlation intervals in 'list_of_correlation_intervals'.
%   It uses a recursive algorithm, inspired from FFT, over simple averages 
%   along correlation intervals.
%
% FORMAT:
%   allan_variance = fcn_AVAR_favar(data,list_of_correlation_intervals)
%
% INPUTS:
%   data: A Nx1 vector of data points. N should be of form 2^p+1 (p >= 2).
%   list_of_correlation_intervals: A Mx1 vector containing list of 
%   correlation intervals. Each interval must be of the form 2^p (p >= 1).
%   varargin: figure number for debugging.
%
% OUTPUTS:
%   allan_variance: A Mx1 vector containing allan variance corresponding to 
%   the correlation intervals.
%
% EXAMPLES:
%   See the script:
%       script_test_fcn_AVAR_favar.m and 
%       script_compare_fcn_AVAR_favar_with_fcn_AVAR_avar.m 
%       for a full test suite.
%
% This function was written on 2021_05_15 by Satya Prasad
% Questions or comments? szm888@psu.edu
% Updated: 2022/02/15

%% Calculate Allan Variance using FAVAR
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
number_of_datapoints            = numel(data);
% number of correlation intervals
number_of_correlation_intervals = numel(list_of_correlation_intervals);

vector_of_means = data(1:number_of_datapoints-1); % intialize vector of means with the data
length_of_vector_of_means = numel(vector_of_means); % length of vector_of_means

% initialize variable to store allan variance
allan_variance = nan(number_of_correlation_intervals, 1);
for i = 1:number_of_correlation_intervals  % loop over the list of correlation_intervals
    correlation_interval = list_of_correlation_intervals(i); % correlation_interval
    
    % Recurring step
    if 1~=correlation_interval
        vector_of_means = 0.5*(vector_of_means(1:(length_of_vector_of_means-correlation_interval/2))+...
                               vector_of_means((1+correlation_interval/2):length_of_vector_of_means));
        length_of_vector_of_means = numel(vector_of_means); % length of vector_of_means
    end
    vector_of_means_front = vector_of_means((1+correlation_interval):length_of_vector_of_means);
    vector_of_means_back  = vector_of_means(1:(length_of_vector_of_means-correlation_interval));
    
    allan_variance_sum = sum((vector_of_means_front-vector_of_means_back).^2);
    
    % write Allan Variance to the output
    allan_variance(i) = 0.5*allan_variance_sum/...
                        (number_of_datapoints-2*correlation_interval);
end % END: For loop over correlation_intervals
end