function fcn_AVAR_plotCompareAvar2(name_method1,avar_method1,name_method2,...
                                   avar_method2,list_of_correlation_time,...
                                   varargin)
%% fcn_AVAR_plotCompareAvar2
%   This function plots AVAR of noise signal computed by two different
%   methods or AVAR of two different noise signals. It also plots absolute
%   error.
%
% FORMAT:
%   fcn_AVAR_plotCompareAvar2(name_method1,avar_method1,name_method2,...
%                            avar_method2,list_of_correlation_time)
%
% INPUTS:
%   name_method1: Name of the signal or Name of the method to compute AVAR.
%   avar_method1: A M x 1 vector of AVAR evaluated at correlation time in
%   'list_of_correlation_time'.
%   name_method2: Name of the signal or Name of the method to compute AVAR.
%   avar_method2: A M x 1 vector of AVAR evaluated at correlation time in
%   'list_of_correlation_time'.
%   list_of_correlation_time: A M x 1 vector correlation time at which AVAR
%   is evaluated.
%   varargin: figure number.
%
% OUTPUTS:
%   A plot to compare two AVAR curves.
%
% This function was written on 2021_05_26 by Satya Prasad
% Questions or comments? szm888@psu.edu
% Updated: 2022/02/15

flag_check_inputs = 1; % Flag to perform input checking

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
    if 5>nargin || 6<nargin
        error('Incorrect number of input arguments')
    end
    
    % Check input type and domain
    try
        fcn_AVAR_checkInputsToFunctions(name_method1,'string');
    catch ME
        assert(strcmp(ME.message,...
            'The name_method1 input must be string'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    try
        fcn_AVAR_checkInputsToFunctions(avar_method1,'avar');
    catch ME
        assert(strcmp(ME.message,...
            'The avar_method1 input must be a M x 1 vector of non-negative numbers'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    try
        fcn_AVAR_checkInputsToFunctions(name_method2,'string');
    catch ME
        assert(strcmp(ME.message,...
            'The name_method2 input must be string'));
        fprintf(1, '%s\n\n', ME.message)
        return;
    end
    try
        fcn_AVAR_checkInputsToFunctions(avar_method2,'avar');
    catch ME
        assert(strcmp(ME.message,...
            'The avar_method2 input must be a M x 1 vector of non-negative numbers'));
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
end

if 6 == nargin
    fig_num = varargin{1};
else
    fig = figure;
    fig_num = fig.Number;
end

%% Plot AVAR of different methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(fig_num)
clf
width = 540; height = 600; right = 100; bottom = 100;
set(gcf, 'position', [right, bottom, width, height])
subplot(2,1,1)
hold on
grid on
plot(list_of_correlation_time,avar_method1,'r.','Markersize',13)
plot(list_of_correlation_time,avar_method2,'bo','Markersize',10)
set(gca,'XScale','log','YScale','log','FontSize',13)
legend(name_method1,name_method2,'Location','best','Interpreter','latex','FontSize',13)
ylabel('Allan Variance $[Unit^2]$','Interpreter','latex','FontSize',18)
title('(a)','Interpreter','latex','FontSize',18)

subplot(2,1,2)
hold on
grid on
plot(list_of_correlation_time,abs(avar_method1./avar_method2-1),'r','Linewidth',1.2)
set(gca,'XScale','log','FontSize',13)
ylabel('Relative Error $[No \: Units]$','Interpreter','latex','FontSize',18)
xlabel('Correlation Time $[s]$','Interpreter','latex','FontSize',18)
title('(b)','Interpreter','latex','FontSize',18)
end