%%%%%%%%%%%%%%%%%%% script_AVAR_SpeedOfFAVARalgorithms.m %%%%%%%%%%%%%%%%%%
% Purpose:
%   The purpose of this script is compare the speed of 
%   1) FAVAR with AVAR
%   2) FAVAR-I with AVAR-I
%   3) D-FAVAR with FAVAR
%   4) D-FAVAR-I with FAVAR-I
%
% This script was written on 2021_03_30 by Satya Prasad
% Questions or comments? szm888@psu.edu

%% Prepare workspace
clear all %#ok<CLALL>
close all
clc

%% Speed of AVAR algorithm and FAVAR vs AVAR
rng('default') % Intialization

% Define constants and parameters
power_spectral_density  = 0.0004; % PSD of white noise [unit^2 s]
random_walk_coefficient = 0.02; % [unit/sqrt(s)]
sampling_frequency      = 50; % [Hz]
number_of_iterations    = 100;

time_vector_store = NaN(2,17);
for i = 2:18
number_of_time_steps = 2^i+1;

% Noise generation: Random Walk added to White Noise
time_vector = (1/sampling_frequency)*(0:number_of_time_steps-1);

random_walk  = fcn_AVAR_generateRandomWalk(random_walk_coefficient, ....
               sampling_frequency, number_of_time_steps); % generate random walk
white_noise  = fcn_AVAR_generateWhiteNoise(power_spectral_density, ...
               sampling_frequency, number_of_time_steps); % generate white noise
noise_signal = random_walk + white_noise;

% Data trimming and calculation of possible correlation intervals
p = floor(log2(number_of_time_steps-1));
noise_signal = noise_signal(1:2^p+1);
list_of_correlation_intervals = 2.^(0:p-1)'; % A vector of correlation intervals
list_of_correlation_time      = list_of_correlation_intervals/sampling_frequency; % A vector of correlation time

% Allan variance: Fast
tic
for j = 1:number_of_iterations
    fcn_AVAR_favar(noise_signal,list_of_correlation_intervals); % calculate allan variance
end
elapsed_time = toc;
time_vector_store(1,i-1) = elapsed_time/number_of_iterations;

% Allan variance: Standard
tic
for j = 1:number_of_iterations
    fcn_AVAR_avar(noise_signal,list_of_correlation_intervals); % calculate allan variance
end
elapsed_time = toc;
time_vector_store(2,i-1) = elapsed_time/number_of_iterations;
end
%%% Save the data
FAVAR.dataLength = 2.^(2:18)+1;
FAVAR.fast = time_vector_store(1,:);
FAVAR.std  = time_vector_store(2,:);
save('FAVAR_Speed.mat','FAVAR');

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
rng('default') % Intialization

power_spectral_density  = 0.0004; % PSD of white noise [unit^2 s]
random_walk_coefficient = 0.02; % [unit/sqrt(s)]
sampling_frequency      = 50; % [Hz]
sampling_interval       = 1/sampling_frequency;
upsampling_factor       = 25;
number_of_iterations    = 50;

time_vector_store = NaN(3,16);
for j = 2:17
number_of_time_steps = 2^j+1;

% Noise generation: Random Walk added to white noise
time_vector = (1/sampling_frequency)*(0:number_of_time_steps-1);

ireg_time_vector = NaN;
% generate noise signal
[ireg_white_noise, ireg_time_vector] = ...
    fcn_AVAR_generateIrregularWhiteNoise(power_spectral_density, ...
    sampling_frequency, number_of_time_steps, ...
    upsampling_factor, ireg_time_vector); % generate white noise
ireg_random_walk = ...
    fcn_AVAR_generateIrregularRandomWalk(random_walk_coefficient, ...
    sampling_frequency, number_of_time_steps, ...
    upsampling_factor, ireg_time_vector); % generate random walk
noise_signal = ireg_white_noise+ireg_random_walk;

% Data trimming and calculation of possible correlation intervals
p = floor(log2(number_of_time_steps-1));
list_of_correlation_intervals = 2.^(0:p-1)'; % A vector of correlation intervals
list_of_correlation_time      = list_of_correlation_intervals/sampling_frequency; % A vector of correlation times

% convert irregularly sampled data into weighted regularly sampled data
min_time = 0;
max_time = (number_of_time_steps-1)/sampling_frequency;
tic
for i = 1:number_of_iterations
    [data, weights] = ...
        fcn_AVAR_irregular2regularWeightedData(noise_signal, ...
        ireg_time_vector, 1/sampling_frequency, min_time, max_time);
end
elapsed_time = toc;
time_vector_store(3,j-1) = elapsed_time/number_of_iterations;

% Allan variance: Compare FAVAR and Normal algorithm
tic
for i = 1:number_of_iterations
    favar = fcn_AVAR_favarI(data, weights, list_of_correlation_intervals);
end
elapsed_time = toc;
time_vector_store(1,j-1) = elapsed_time/number_of_iterations;

tic
for i = 1:number_of_iterations
    avar  = fcn_AVAR_avarI(noise_signal, ireg_time_vector, list_of_correlation_time, ...
            sampling_interval, min_time, max_time);
end
elapsed_time = toc;
time_vector_store(2,j-1) = elapsed_time/number_of_iterations;
end
%%% Save the data
FAVARI.dataLength = 2.^(2:17)+1;
FAVARI.std     = time_vector_store(2,:);
FAVARI.fast    = time_vector_store(1,:);
FAVARI.preProc = time_vector_store(3,:);
save('FAVARI_Speed.mat','FAVARI');

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

%% Speed of DFAVAR vs FAVAR
% Define constants and parameters
rng('default') % Intialization

power_spectral_density  = 0.0004; % PSD of white noise [unit^2 s]
random_walk_coefficient = 0.02; % [unit/sqrt(s)]
sampling_frequency      = 50; % [Hz]

time_vector_store = NaN(2,17);
for j = 2:18
horizon_size         = 2^j+1;
number_of_time_steps = horizon_size+5000;

% Noise generation: Random Walk added to White Noise
time_vector  = (1/sampling_frequency)*(0:number_of_time_steps-1);
random_walk  = fcn_AVAR_generateRandomWalk(random_walk_coefficient, ....
               sampling_frequency, number_of_time_steps); % generate random walk
white_noise  = fcn_AVAR_generateWhiteNoise(power_spectral_density, ...
               sampling_frequency, number_of_time_steps); % generate white noise
noise_signal = random_walk + white_noise;

% Data trimming and calculation of possible correlation intervals
p = floor(log2(horizon_size-1));
list_of_correlation_intervals = 2.^(0:p-1)'; % A vector of correlation intervals
list_of_correlation_time      = list_of_correlation_intervals/sampling_frequency; % A vector of correlation time

% Dynamic Allan variance: DFAVAR
vector_recursive_elapsed_time = zeros(number_of_time_steps-horizon_size, 1);
for i = horizon_size:number_of_time_steps
    if i == horizon_size
        clear fcn_AVAR_dFavar
        data = noise_signal(1:horizon_size);
    else
        data = noise_signal(i-horizon_size:i);
    end
    tic
    recursive_davar = fcn_AVAR_dFavar(data, list_of_correlation_intervals); % calculate allan variance
    elapsed_time = toc;
    if i ~= horizon_size
        vector_recursive_elapsed_time(i-horizon_size) = elapsed_time;
    end
end

% Dynamic Allan variance: FAVAR
vector_brute_force_elapsed_time = zeros(number_of_time_steps-horizon_size, 1);
for i = horizon_size:number_of_time_steps
    data = noise_signal(i-horizon_size+1:i);
    tic
    brute_force_davar = fcn_AVAR_favar(data, list_of_correlation_intervals); % calculate allan variance
    elapsed_time = toc;
    if i ~= horizon_size
        vector_brute_force_elapsed_time(i-horizon_size) = elapsed_time;
    end
end

time_vector_store(1,j-1) = mean(vector_recursive_elapsed_time);
time_vector_store(2,j-1) = mean(vector_brute_force_elapsed_time);
end
%%% Save the data
DFAVAR.dataLength = 2.^(2:18)+1;
DFAVAR.fast = time_vector_store(1,:);
DFAVAR.std  = time_vector_store(2,:);
save('DFAVAR_Speed.mat','DFAVAR');

figure(04)
clf
width = 540; height = 400; right = 100; bottom = 300;
set(gcf, 'position', [right, bottom, width, height])
hold on
grid on
plot(DFAVAR.dataLength, DFAVAR.std./DFAVAR.fast, 'b', 'LineWidth', 1.2)
yline(1, 'g', 'LineWidth', 1.2);
set(gca, 'XScale', 'log', 'YScale', 'log', 'FontSize', 13)
xlabel('Horizon Length $[Number \: of \: Samples]$', 'Interpreter', 'Latex', 'FontSize', 18)
ylabel('Ratio of Wall Time $[No \: Units]$', 'Interpreter', 'Latex', 'FontSize', 18)

%% Speed of DFAVAR-I vs FAVAR-I
% Define constants and parameters
rng('default') % Intialization

power_spectral_density  = 0.0004; % PSD of white noise [unit^2 s]
random_walk_coefficient = 0.02; % [unit/sqrt(s)]
sampling_frequency      = 50; % [Hz]
upsampling_factor       = 25;

time_vector_store = NaN(2,17);
for j = 2:18
horizon_size         = (2^j)+1;
number_of_time_steps = horizon_size+5000;

% Noise generation: Random Walk added to white noise
time_vector = (1/sampling_frequency)*(0:(number_of_time_steps-1));

ireg_time_vector = NaN;
% generate noise signal
[ireg_white_noise, ireg_time_vector] = ...
    fcn_AVAR_generateIrregularWhiteNoise(power_spectral_density, ...
    sampling_frequency, number_of_time_steps, ...
    upsampling_factor, ireg_time_vector); % generate white noise
ireg_random_walk = ...
    fcn_AVAR_generateIrregularRandomWalk(random_walk_coefficient, ...
    sampling_frequency, number_of_time_steps, ...
    upsampling_factor, ireg_time_vector); % generate random walk
noise_signal = ireg_white_noise+ireg_random_walk;

random_walk_time = time_vector(number_of_time_steps)*sort(rand(number_of_time_steps, 1));

% Calculation of possible correlation intervals
p = floor(log2(horizon_size));
list_of_correlation_intervals = 2.^(0:p-1)'; % A vector of correlation interval(s)
list_of_correlation_time      = list_of_correlation_intervals/sampling_frequency; % A vector of correlation time(s)

% Data Preprocessing into Intervals
% convert irregularly sampled data into weighted regularly sampled data
min_time = 0;
max_time = (number_of_time_steps-1)/sampling_frequency;
[input_data, input_weights] = ...
    fcn_AVAR_irregular2regularWeightedData(noise_signal, ...
    ireg_time_vector, 1/sampling_frequency, min_time, max_time);

% Irregular Dynamic Allan variance
vector_recursive_elapsed_time   = zeros(number_of_time_steps-horizon_size, 1);
vector_brute_force_elapsed_time = zeros(number_of_time_steps-horizon_size, 1);
for i = horizon_size:number_of_time_steps
    if i == horizon_size
        data = input_data(1:horizon_size);
        weights = input_weights(1:horizon_size);
    else
        data = input_data(i-horizon_size:i);
        weights = input_weights(i-horizon_size:i);
    end
    
    % Recursive DAVAR
    if i == horizon_size
        clear fcn_AVAR_dFavarI
    end
    tic
    recursive_davar = fcn_AVAR_dFavarI(data, weights, ...
                      list_of_correlation_intervals); % calculate allan variance
    elapsed_time = toc;
    if i ~= horizon_size
        vector_recursive_elapsed_time(i-horizon_size) = elapsed_time;
    end
    
    % Recursive AVAR
    if i == horizon_size
        brute_force_davar = fcn_AVAR_favarI(data, weights, ...
            list_of_correlation_intervals); % calculate allan variance
    else
        tic
        brute_force_davar = fcn_AVAR_favarI(data(2:end), weights(2:end), ...
            list_of_correlation_intervals); % calculate allan variance
        elapsed_time = toc;
        vector_brute_force_elapsed_time(i-horizon_size) = elapsed_time;
    end
end

time_vector_store(1,j-1) = mean(vector_recursive_elapsed_time);
time_vector_store(2,j-1) = mean(vector_brute_force_elapsed_time);
end
%%% Save the data
DFAVARI.dataLength = 2.^(2:18)+1;
DFAVARI.fast = time_vector_store(1,:);
DFAVARI.std  = time_vector_store(2,:);
save('DFAVARI_Speed.mat','DFAVARI');

figure(05)
clf
width = 540; height = 400; right = 100; bottom = 300;
set(gcf, 'position', [right, bottom, width, height])
hold on
grid on
plot(DFAVARI.dataLength, DFAVARI.std./DFAVARI.fast, 'b', 'LineWidth', 1.2)
yline(1, 'g', 'LineWidth', 1.2);
set(gca, 'XScale', 'log', 'YScale', 'log', 'FontSize', 13)
xlabel('Horizon Length $[Number \: of \: Samples]$', 'Interpreter', 'Latex', 'FontSize', 18)
ylabel('Ratio of Wall Time $[No \: Units]$', 'Interpreter', 'Latex', 'FontSize', 18)
