%% script_test_fcn_AVAR_generateWhiteNoise.m
% This script tests the function 'fcn_AVAR_generateWhiteNoise'
%
% This script was written on 2021_05_14 by Satya Prasad
% Questions or comments? szm888@psu.edu
% Updated: 2022/02/15

%% Prepare workspace
clear all %#ok<CLALL>
close all
clc

%% Intialization
rng('default') % set random seeds

%% Example 1: Reference
power_spectral_density = 0.0025; % PSD of white noise [unit^2 s]
sampling_frequency   = 20; % [Hz]
number_of_time_steps = 1000;

fcn_AVAR_generateWhiteNoise(power_spectral_density, sampling_frequency, ...
    number_of_time_steps, 12345); % generate white noise

%% Example 2: Increase 'power_spectral_density'
power_spectral_density = 0.005; % PSD of white noise [unit^2 s]
sampling_frequency   = 20; % [Hz]
number_of_time_steps = 1000;

fcn_AVAR_generateWhiteNoise(power_spectral_density, sampling_frequency, ...
    number_of_time_steps, 12346); % generate white noise

%% Example 3: Increase 'sampling_frequency'
power_spectral_density = 0.0025; % PSD of white noise [unit^2 s]
sampling_frequency   = 40; % [Hz]
number_of_time_steps = 1000;

fcn_AVAR_generateWhiteNoise(power_spectral_density, sampling_frequency, ...
    number_of_time_steps, 12347); % generate white noise

%% Example 4: Error in 'power_spectral_density'
power_spectral_density = -0.0025; % PSD of white noise [unit^2 s]
sampling_frequency   = 20; % [Hz]
number_of_time_steps = 1000;

fcn_AVAR_generateWhiteNoise(power_spectral_density, sampling_frequency, ...
    number_of_time_steps); % generate white noise

%% Example 5: Error in 'sampling_frequency'
power_spectral_density = 0.0025; % PSD of white noise [unit^2 s]
sampling_frequency   = -20; % [Hz]
number_of_time_steps = 1000;

fcn_AVAR_generateWhiteNoise(power_spectral_density, sampling_frequency, ...
    number_of_time_steps); % generate white noise

%% Example 6: Error in 'number_of_time_steps'
power_spectral_density = 0.0025; % PSD of white noise [unit^2 s]
sampling_frequency   = 20; % [Hz]
number_of_time_steps = 1000.2;

fcn_AVAR_generateWhiteNoise(power_spectral_density, sampling_frequency, ...
    number_of_time_steps); % generate white noise
