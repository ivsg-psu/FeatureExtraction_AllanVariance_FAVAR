function [allan_variance,total_weights] = fcn_AVAR_favarI(data,weights,...
                                          list_of_correlation_intervals,...
                                          varargin)
%% fcn_AVAR_favarI
%   This function computes allan variance of irregularly sampled data 'data' 
%   for all the correlation intervals in 'list_of_correlation_intervals'.
%   It uses a recursive algorithm, inspired from FFT, over simple averages 
%   along correlation intervals.
%
% FORMAT:
%   allan_variance = fcn_AVAR_favarI(data,weights,list_of_correlation_intervals)
%
% INPUTS:
%   data: A Nx1 vector of data points. It contains weighted average of data
%   in a sampling interval.
%   weights: A Nx1 vector containing weights for the data.
%   list_of_correlation_intervals: A Mx1 vector containing list of 
%   correlation intervals. Correlation intervals must be in increasing
%   order and also power of 2.
%   varargin: figure number for debugging.
%
% OUTPUTS:
%   allan_variance: A Mx1 vector containing allan varaince corresponding to 
%   the correlation intervals.
%   total_weights: A Mx1 vector containing total weights or the
%   denominator in the allan variance calculation.
%
% EXAMPLES:
%   See the script:
%       script_test_fcn_AVAR_favarI and 
%       script_compare_fcn_AVAR_favarI_with_fcn_AVAR_avarI.m for a full test suite.
%
% This function was written on 2021_05_15 by Satya Prasad
% Questions or comments? szm888@psu.edu
% Updated: 2022/02/15

flag_do_debug = 0; % Flag to plot the results for debugging
flag_do_plot  = 0; % Flag to plot the results
flag_check_inputs = 0; % Flag to perform input checking

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
    if 3>nargin || 4<nargin
        error('Incorrect number of input arguments')
    end
    
    % Check the input type and domain
    try
        fcn_AVAR_checkInputsToFunctions(data,'favar dataT');
    catch ME
        assert(strcmp(ME.message,...
            'The data input must be a N x 1 vector of real numbers, where N >= 5'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    try
        fcn_AVAR_checkInputsToFunctions(weights,'favar weightsT');
    catch ME
        assert(strcmp(ME.message,...
            'The weights input must be a N x 1 vector of non-negative numbers, where N >= 5'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    try
        fcn_AVAR_checkInputsToFunctions(list_of_correlation_intervals,'favar interval');
    catch ME
        assert(strcmp(ME.message,...
            'The list_of_correlation_intervals input must be a M x 1 vector of increasing numbers of form 2^p (p >= 0)'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
end

% Does the user want to make a plot at the end?
if 4 == nargin
    fig_num = varargin{end};
    flag_do_plot = 1;
else
    if flag_do_debug
        fig = figure;
        fig_for_debug = fig.Number;
        flag_do_plot = 1;
    end
end

p = min(floor(log2(numel(data)-1)), floor(log2(numel(weights)-1)));
if 2^p+1 ~= numel(data) || 2^p+1 ~= numel(weights)
    data = data(1:2^p+1);
    weights = weights(1:2^p+1);
    list_of_correlation_intervals = 2.^(0:p-2)';
    warning('Data and weights are trimmed to the nearest power of 2 before estimating AVAR using FAVAR.')
end
%% Calculate Allan Variance of irregularly sampled data using FAVAR
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

% intialize vector of weights with 'weights'
vector_of_weights = weights(1:(number_of_datapoints-1));
vector_of_means   = data(1:(number_of_datapoints-1)); % intialize vector of means with 'data'
length_of_vector_of_means = numel(vector_of_means); % length of vector_of_means

% initialize variable to store allan variance
allan_variance = nan(number_of_correlation_intervals,1);
% initialize variable to store total weights
total_weights  = nan(number_of_correlation_intervals,1);
for i = 1:number_of_correlation_intervals % loop over the list of correlation_intervals
    correlation_interval = list_of_correlation_intervals(i); % correlation_interval
    
    if 1~=correlation_interval
        vector_of_sums    = vector_of_weights(1:(length_of_vector_of_means-correlation_interval/2)).* ...
                            vector_of_means(1:(length_of_vector_of_means-correlation_interval/2))+...
                            vector_of_weights((1+correlation_interval/2):length_of_vector_of_means).* ...
                            vector_of_means((1+correlation_interval/2):length_of_vector_of_means);
        vector_of_weights = vector_of_weights(1:(length_of_vector_of_means-correlation_interval/2)) + ...
                            vector_of_weights((1+correlation_interval/2):length_of_vector_of_means);
        temp_vector_of_weights = vector_of_weights;
        % zeros are replaced with one in the temporary varaible to avoid division by zero
        temp_vector_of_weights(0==vector_of_weights) = 1;
        vector_of_means   = vector_of_sums./temp_vector_of_weights; % Recurring step
        length_of_vector_of_means = numel(vector_of_means); % length of vector_of_means
    end
    
    vector_of_weights_front = vector_of_weights((1+correlation_interval):length_of_vector_of_means);
    vector_of_means_front   = vector_of_means((1+correlation_interval):length_of_vector_of_means);
    vector_of_weights_back  = vector_of_weights(1:(length_of_vector_of_means-correlation_interval));
    vector_of_means_back    = vector_of_means(1:(length_of_vector_of_means-correlation_interval));
    
    product_of_weights  = vector_of_weights_front.*vector_of_weights_back;
    difference_of_means = vector_of_means_front-vector_of_means_back;
    allan_variance_sum  = sum(product_of_weights.*(difference_of_means.^2));
    
    total_weights(i)  = sum(product_of_weights);
    allan_variance(i) = 0.5*allan_variance_sum/total_weights(i); % write Allan Variance to the output
end % END: For loop over correlation_intervals

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
if flag_do_plot
    figure_title = inputname(1);
    figure_title('_' == figure_title) = ' ';
    figure(fig_num)
    clf
    width = 540; height = 400; right = 100; bottom = 400;
    set(gcf, 'position', [right, bottom, width, height])
    plot(list_of_correlation_intervals,allan_variance,'b','Linewidth',1.2)
    grid on
    set(gca,'XScale','log','YScale','log','FontSize',13)
    ylabel('Allan Variance $[Unit^2]$','Interpreter','latex','FontSize',18)
    xlabel('Correlation Interval [Number of Samples]','Interpreter','latex','FontSize',18)
    title(figure_title,'Interpreter','latex','FontSize',18)
end

if flag_do_debug
    fprintf(1, 'ENDING function: %s, in file: %s\n\n', st(1).name, st(1).file);
end

end