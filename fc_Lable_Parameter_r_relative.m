function [Parameter] = fc_Lable_Parameter_r_relative(Xinput, Parameter, idx)
% This function updates the 'r' parameter using a relative change-based adaptation method.
% The weight factor is dynamically computed based on the relative difference between the new and old values.
%
% Update formula:
% factor2 = |x_new - x_old| / x_old
% factor1 = 1 - factor2
% r_new = factor1 * r_old + factor2 * X_new

global vParameter_r_Supervise % Access global variable for tracking parameter changes

%% Extract Old and New Values
x_old = table2array(Parameter(:, "r"))'; % Convert table to array and transpose
x_new = table2array(Xinput); % Convert new input values to array format

% Compute relative change factor for each feature
F = abs(x_new - x_old) ./ x_old; % Normalized absolute difference

% Compute the updated 'r' values using relative weighting
for i = 1:size(Parameter, 1)
    factor2 = F(1, i); % Weight for the new input
    factor1 = 1 - factor2; % Weight for the old value
    change(1, i) = factor1 * x_old(1, i) + factor2 * x_new(1, i);
end

% Update the 'r' values in the Parameter structure
Parameter(:, "r") = array2table(change'); 

%% Store Updated Parameters for Tracking
% Determine the next available row index for tracking changes
idxx = size(vParameter_r_Supervise(idx).Relative, 1);
% Store the updated 'r' values in the tracking variable
vParameter_r_Supervise(idx).Relative(idxx + 1, :) = change;

end
