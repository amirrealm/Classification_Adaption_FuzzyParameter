function [Parameter] = fc_Lable_Parameter_r_MU(Xinput, Parameter, MU, idx)
% This function updates the 'r' parameter using a membership function-based adaptation method.
% The weight factors are dynamically computed based on the membership function (MU).
%
% Update formula:
% factor1 = 1 / (MU + 1)
% factor2 = MU / (MU + 1)
% r_new = factor1 * r_old + factor2 * X_new

global vParameter_r_Supervise % Access global variable for tracking parameter changes

%% Calculation of Weights
factor1 = 1 / (MU + 1); % Weight assigned to old value of 'r'
factor2 = MU / (MU + 1); % Weight assigned to new input value

% Extract old parameter values ('r') from the table
x_old = table2array(Parameter(:, "r"))'; % Convert table to array and transpose
x_new = table2array(Xinput); % Convert new input values to array format

% Compute the updated 'r' values using the weighted sum
for i = 1:size(Parameter, 1)
    change(1, i) = factor1 * x_old(1, i) + factor2 * x_new(1, i);
end

% Update the 'r' values in the Parameter structure
Parameter(:, "r") = array2table(change'); 

%% Store Updated Parameters for Tracking
% Determine the next available row index for tracking changes
idxx = size(vParameter_r_Supervise(idx).MU, 1);
% Store the updated 'r' values in the tracking variable
vParameter_r_Supervise(idx).MU(idxx + 1, :) = change;

end
