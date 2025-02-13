function [Parameter, NK_One] = fc_Lable_Parameter_r_Nk_One(Xinput, Parameter, NK_One, idx)
% This function updates the 'r' parameter using an adaptive method based on NK_One.
% The weight factors dynamically adjust based on NK_One(idx,1).
%
% Update formula:
% factor1 = NK_One / (NK_One + 1)
% factor2 = 1 / (NK_One + 1)
% r_new = factor1 * r_old + factor2 * X_new

global vParameter_r_Supervise % Access global variable for tracking parameter changes

%% Calculation of Weights
factor1 = NK_One(idx, 1) / (NK_One(idx, 1) + 1); % Weight assigned to old value of 'r'
factor2 = 1 / (NK_One(idx, 1) + 1); % Weight assigned to new input value

% Extract old parameter values ('r') from the table
x_old = table2array(Parameter(:, "r"))'; % Convert table to array and transpose
x_new = table2array(Xinput); % Convert new input values to array format

% Increment NK_One counter for this class
NK_One(idx, 1) = NK_One(idx, 1) + 1;

% Compute the updated 'r' values using the weighted sum
for i = 1:size(Parameter, 1)
    change(1, i) = factor1 * x_old(1, i) + factor2 * x_new(1, i);
end

% Update the 'r' values in the Parameter structure
Parameter(:, "r") = array2table(change'); 

%% Store Updated Parameters for Tracking
% Determine the next available row index for tracking changes
idxx = size(vParameter_r_Supervise(idx).NK_One, 1);
% Store the updated 'r' values in the tracking variable
vParameter_r_Supervise(idx).NK_One(idxx + 1, :) = change;

end
