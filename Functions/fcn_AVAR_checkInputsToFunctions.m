function fcn_AVAR_checkInputsToFunctions(variable,variable_type_string)
%% fcn_AVAR_checkInputsToFunctions
%   Checks the variable types commonly used in the AVAR library to ensure 
%   that they are correctly formed. This function is typically called at 
%   the top of most functions in AVAR library. The input is a variable and 
%   a string defining the "type" of the variable. This function checks to 
%   see that they are compatible.
%
% FORMAT:
%
%      fcn_AVAR_checkInputsToFunctions(variable,variable_type_string)
%
% INPUTS:
%
%   variable: the variable to check
%   variable_type_string: a string representing the variable type to check.
%   The current strings include:
%       'string': A string input
%
%       'number': A real number.
%
%       'non negative': A non-negative number.
%
%       'positive': A positive number.
%
%       'positive integer': A positive integer.
%
%       'avar': A M x 1 vector of non-negative numbers.
%
%       'correlation time': A M x 1 vector of increasing positive numbers.
%
%       'avar data': A N x 1 vector of real numbers.
%
%       'mavar data': A N x k vector of real numbers.
%
%       'avar interval': A M x 1 vector of increasing positive integers.
%
%       'favar data': A N x 1 vector of real numbers, where N is of the 
%           form 2^p+1 (p >= 2).
%
%       'mfavar data': A N x k vector of real numbers, where N is of the 
%           form 2^p+1 (p >= 2).
%
%       'favar weights': A N x 1 vector of non-negative numbers, where N is 
%           of the form 2^p+1 (p >= 2).
%
%       'favar interval': A M x 1 vector of increasing numbers of form 2^p 
%           (p >= 1).
%
%       'dfavar data': A N x 1 vector of real numbers, where N is of the 
%           form 2^p+2 (p >= 2).
%
%       'dfavar weights': A N x 1 vector of non-negative numbers, where N 
%           is of the form 2^p+2 (p >= 2).
%
%       'time vector': A N x 1 vector of non-decreasing non-negative 
%           numbers or NaN.
%
%       'probability': It should lie between 0 and 1.
%
%   Note that the variable_type_string is not case sensitive: for example, 
%   'avar' and 'Avar' or 'AVAR' all give the same result.
%
% OUTPUTS:
%
%   No explicit outputs, but produces MATLAB error outputs if conditions
%   not met, with explanation within the error outputs of the problem.
%
% This function was written on 2021_05_15 by Satya Prasad
% Questions or comments? szm888@psu.edu
%

flag_do_debug = 0; % Flag to debug the results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1, 'STARTING function: %s, in file: %s\n', st(1).name, st(1).file);
end

%% check input arguments
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
if 1 == flag_check_inputs
    % Are there the right number of inputs?
    if 2~=nargin
        error('Incorrect number of input arguments')
    end
    
    % Check the string input, make sure it is characters
    if ~ischar(variable_type_string)
        error('The variable_type_string input must be a string type, for example: ''Integer'' ');
    end
end

%% Start of main code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
variable_name = inputname(1); % Grab the variable name
variable_type_string = lower(variable_type_string); % Make the variable lower case

%% A String
if strcmpi(variable_type_string,'string')
    % Check if the input type is 'string'
    if ~ischar(variable)
        error('The %s input must be string', variable_name);
    end
end

%% Any Real Number
if strcmpi(variable_type_string,'number')
    % Check if the input type is 'real number'
    if ~isnumeric(variable) || ~isreal(variable) || 1~=numel(variable)
        error('The %s input must be a real number', variable_name);
    end
end

%% Non-Negative Number
if strcmpi(variable_type_string,'non negative')
    % Check if the input type is 'non-negative real number'
    if ~isnumeric(variable) || ~isreal(variable) || 1~=numel(variable) ...
            || 0>variable
        error('The %s input must be a non-negative number', variable_name);
    end
end

%% Non-Negative Integer
if strcmpi(variable_type_string,'non negative integer')
    % Check if the input type is 'non-negative integer'
    if ~isnumeric(variable) || ~isreal(variable) || 1~=numel(variable) ...
            || 0>variable || floor(variable)~=variable
        error('The %s input must be a non-negative integer', variable_name);
    end
end

%% Positive Real Number
if strcmpi(variable_type_string,'positive')
    % Check if the input type is 'positive real number'
    if ~isnumeric(variable) || ~isreal(variable) || 1~=numel(variable) ...
            || 0>=variable
        error('The %s input must be a positive number', variable_name);
    end
end

%% Positive Integer
if strcmpi(variable_type_string,'positive integer')
    % Check if the input type is 'positive integer'
    if ~isnumeric(variable) || ~isreal(variable) || 1~=numel(variable) || ...
            0>=variable || floor(variable)~=variable
        error('The %s input must be a positive integer', variable_name);
    end
end

%% AVAR
if strcmpi(variable_type_string,'avar')
    % Check if the input type is 'avar'
    if ~isnumeric(variable) || ~isreal(variable) || 1~=size(variable,2) || ...
            any(0>variable)
        error('The %s input must be a M x 1 vector of non-negative numbers', variable_name);
    end
end

%% Correlation Time
if strcmpi(variable_type_string,'correlation time')
    % Check if the input type is 'correlation time'
    if ~isnumeric(variable) || ~isreal(variable) || 1~=size(variable,2) || ...
            any(0>=variable)
        error('The %s input must be a M x 1 vector of increasing positive numbers', variable_name);
    end
end

%% Data for calculating AVAR using normal algorithm
if strcmpi(variable_type_string,'avar data')
    % Check if the input type is 'avar data'
    if ~isnumeric(variable) || ~isreal(variable) || 1~=size(variable,2)
        error('The %s input must be a N x 1 vector of real numbers', variable_name);
    end
end

%% Data for calculating k-dimensional AVAR using normal algorithm
if strcmpi(variable_type_string,'mavar data')
    % Check if the input type is 'mavar data'
    if any(~isnumeric(variable)) || any(~isreal(variable))
        error('The %s input must be a N x k vector of real numbers', variable_name);
    end
end

%% List of correlation intervals for calculating AVAR using normal algorithm
if strcmpi(variable_type_string,'avar interval')
    % Check if the input type is 'avar interval'
    if ~isnumeric(variable) || ~isreal(variable) || 1~=size(variable,2) || ...
            any(0>=variable) || any(floor(variable)~=variable) || any(0>=diff(variable))
        error('The %s input must be a M x 1 vector of increasing positive integers', variable_name);
    end
end

%% Data for calculating AVAR using FAVAR algorithm
if strcmpi(variable_type_string,'favar data')
    % Check if the input type is 'favar data'
    number_of_datapoints = size(variable,1);
    p = floor(log2(number_of_datapoints));
    if ~isnumeric(variable) || ~isreal(variable) || 1~=size(variable,2) || ...
            (2^p+1~=number_of_datapoints) || 5>number_of_datapoints
        error('The %s input must be a N x 1 vector of real numbers, where N is of the form 2^p+1 (p >= 2)', variable_name);
    end
end

%% Data for calculating AVAR using FAVAR algorithm with Trimming Possible
if strcmpi(variable_type_string,'favar dataT')
    % Check if the input type is 'favar dataT'
    if ~isnumeric(variable) || ~isreal(variable) || 1~=size(variable,2) || ...
            3>size(variable,1)
        error('The %s input must be a N x 1 vector of real numbers, where N >= 3', variable_name);
    end
end

%% Data for calculating k-dimensional AVAR using FAVAR algorithm
if strcmpi(variable_type_string,'mfavar data')
    % Check if the input type is 'mfavar data'
    number_of_datapoints = size(variable,1);
    p = floor(log2(number_of_datapoints));
    if ~isnumeric(variable) || ~isreal(variable) || ...
            (2^p+1~=number_of_datapoints) || 5>number_of_datapoints
        error('The %s input must be a N x k vector of real numbers, where N is of the form 2^p+1 (p >= 2)', variable_name);
    end
end

%% Weights for calculating AVAR using FAVAR algorithm
if strcmpi(variable_type_string,'favar weightsT')
    % Check if the input type is 'favar weightsT'
    if any(~isnumeric(variable)) || any(~isreal(variable)) || ...
            1~=size(variable,2) || 5>size(variable,1) || any(0>variable)
        error('The %s input must be a N x 1 vector of non-negative numbers, where N >= 5', variable_name);
    end
end

%% Weights for calculating AVAR using FAVAR algorithm with Trimming possible
if strcmpi(variable_type_string,'favar weights')
    % Check if the input type is 'favar weights'
    number_of_datapoints = size(variable,1);
    p = floor(log2(number_of_datapoints));
    if any(~isnumeric(variable)) || any(~isreal(variable)) || ...
            1~=size(variable,2) || (2^p+1~=number_of_datapoints) || ...
            5>number_of_datapoints || any(0>variable)
        error('The %s input must be a N x 1 vector of non-negative numbers, where N is of the form 2^p+1 (p >= 2)', variable_name);
    end
end

%% List of correlation intervals for calculating AVAR/DAVAR using FAVAR algorithm
if strcmpi(variable_type_string,'favar interval')
    % Check if the input type is 'favar interval'
    if ~isnumeric(variable) || ~isreal(variable) || 1~=size(variable,2) || ...
            any(1>variable) || any(floor(log2(variable))~=log2(variable)) || ...
            any(1~=diff(log2(variable)))
        error('The %s input must be a M x 1 vector of increasing numbers of form 2^p (p >= 0)', variable_name);
    end
end

%% Data for calculating DAVAR using FAVAR algorithm
if strcmpi(variable_type_string,'dfavar data')
    % Check if the input type is 'dfavar data'
    number_of_datapoints = size(variable,1);
    p = floor(log2(number_of_datapoints));
    if ~isnumeric(variable) || ~isreal(variable) || 1~=size(variable,2) || ...
            (2^p+2~=number_of_datapoints) || 6>number_of_datapoints
        error('The %s input must be a N x 1 vector of real numbers, where N is of the form 2^p+2 (p >= 2)', variable_name);
    end
end

%% Weights for calculating DAVAR using FAVAR algorithm
if strcmpi(variable_type_string, 'dfavar weights')
    % Check if the input type is 'dfavar weights'
    number_of_datapoints = size(variable,1);
    p = floor(log2(number_of_datapoints));
    if any(~isnumeric(variable)) || any(~isreal(variable)) || ...
            1~=size(variable,2) || (2^p+2~=number_of_datapoints) || ...
            6>number_of_datapoints || any(0>variable)
        error('The %s input must be a N x 1 vector of non-negative numbers, where N is of the form 2^p+2 (p >= 2)', variable_name);
    end
end

%% Time vector
if strcmpi(variable_type_string,'time vector')
    % Check if the input type is 'time vector'
    if any(~isnumeric(variable)) || any(~isreal(variable)) || ...
            1~=size(variable,2) || any(0>variable) || any(0>diff(variable))
        error('The %s input must be a N x 1 vector of non-decreasing non-negative numbers', variable_name);
    end
end

%% Probability
if strcmpi(variable_type_string,'probability')
    % Check if the input type is 'probability'
    if ~isnumeric(variable) || ~isreal(variable) || 1~=numel(variable) || ...
            0>variable || 1<variable
        error('The %s input must lie between 0 and 1', variable_name);
    end
end

%% Quantization Constant
if strcmpi(variable_type_string,'quantization constant')
    % Check if the input type is 'quantization constant'
    if any(~isnumeric(variable)) || any(~isreal(variable)) || ...
            1~=numel(variable) || any(1>variable | 2<variable)
        error('The %s input must be a number in the interval [1,2]', variable_name);
    end
end

%% Debugging?
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
if flag_do_debug
    fprintf(1, 'The variable: %s was checked that it meets type: %s, and no errors were detected.\n', variable_name, variable_type_string);
    fprintf(1, 'ENDING function: %s, in file: %s\n\n', st(1).name, st(1).file);
end

end