function fcn_AVAR_plotDAVARrelError(davar_relError,list_of_correlation_time,...
                                    time_vector,varargin)
%% fcn_AVAR_plotDAVARrelError
%   This function plots relative error in dynamic allan variance
%
% FORMAT:
%   fcn_AVAR_plotDAVARrelError(davar_relError,list_of_correlation_time,time_vector)
%
% INPUTS:
%   davar_relError: A N x M matrix of relative error in dynamic allan variance 
%   corresponding to each correlation time in 'list_of_correlation_time' 
%   and instance in 'time_vector'.
%   list_of_correlation_time: A M x 1 vector containing list of correlation time.
%   time_vector: A N x 1 vector at which DAVAR is evaluated.
%   varargin: figure number.
%
% OUTPUTS:
%   A plot of relative error in DAVAR curve.
%
% This function was written on 2022_02_15 by Satya Prasad
% Questions or comments? szm888@psu.edu

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
    if 3>nargin || 4<nargin
        error('Incorrect number of input arguments')
    end
end

if 4 == nargin
    fig_num = varargin{1};
else
    fig = figure;
    fig_num = fig.Number;
end

%% Plot the relative error in DAVAR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[correlation_time_grid,time_grid] = meshgrid(list_of_correlation_time,...
                                             time_vector); % generate grid of correlation time and time-step
figure(fig_num)
clf
width = 540; height = 400; right = 100; bottom = 200;
set(gcf, 'position', [right, bottom, width, height])
surf(correlation_time_grid,time_grid,davar_relError,...
     'FaceColor','interp','FaceAlpha',1,'EdgeColor','none')
set(gca,'XScale','log','ZScale','log',...
    'Xtick',[1e-2 1e0 1e2 1e4],'Ytick',[6000 8000 10000],...
    'Ydir','reverse','FontSize',12)
xlabel('Correlation Time $[s]$','Interpreter','latex','FontSize',16)
ylabel('Time $[s]$','Interpreter','latex','FontSize',16)
zlabel('Relative Error $[No \: Units]$','Interpreter','latex','FontSize',16)
colormap jet
view(-10,30)
end