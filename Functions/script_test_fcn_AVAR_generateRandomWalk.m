%% script_test_fcn_AVAR_generateRandomWalk.m
% This script tests the function 'fcn_AVAR_generateRandomWalk'
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
random_walk_coefficient = 0.025; % [unit/sqrt(s)]
sampling_frequency      = 20; % [Hz]
number_of_time_steps    = 1000;

fcn_AVAR_generateRandomWalk(random_walk_coefficient, sampling_frequency, ...
    number_of_time_steps, 12345); % generate random walk

%% Example 2: Increase 'sampling frequency'
random_walk_coefficient = 0.025; % [unit/sqrt(s)]
sampling_frequency      = 40; % [Hz]
number_of_time_steps    = 1000;

fcn_AVAR_generateRandomWalk(random_walk_coefficient, sampling_frequency, ...
    number_of_time_steps, 12346); % generate random walk

%% Example 3: Increase 'random walk coefficient'
random_walk_coefficient = 0.05; % [unit/sqrt(s)]
sampling_frequency      = 20; % [Hz]
number_of_time_steps    = 1000;

fcn_AVAR_generateRandomWalk(random_walk_coefficient, sampling_frequency, ...
    number_of_time_steps, 12347); % generate random walk

%% Example 4: Error in 'random walk coefficient'
random_walk_coefficient = -0.025; % [unit/sqrt(s)]
sampling_frequency      = 20; % [Hz]
number_of_time_steps    = 1000;

fcn_AVAR_generateRandomWalk(random_walk_coefficient, sampling_frequency, ...
    number_of_time_steps); % generate random walk

%% Example 5: Error in 'sampling_frequency'
random_walk_coefficient = 0.025; % [unit/sqrt(s)]
sampling_frequency      = -20; % [Hz]
number_of_time_steps    = 1000;

fcn_AVAR_generateRandomWalk(random_walk_coefficient, sampling_frequency, ...
    number_of_time_steps); % generate random walk

%% Example 6: Error in 'number_of_time_steps'
random_walk_coefficient = 0.025; % [unit/sqrt(s)]
sampling_frequency      = 20; % [Hz]
number_of_time_steps    = 1000.2;

fcn_AVAR_generateRandomWalk(random_walk_coefficient, sampling_frequency, ...
    number_of_time_steps); % generate random walk
