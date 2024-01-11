%%%%%%%%%%%%%%%%%%%%%%% script_AVAR_plotsForFAVAR.m %%%%%%%%%%%%%%%%%%%%%%%
%% Purpose:
%   The purpose of the script is to generate plots for chapter in Satya's
%   thesis 'Fast Allan Variance'.
% 
% Author:  Satya Prasad
% Created: 2022/05/16

%% Prepare workspace
clear all %#ok<CLALL>
close all
clc

addpath('../Data')

flag_data = true; % Set to true to use data for DAVAR plots
%% Plot regularly sampled test signal
rng('default') % set random seeds
random_walk_coefficient = 0.02; % random walk coefficient [unit/sqrt(s)]
power_spectral_density  = 0.0004; % PSD of white noise [unit^2 s]
sampling_frequency      = 50; % [Hz]
number_of_time_steps    = 2^19+1;

% Noise generation: Random Walk+White Noise
time_vector  = (0:number_of_time_steps-1)'/sampling_frequency;
random_walk  = fcn_AVAR_generateRandomWalk(random_walk_coefficient, ....
    sampling_frequency, number_of_time_steps); % generate random walk
white_noise  = fcn_AVAR_generateWhiteNoise(power_spectral_density, ...
    sampling_frequency, number_of_time_steps); % generate white noise
noise_signal = random_walk+white_noise; % random walk plus white noise

figure(101)
clf
width = 540; height = 400; right = 100; bottom = 300;
set(gcf, 'position', [right, bottom, width, height])
hold on
grid on
plot(time_vector, noise_signal, 'b.', 'Markersize', 1)
set(gca, 'FontSize', 13)
ylabel('Amplitude $[Unit]$', 'Interpreter', 'Latex', 'FontSize', 18)
xlabel('Time $[s]$', 'Interpreter', 'Latex', 'FontSize', 18)
xlim([0 2000])
ylim([-3 4])

%% Plot irregularly sampled test signal
rng('default') % set random seeds
random_walk_coefficient = 0.02; % [unit/sqrt(s)]
power_spectral_density  = 0.0004; % PSD of white noise [unit^2 s]
sampling_frequency      = 50; % [Hz];
upsampling_factor       = 25;
ireg_time_vector        = NaN;
number_of_time_steps    = 2^18+1;

% Noise generation: Random Walk+White Noise
[ireg_random_walk, ireg_time_vector] = ...
    fcn_AVAR_generateIrregularRandomWalk(random_walk_coefficient, ...
    sampling_frequency, number_of_time_steps, ...
    upsampling_factor, ireg_time_vector); % generate random walk
ireg_white_noise = fcn_AVAR_generateIrregularWhiteNoise(power_spectral_density, ...
    sampling_frequency, number_of_time_steps, ...
    upsampling_factor, ireg_time_vector); % generate white noise
ireg_noise_signal = ireg_random_walk+ireg_white_noise; % random walk plus white noise (irregularly sampled)

figure(102)
clf
width = 540; height = 400; right = 100; bottom = 300;
set(gcf, 'position', [right, bottom, width, height])
hold on
grid on
plot(ireg_time_vector, ireg_noise_signal, 'b.', 'Markersize', 2)
set(gca, 'FontSize', 13)
ylabel('Amplitude $[Unit]$', 'Interpreter', 'Latex', 'FontSize', 18)
xlabel('Time $[s]$', 'Interpreter', 'Latex', 'FontSize', 18)
xlim([0 2000])

%% Speed of AVAR algorithm
load('FAVAR_Speed.mat');

figure(01)
clf
width = 540; height = 400; right = 100; bottom = 300;
set(gcf, 'position', [right, bottom, width, height])
hold on
grid on
plot(FAVAR.dataLength, FAVAR.std, 'b', 'LineWidth', 1.2)
yline(1, 'g', 'LineWidth', 1.2);
set(gca, 'XScale', 'log', 'YScale', 'log', 'FontSize', 13)
ylabel('Wall Time $[s]$', 'Interpreter', 'Latex', 'FontSize', 18)
xlabel('Data Length $[Number \: of \: Samples]$', 'Interpreter', 'Latex', 'FontSize', 18)
ylim([10^-4.5 1e2])

%% Speed of FAVAR vs AVAR
load('FAVAR_Speed.mat');

figure(02)
clf
width = 540; height = 400; right = 100; bottom = 300;
set(gcf, 'position', [right, bottom, width, height])
hold on
grid on
plot(FAVAR.dataLength, FAVAR.std./FAVAR.fast, 'b', 'LineWidth', 1.2)
yline(1, 'g', 'LineWidth', 1.2);
set(gca, 'XScale', 'log', 'YScale', 'log', 'FontSize', 13)
ylabel('Ratio of Wall Time $[No \: Units]$', 'Interpreter', 'Latex', 'FontSize', 18)
xlabel('Data Length $[Number \: of \: Samples]$', 'Interpreter', 'Latex', 'FontSize', 18)
ylim([10^-0.5 1e4])

%% Speed of FAVAR-I vs AVAR-I
load('FAVARI_Speed.mat');

figure(03)
clf
width = 540; height = 400; right = 100; bottom = 300;
set(gcf, 'position', [right, bottom, width, height])
hold on
grid on
plot(FAVARI.dataLength, FAVARI.std./FAVARI.fast, 'b', 'LineWidth', 1.2)
plot(FAVARI.dataLength, FAVARI.std./(FAVARI.fast+FAVARI.preProc), 'm', 'LineWidth', 1.2)
yline(1, 'g', 'LineWidth', 1.2);
set(gca, 'XScale', 'log', 'YScale', 'log', 'FontSize', 13)
legend('w/o pre-processing', 'w/ pre-processing', 'Interpreter', 'Latex', ...
    'FontSize', 13, 'Location', 'best')
ylabel('Ratio of Wall Time $[No \: Units]$', 'Interpreter', 'Latex', 'FontSize', 18)
xlabel('Data Length $[Number \: of \: Samples]$', 'Interpreter', 'Latex', 'FontSize', 18)
ylim([1e-1 1e4])

%% Speed of DFAVAR vs FAVAR and DFAVAR-I vs FAVAR-I
load('DFAVAR_Speed.mat');
load('DFAVARI_Speed.mat');

figure(04)
clf
width = 540; height = 400; right = 100; bottom = 300;
set(gcf, 'position', [right, bottom, width, height])
hold on
grid on
plot(DFAVAR.dataLength, DFAVAR.std./DFAVAR.fast, 'b', 'LineWidth', 1.2)
plot(DFAVARI.dataLength, DFAVARI.std./DFAVARI.fast, 'm', 'LineWidth', 1.2)
yline(1, 'g', 'LineWidth', 1.2);
legend('DFAVAR','DFAVAR-I','Location','best', 'Interpreter', 'Latex', 'FontSize', 13)
set(gca, 'XScale', 'log', 'YScale', 'log', 'FontSize', 13)
xlabel('Horizon Length $[Number \: of \: Samples]$', 'Interpreter', 'Latex', 'FontSize', 18)
ylabel('Ratio of Wall Time $[No \: Units]$', 'Interpreter', 'Latex', 'FontSize', 18)
ylim([10^-0.5 1e2])

%% Compare AVAR of regularly sampled data estimated using AVAR and FAVAR
rng('default') % set random seeds
random_walk_coefficient = 0.02; % random walk coefficient [unit/sqrt(s)]
power_spectral_density  = 0.0004; % PSD of white noise [unit^2 s]
sampling_frequency      = 50; % [Hz]
number_of_time_steps    = 2^19+1;

% Noise generation: Random Walk+White Noise
random_walk  = fcn_AVAR_generateRandomWalk(random_walk_coefficient, ....
    sampling_frequency, number_of_time_steps); % generate random walk
white_noise  = fcn_AVAR_generateWhiteNoise(power_spectral_density, ...
    sampling_frequency, number_of_time_steps); % generate white noise
noise_signal = random_walk+white_noise; % random walk plus white noise

% Data trimming and Calculation of possible correlation intervals
p = floor(log2(number_of_time_steps));
noise_signal = noise_signal(end-2^p:end);
list_of_correlation_intervals = 2.^(0:p-2)'; % list of correlation intervals
list_of_correlation_time = list_of_correlation_intervals/sampling_frequency; % list of correlation time

% Allan variance: Compare FAVAR and Normal algorithm
favar = fcn_AVAR_favar(noise_signal, list_of_correlation_intervals); % calculate allan variance uisng FAVAR algorithm
avar  = fcn_AVAR_avar(noise_signal, list_of_correlation_intervals); % calculate allan variance using AVAR algorithm

% Plots for allan variance
fcn_AVAR_plotCompareAvar2('FAVAR',favar,'AVAR',avar,list_of_correlation_time,05); % Plot for AVAR
subplot(2,1,1)
ylim([1e-4 1e-1])

%% Conversion of irregularly sampled data into weighted regularly sampled data
rng(888)
sampling_frequency = 50; % [Hz]
upsampling_factor  = 5;
time    = 0:1/sampling_frequency:0.1;
time_up = 0:1/(sampling_frequency*upsampling_factor):0.1;
indices_of_irregularly_sampled_data = sort(randperm(numel(time_up),numel(time)))';
is_data = [1,2,2,1,1,2]';
[data, weights] = ...
    fcn_AVAR_irregular2regularWeightedData(is_data, ...
    time_up(indices_of_irregularly_sampled_data)', 1/sampling_frequency, ...
    time(1), time(end));

figure(06)
clf
width = 540; height = 550; right = 100; bottom = 100;
set(gcf, 'position', [right, bottom, width, height])
subplot(2,1,1)
hold on
grid on
plot([time; time],[-0.5 2.5],'g','Linewidth',1.2)
plot(time_up(indices_of_irregularly_sampled_data),is_data,'m.','Markersize',13);
plot(time',data,'b*','Markersize',8);
set(gca,'FontSize',13)
ylabel('Magnitude $[Unit]$','Interpreter','latex','FontSize',18)
title('(a)','Interpreter','latex','FontSize',18)
xlim([-0.005 0.105])
ylim([-1 4])

subplot(2,1,2)
hold on
grid on
plot([time; time],[0 4],'g','Linewidth',1.2)
h1 = plot(time_up(indices_of_irregularly_sampled_data),1,'m.','Markersize',13);
h2 = plot(time',weights,'b*','Markersize',8);
set(gca,'FontSize',13)
ylabel('Weights $[No \: Units]$','Interpreter','latex','FontSize',18)
xlabel('Time $[s]$','Interpreter','latex','FontSize',18)
legend([h1(1),h2(1)],'Irregularly Sampled Data','Regularly Sampled Data',...
    'Interpreter','latex','FontSize',13)
title('(b)','Interpreter','latex','FontSize',18)
xlim([-0.005 0.105])
ylim([-0.5 6])

%% Compare AVAR of irregularly sampled data estimated using AVAR-I and FAVAR-I
rng('default') % set random seeds
random_walk_coefficient = 0.02; % [unit/sqrt(s)]
power_spectral_density  = 0.0004; % PSD of white noise [unit^2 s]
sampling_frequency      = 50; % [Hz]
sampling_interval       = 1/sampling_frequency;
upsampling_factor       = 25;
ireg_time_vector        = NaN;
number_of_time_steps    = 2^18+1;

% Noise generation: Random Walk+White Noise
time_vector = (1/sampling_frequency)*(0:number_of_time_steps-1)';

[ireg_random_walk, ireg_time_vector] = ...
    fcn_AVAR_generateIrregularRandomWalk(random_walk_coefficient, ...
    sampling_frequency, number_of_time_steps, ...
    upsampling_factor, ireg_time_vector); % generate random walk
ireg_white_noise = fcn_AVAR_generateIrregularWhiteNoise(power_spectral_density, ...
    sampling_frequency, number_of_time_steps, ...
    upsampling_factor, ireg_time_vector); % generate white noise
ireg_noise_signal = ireg_random_walk+ireg_white_noise; % random walk plus white noise (irregularly sampled)

% Calculation of possible correlation intervals
p = floor(log2(number_of_time_steps));
list_of_correlation_intervals = 2.^(0:p-2)'; % list of correlation intervals
list_of_correlation_time = list_of_correlation_intervals/sampling_frequency; % list of correlation time

% Allan variance: Compare AVAR-I with FAVAR-I
min_time = time_vector(1);
max_time = time_vector(end);
ireg_avar = fcn_AVAR_avarI(ireg_noise_signal, ireg_time_vector, ...
    list_of_correlation_time, sampling_interval, min_time, max_time); % calculate allan variance using normal algorithm

% Data preprocessing into intervals and calculation of weights and average
[input_data, input_weights] = ...
    fcn_AVAR_irregular2regularWeightedData(ireg_noise_signal, ...
    ireg_time_vector, sampling_interval, min_time, max_time);
ireg_favar = fcn_AVAR_favarI(input_data, input_weights, ...
    list_of_correlation_intervals); % calculate allan variance of irregularly sampled data using FAVAR

% Plots for allan variance
fcn_AVAR_plotCompareAvar2('FAVAR-I',ireg_favar,'AVAR-I',ireg_avar,list_of_correlation_time,07); % Plot for AVAR

%% Compare DAVAR of regularly sampled data estimated using DFAVAR and FAVAR
rng('default') % set random seeds
random_walk_coefficient = 0.02; % [unit/sqrt(s)]
power_spectral_density  = 0.0004; % PSD of white noise [unit^2 s]
sampling_frequency      = 50; % [Hz]
sampling_interval       = 1/sampling_frequency;
horizon_size            = 2^18+1; % (2^p + 1) form
number_of_time_steps    = 520000;

% Noise generation: Random Walk + White Noise
random_walk = fcn_AVAR_generateRandomWalk(random_walk_coefficient,....
              sampling_frequency,number_of_time_steps); % Random walk
white_noise = [fcn_AVAR_generateWhiteNoise(power_spectral_density,...
               sampling_frequency,horizon_size); ...
               fcn_AVAR_generateWhiteNoise(power_spectral_density/10000,...
               sampling_frequency,number_of_time_steps-horizon_size)]; % White noise
noise_signal = random_walk + white_noise; % Random walk plus White noise

% Calculation of possible correlation intervals
p = floor(log2(horizon_size-1));
list_of_correlation_intervals = 2.^(0:p-2)'; % Correlation intervals
list_of_correlation_time      = list_of_correlation_intervals/sampling_frequency; % Correlation times

if flag_data
    load('DFAVAR_data.mat');
else
    % Dynamic Allan variance: D-FAVAR
    matrix_favar  = zeros(number_of_time_steps-horizon_size+1,numel(list_of_correlation_intervals));
    matrix_dfavar = zeros(number_of_time_steps-horizon_size+1,numel(list_of_correlation_intervals));
    for i = horizon_size:number_of_time_steps
        if i == horizon_size
            clear fcn_AVAR_dFavar;
            data = noise_signal(1:horizon_size);
            matrix_favar(i-horizon_size+1,:) = fcn_AVAR_favar(data,list_of_correlation_intervals)';
        else
            data = noise_signal(i-horizon_size:i);
            matrix_favar(i-horizon_size+1,:) = fcn_AVAR_favar(data(2:end),list_of_correlation_intervals)';
        end
        matrix_dfavar(i-horizon_size+1,:) = fcn_AVAR_dFavar(data,list_of_correlation_intervals)';
    end % NOTE: END FOR loop 'horizon_size:number_of_time_steps'
    save('DFAVAR_data.mat','matrix_dfavar','matrix_favar');
end % NOTE: END IF statement 'flag_data'
relative_error = abs(matrix_dfavar-matrix_favar)./matrix_dfavar;

fcn_AVAR_plotDAVAR(matrix_dfavar,list_of_correlation_time,...
                   (horizon_size-1:number_of_time_steps-1)*sampling_interval,08);
fcn_AVAR_plotDAVARrelError(relative_error,list_of_correlation_time,...
                           (horizon_size-1:number_of_time_steps-1)*sampling_interval,9081);

%% Compare DAVAR of irregularly sampled data estimated using DFAVAR-I and FAVAR-I
rng('default') % set random seeds
random_walk_coefficient = 0.02; % [unit/sqrt(s)]
power_spectral_density  = 0.0004; % PSD of white noise [unit^2 s]
sampling_frequency      = 50; % [Hz]
sampling_interval       = 1/sampling_frequency;
upsampling_factor       = 25;
ireg_time_vector        = NaN;
horizon_size            = 2^18+1;
number_of_time_steps    = 520000;

% Noise generation: Random walk and White noise
time_vector = sampling_interval*(0:number_of_time_steps-1);

[ireg_random_walk, ireg_time_vector] = ...
    fcn_AVAR_generateIrregularRandomWalk(random_walk_coefficient,...
    sampling_frequency,number_of_time_steps,upsampling_factor,ireg_time_vector); % Random walk
ireg_white_noise1 = fcn_AVAR_generateIrregularWhiteNoise(power_spectral_density,...
                    sampling_frequency,number_of_time_steps,...
                    upsampling_factor,ireg_time_vector); % White noise
ireg_white_noise2 = fcn_AVAR_generateIrregularWhiteNoise(power_spectral_density/10000,...
                    sampling_frequency,number_of_time_steps,...
                    upsampling_factor,ireg_time_vector); % White noise
ireg_noise_signal = ireg_random_walk + [ireg_white_noise1(1:horizon_size); ...
                                        ireg_white_noise2(horizon_size+1:end)];

% Calculation of possible correlation intervals
p = floor(log2(horizon_size-1));
list_of_correlation_intervals = 2.^(0:p-2)'; % A vector of correlation interval(s)
list_of_correlation_time      = list_of_correlation_intervals/sampling_frequency; % A vector of correlation time(s)

if flag_data
    load('DFAVARI_data.mat');
else
    % Data Preprocessing into Intervals
    min_time = time_vector(1);
    max_time = time_vector(end);
    [input_data, input_weights] = ...
        fcn_AVAR_irregular2regularWeightedData(ireg_noise_signal,...
        ireg_time_vector,sampling_interval,min_time,max_time);
    
    % Dynamic Allan variance of irregularly sampled data: D-FAVAR-I
    matrix_dfavari = zeros(number_of_time_steps-horizon_size+1,numel(list_of_correlation_intervals));
    matrix_favari  = zeros(number_of_time_steps-horizon_size+1,numel(list_of_correlation_intervals));
    for i = horizon_size:number_of_time_steps
        if i == horizon_size
            clear fcn_AVAR_dFavarI;
            data    = input_data(1:horizon_size);
            weights = input_weights(1:horizon_size);
            matrix_favari(i-horizon_size+1,:) = fcn_AVAR_favarI(data,weights,list_of_correlation_intervals)';
        else
            data    = input_data(i-horizon_size:i);
            weights = input_weights(i-horizon_size:i);
            matrix_favari(i-horizon_size+1,:) = fcn_AVAR_favarI(data(2:end),weights(2:end),list_of_correlation_intervals)';
        end
        matrix_dfavari(i-horizon_size+1,:) = fcn_AVAR_dFavarI(data,weights,list_of_correlation_intervals)';
    end % NOTE: END FOR loop 'horizon_size:number_of_time_steps'
    save('DFAVARI_data.mat','matrix_dfavari','matrix_favari');
end % NOTE: END IF statement 'flag_data'
relative_error = abs(matrix_dfavari-matrix_favari)./matrix_dfavari;
 
fcn_AVAR_plotDAVAR(matrix_dfavari,list_of_correlation_time,...
                   (horizon_size-1:number_of_time_steps-1)*sampling_interval,09);
fcn_AVAR_plotDAVARrelError(relative_error,list_of_correlation_time,...
                           (horizon_size-1:number_of_time_steps-1)*sampling_interval,9091);
