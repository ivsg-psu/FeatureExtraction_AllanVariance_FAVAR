function white_noise = fcn_AVAR_generateWhiteNoise(power_spectral_density,...
                       sampling_frequency,number_of_time_steps,varargin)
%% fcn_AVAR_generateWhiteNoise
%   This function generates white noise characterized by
%   'power_spectral_density'.
%
% FORMAT:
%   white_noise = fcn_AVAR_generateWhiteNoise(power_spectral_density,...
%                 sampling_frequency,number_of_time_steps)
%
% INPUTS:
%   power_spectral_density: Power spectral density of white noise [unit^2 s].
%   sampling_frequency: Sampling frequency of the output [Hz].
%   number_of_time_steps: Desired length of output.
%   varargin: figure number for debugging.
%
% OUTPUTS:
%   white_noise: A 'number_of_time_steps x 1' vector of white noise.
%
% EXAMPLES:
%   See the script:
%       script_test_fcn_AVAR_generateWhiteNoise.m for a full test suite.
%
% This function was written on 2021_05_14 by Satya Prasad
% Questions or comments? szm888@psu.edu
% Updated: 2022/02/15

flag_do_debug = 0; % Flag to plot the results for debugging
flag_do_plot  = 0; % Flag to plot the results
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
    if 3>nargin || 4<nargin
        error('Incorrect number of input arguments')
    end
    
    % Check input type and domain
    try
        fcn_AVAR_checkInputsToFunctions(power_spectral_density,'positive');
    catch ME
        assert(strcmp(ME.message,...
            'The power_spectral_density input must be a positive number'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    try
        fcn_AVAR_checkInputsToFunctions(sampling_frequency,'positive');
    catch ME
        assert(strcmp(ME.message,...
            'The sampling_frequency input must be a positive number'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    try
        fcn_AVAR_checkInputsToFunctions(number_of_time_steps,'positive integer');
    catch ME
        assert(strcmp(ME.message,...
            'The number_of_time_steps input must be a positive integer'));
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
        fig_num = fig.Number;
        flag_do_plot = 1;
    end
end

%% Generate White Noise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Derived parameters
% variance of white noise
variance_white_noise = power_spectral_density*sampling_frequency;

%% Noise generation: White Noise
mean_white_noise = 0; % default value
white_noise = normrnd(mean_white_noise,sqrt(variance_white_noise),...
                      number_of_time_steps,1); % white noise

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
    time_vector = (1/sampling_frequency)*(0:(number_of_time_steps-1))';
    mag_lb = min(white_noise);
    mag_ub = max(white_noise);
    mag_range = mag_ub-mag_lb;
    
    figure(fig_num)
    clf
    width = 540; height = 400; right = 100; bottom = 400;
    set(gcf, 'position', [right, bottom, width, height])
    plot(time_vector,white_noise,'b')
    grid on
    set(gca,'FontSize',13)
    ylabel('Measurement $[Unit]$','Interpreter','latex','FontSize',18)
    xlabel('Time $[s]$','Interpreter','latex','FontSize',18)
    xlim([time_vector(1) time_vector(end)])
    ylim([mag_lb-0.1*mag_range mag_ub+0.1*mag_range])
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end