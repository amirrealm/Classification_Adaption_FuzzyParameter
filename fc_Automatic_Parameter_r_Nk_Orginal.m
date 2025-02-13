function [Parameter, NK_Orginal] = fc_Automatic_Parameter_r_Nk_Orginal(Xinput, Parameter, NK_Orginal, idx)
% This function updates the 'r' parameter using an adaptive method based on NK_Orginal.
% The weight factors dynamically adjust based on NK_Orginal(idx,1).
%
% Update formula:
% r_new = (NK_Orginal / (NK_Orginal + 1)) * r_old + (1 / (NK_Orginal + 1)) * X_new

global vParameter_r_Unsupervise % Access global variable for tracking parameter changes

%% Calculation of Weights
factor1 = NK_Orginal(idx, 1) / (NK_Orginal(idx, 1) + 1); % Weight assigned to old value of 'r'
factor2 = 1 / (NK_Orginal(idx, 1) + 1); % Weight assigned to new input value

% Extract old parameter values ('r') from the table
x_old = table2array(Parameter(:, "r"))'; % Convert table to array and transpose
x_new = table2array(Xinput); % Convert new input values to array format

% Increment NK_Orginal counter for this class
NK_Orginal(idx, 1) = NK_Orginal(idx, 1) + 1;

% Compute the updated 'r' values using the weighted sum
for i = 1:size(Parameter, 1)
    change(1, i) = factor1 * x_old(1, i) + factor2 * x_new(1, i);
end

% Update the 'r' values in the Parameter structure
Parameter(:, "r") = array2table(change'); 

%% Store Updated Parameters for Tracking
% Determine the next available row index for tracking changes
idxx = size(vParameter_r_Unsupervise(idx).NK_Orginal, 1);
% Store the updated 'r' values in the tracking variable
vParameter_r_Unsupervise(idx).NK_Orginal(idxx + 1, :) = change;

end
