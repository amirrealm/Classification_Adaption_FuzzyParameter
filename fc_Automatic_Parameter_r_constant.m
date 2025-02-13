function [Parameter] = fc_Automatic_Parameter_r_constant(Xinput, Parameter, r, idx)
% This function updates the 'r' parameter using a weighted adaptation method.
% The new 'r' value is computed as a weighted sum of the old 'r' and the new input value.

global vParameter_r_Unsupervise % Access global variable for tracking parameter changes

%% Calculation of Weights
factor1 = r.Old_factor; % Weight assigned to old value of 'r'
factor2 = r.New_factor; % Weight assigned to new input value

% Extract old parameter values ('r') from the table
x_old = table2array(Parameter(:, "r"))'; % Transpose to match input format
x_new = table2array(Xinput); % Convert new input values to array format

% Compute the updated 'r' values using the weighted sum
for i = 1:size(Parameter, 1)
    change(1, i) = factor1 * x_old(1, i) + factor2 * x_new(1, i);
end

% Update the 'r' values in the Parameter structure
Parameter(:, "r") = array2table(change'); 

%% Store Updated Parameters for Tracking
% Determine the next available row index for tracking changes
idxx = size(vParameter_r_Unsupervise(idx).Constant, 1);
% Store the updated 'r' values in the tracking variable
vParameter_r_Unsupervise(idx).Constant(idxx + 1, :) = change;

end
