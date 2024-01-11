function dynamic_allan_variance = fcn_AVAR_dFavarI(data,weights,...
                                  list_of_correlation_intervals)
% fcn_AVAR_dFavarI
%   This function computes dynamic allan variance of irregularly sampled 
%   data 'data' for all the correlation intervals in 
%   'list_of_correlation_intervals'
%
% FORMAT:
%
%   dynamic_allan_variance = fcn_AVAR_dFavarI(data,weights,...
%                            list_of_correlation_intervals)
%
% INPUTS:
%
%   data: A Nx1 vector of data points. It contains weighted average of data
%   in a sampling interval.
%   weights: A Nx1 vector containing weights for the 'data'.
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
%       script_compare_fcn_AVAR_dFavarI_with_fcn_AVAR_favarI.m for a full test suite.
%
% This function was written on 2021_05_15 by Satya Prasad
% Questions or comments? szm888@psu.edu
% Updated: 2022/02/15

persistent allan_variance total_weights
%% Calculate Dynamic Allan Variance of irregularly sampled data
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
    [allan_variance, total_weights] = fcn_AVAR_favarI(data,weights,....
        list_of_correlation_intervals); % Calculate allan variance
else
    % Recurring Step
    number_of_correlation_intervals = numel(list_of_correlation_intervals); % number of correlation intervals
    
    for i = 1:number_of_correlation_intervals
        % loop over the list of correlation_intervals
        correlation_interval = list_of_correlation_intervals(i); % correlation_interval
        
        if 1 == correlation_interval
            sub_weight_back = weights(1);
            sub_mean_back   = data(1);
            
            sub_weight_front = weights(2);
            sub_mean_front   = data(2);
            
            add_weight_front = weights(end-1);
            add_mean_front   = data(end-1);
            
            add_weight_back = weights(end-2);
            add_mean_back   = data(end-2);
        else
            sub_sum_back    = sub_weight_front*sub_mean_front+sub_weight_back*sub_mean_back;
            sub_weight_back = sub_weight_front+sub_weight_back;
            if 0 ~= sub_weight_back
                sub_mean_back = sub_sum_back/sub_weight_back;
            else
                sub_mean_back = 0;
            end
            
            sub_sum_front    = sum(weights(1+correlation_interval:2*correlation_interval).* ...
                                   data(1+correlation_interval:2*correlation_interval));
            sub_weight_front = sum(weights(1+correlation_interval:2*correlation_interval));
            if 0 ~= sub_weight_front
                sub_mean_front = sub_sum_front/sub_weight_front;
            else
                sub_mean_front = 0;
            end
            
            add_sum_front    = add_weight_front*add_mean_front+add_weight_back*add_mean_back;
            add_weight_front = add_weight_front+add_weight_back;
            if 0 ~= add_weight_front
                add_mean_front = add_sum_front/add_weight_front;
            else
                add_mean_front = 0;
            end
            
            add_sum_back    = sum(weights(end-2*correlation_interval:end-correlation_interval-1).* ...
                                  data(end-2*correlation_interval:end-correlation_interval-1));
            add_weight_back = sum(weights(end-2*correlation_interval:end-correlation_interval-1));
            if 0 ~= add_weight_back
                add_mean_back = add_sum_back/add_weight_back;
            else
                add_mean_back = 0;
            end
        end
        total_weight = total_weights(i)-...
                       sub_weight_front*sub_weight_back+...
                       add_weight_front*add_weight_back;
        change_in_allan_variance = 0.5*(add_weight_front*add_weight_back*(add_mean_front-add_mean_back)^2 - ...
                                        sub_weight_front*sub_weight_back*(sub_mean_front-sub_mean_back)^2);
        
        allan_variance(i) = (total_weights(i)*allan_variance(i)+...
                             change_in_allan_variance)/total_weight;
        total_weights(i)  = total_weight;
    end
end
dynamic_allan_variance = allan_variance;
end