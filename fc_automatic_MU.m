function [MU_idx, idx] = fc_automatic_MU(Xinput, KTX)
% This function calculates the membership value (MU) for a given input sample
% and assigns it to the closest matching class in KTX using a fuzzy membership function.

MU = []; % Initialize membership value storage

% Loop over each class in KTX
for i = 1:KTX.anzk
    % Loop over each feature (dimension) in the class
    for j = 1:KTX.anzm
        % Extract input feature value
        X = table2array(Xinput(1, j));

        % Extract fuzzy parameters for the current class and feature
        r = table2array(KTX.class(i).class(j, 'r'));   % Reference value
        a = table2array(KTX.class(i).class(1, 'a'));   % Scaling parameter
        bl = table2array(KTX.class(i).class(j, 'bl')); % Left boundary parameter
        br = table2array(KTX.class(i).class(j, 'br')); % Right boundary parameter
        cl = table2array(KTX.class(i).class(j, 'cl')); % Left characteristic width
        cr = table2array(KTX.class(i).class(j, 'cr')); % Right characteristic width
        dl = table2array(KTX.class(i).class(j, 'dl')); % Left exponent
        dr = table2array(KTX.class(i).class(j, 'dr')); % Right exponent

        % Compute membership function value based on input position
        if X < r
            % Compute MU for values less than the reference point
            MU(1, j) = a / (1 + (((1 / bl) - 1) * ((r - X) / cl)^dl));
        else
            % Compute MU for values greater than or equal to the reference point
            MU(1, j) = a / (1 + (((1 / br) - 1) * ((X - r) / cr)^dr));
        end
    end

    % Compute the class-wise membership score
    MU_class(1, i) = (sum(MU.^-1) / KTX.anzm)^-1;  
end

% Find the class with the highest membership value
[MU_idx, idx] = max(MU_class);

end
