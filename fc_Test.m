function MU_class = fc_Test(Otx_Test, Par, KTX)
% This function performs a fuzzy classification test on the input data and 
% assigns class labels based on the fuzzy membership functions.
% Input:
%   Otx_Test - Input test data with features (assumed to be a table)
%   Par - A structure array containing parameters for each class
%   KTX - A structure containing parameters for the test, including the number of classes and rules
% Output:
%   MU_class - A table containing the fuzzy membership values and predicted class labels

Data = Otx_Test.input(:, 3:end); % Extract the input data, starting from the third column

% Loop over each row in the input data (each test sample)
for Loop = 1:size(Data, 1)
    Xinput = Data(Loop, :); % Extract the current test input sample

    MU = []; % Initialize an empty array to store membership values

    % Loop over each class
    for i = 1:KTX.anzk
        % Loop over each rule in the class
        for j = 1:KTX.anzm
            % Extract the input feature, and parameters for the current rule
            X = table2array(Xinput(1, j)); % The input value for this feature
            r = table2array(Par(i).class(j, 'r')); % The threshold value for the rule
            a = table2array(Par(i).class(1, 'a')); % The scaling factor for the rule
            bl = table2array(Par(i).class(j, 'bl')); % Left boundary value for the rule
            br = table2array(Par(i).class(j, 'br')); % Right boundary value for the rule
            cl = table2array(Par(i).class(j, 'cl')); % Left shape parameter
            cr = table2array(Par(i).class(j, 'cr')); % Right shape parameter
            dl = table2array(Par(i).class(j, 'dl')); % Left steepness parameter
            dr = table2array(Par(i).class(j, 'dr')); % Right steepness parameter

            % Compute the fuzzy membership value based on the input feature
            if X < r
                MU(1, j) = a / (1 + (((1 / bl) - 1) * (((r - X) / cl) ^ dl))); % Left side of the membership function
            else
                MU(1, j) = a / (1 + (((1 / br) - 1) * (((X - r) / cr) ^ dr))); % Right side of the membership function
            end
        end

        % Compute the overall membership for the current class by averaging the individual rule memberships
        MU_class(Loop, i) = (sum(MU .^ -1) / KTX.anzm) ^ -1;  
    end

    % Determine the predicted class by selecting the class with the highest membership value
    [~, idx] = max(MU_class(Loop, 1:KTX.anzk));
    MU_class(Loop, KTX.anzk + 1) = idx; % Store the predicted class label
end

% Convert the results into a table format
MU_class = array2table(MU_class);

% Set the column names of the table
Var = MU_class.Properties.VariableNames;
T = size(Var, 2);
MU_class.Properties.VariableNames(T) = "Lable_Predict"; % Name the last column as "Lable_Predict"
end
