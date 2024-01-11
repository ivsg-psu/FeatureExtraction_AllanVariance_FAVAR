function allan_variance = fcn_AVAR_avarI(data_x,data_t,...
                          list_of_correlation_time,sampling_interval,...
                          min_time,max_time,varargin)
%% coded by Hossein Haeri %%
%% please cite this paper if you used the code: https://ieeexplore.ieee.org/abstract/document/9268459 %%
%% the code estimates the Allan variance of irregularly sampled data (equation (6) in the paper)
% fcn_AVAR_avarI
%   This function computes allan variance of irregularly sampled data. It
%   uses the algorithm presented in the above paper.
%
% FORMAT:
%   allan_variance = fcn_AVAR_avarI(data_x,data_t,...
%                    list_of_correlation_time,...
%                    sampling_interval,min_time,...
%                    max_time)
%
% INPUTS:
%   data_x: A N x 1 vector of data points.
%   data_t: A N x 1 vector of data time stamps. It can't be NaN.
%   list_of_correlation_time: A M x 1 vector containing list of correlation 
%   time(s) which AVAR needs to be evaluated with.
%   sampling_interval: Decides coarseness of the data thereby in allan
%   variance.
%   min_time: Time at which data reception has started. It can be NaN.
%   max_time: Time at which data reception has ended. It can be NaN.
%   varargin: figure number for debugging.
%
% OUTPUTS:
%   allan_variance: A Mx1 vector of allan variance corresponding to each
%   correlation time in 'list_of_correlation_time'.
%
% EXAMPLES:
%   See the script:
%       script_test_fcn_AVAR_avarI.m and 
%       script_compare_fcn_AVAR_avarI_with_fcn_AVAR_avar.m for a full test suite.
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
    if 6>nargin || 7<nargin
        error('Incorrect number of input arguments')
    end
    
    % Check input type and domain
    try
        fcn_AVAR_checkInputsToFunctions(data_x,'avar data');
    catch ME
        assert(strcmp(ME.message,...
            'The data_x input must be a N x 1 vector of real numbers'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    try
        fcn_AVAR_checkInputsToFunctions(data_t,'time vector');
    catch ME
        assert(strcmp(ME.message,...
            'The data_t input must be a N x 1 vector of non-decreasing non-negative numbers'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    try
        fcn_AVAR_checkInputsToFunctions(list_of_correlation_time,'correlation time');
    catch ME
        assert(strcmp(ME.message,...
            'The list_of_correlation_time input must be a M x 1 vector of increasing positive numbers'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    try
        fcn_AVAR_checkInputsToFunctions(sampling_interval,'positive');
    catch ME
        assert(strcmp(ME.message,...
            'The sampling_interval input must be a positive number'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    if ~isnan(min_time)
        try
            fcn_AVAR_checkInputsToFunctions(min_time,'non negative');
        catch ME
            assert(strcmp(ME.message,...
                'The min_time input must be a non-negative number'));
            fprintf(1, '%s\n\n', ME.message)
            return;
        end
    end
    if ~isnan(max_time)
        try
            fcn_AVAR_checkInputsToFunctions(max_time,'positive');
        catch ME
            assert(strcmp(ME.message,...
                'The max_time input must be a positive number'));
            fprintf(1, '%s\n\n', ME.message)
            return;
        end
    end
end

% Does the user want to make a plot at the end?
if 7 == nargin
    fig_num = varargin{end};
    flag_do_plot = 1;
else
    if flag_do_debug
        fig = figure;
        fig_for_debug = fig.Number;
        flag_do_plot = 1;
    end
end

%% Calculate Allan Variance of irregularly sampled data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
number_of_correlation_time = numel(list_of_correlation_time);
if isnan(min_time)
    min_time = data_t(1);
end
if isnan(max_time)
    max_time = data_t(end);
end

% Initialize variable to store allan variance
allan_variance = nan(number_of_correlation_time,1);
% for each window length (tau) in tau_list
for tau_indx = 1:number_of_correlation_time
    correlation_time = list_of_correlation_time(tau_indx); % correlation time
    
    % store the weights accumulatively (this calculates the denominator in 
    % the equation (6) of the paper)
    total_weight = 0;
    
    % store the AVAR samples accumulatively across the time (this 
    % calculates the numerator in the equation (6) of the paper)
    allan_variance_sum = 0;
    
    % for each sliding time t
    for t = min_time:sampling_interval:max_time-2*correlation_time
        % extract data points which fall into the two adjacent windows 1 and 2
        % `0' is replaced with `-1e-6' to avoid errors due to numerical precision
        x_1 = data_x((data_t-t)>=-1e-6 & (data_t-(t+correlation_time))<-1e-6);
        x_2 = data_x((data_t-(t+correlation_time))>=-1e-6 & (data_t-(t+2*correlation_time))<-1e-6);
        
        % count how many points each window contains
        w_1 = numel(x_1);
        w_2 = numel(x_2);
        
        % calculate the weight
        weight = w_1*w_2;
        
        % compute average values of each window
        x_bar_1 = mean(x_1);
        x_bar_2 = mean(x_2);
        
        % if weight is nonzero then
        if ~(0==weight)
            % add the weighted squared difference of averages to allan_variance_sum
            allan_variance_sum = allan_variance_sum + weight*(x_bar_1-x_bar_2)^2;
            % keep track of total weights
            total_weight = total_weight + weight;
        end
    end
    % normalize expected value with respect of the weights
    allan_variance(tau_indx) = 0.5*allan_variance_sum/total_weight;
end

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
    plot(list_of_correlation_time,allan_variance,'b','Linewidth',1.2)
    grid on
    set(gca,'XScale','log','YScale','log','FontSize',13)
    ylabel('Allan Variance $[Unit^2]$','Interpreter','latex','FontSize',18)
    xlabel('Correlation Time $[s]$','Interpreter','latex','FontSize',18)
    title(figure_title,'Interpreter','latex','FontSize',18)
end

if flag_do_debug
    fprintf(1, 'ENDING function: %s, in file: %s\n\n', st(1).name, st(1).file);
end

end