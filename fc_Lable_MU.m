function MU_class = fc_Lable_MU(Xinput, KTX, idx)
% This function calculates the membership value (MU) for a given input sample.
% It assigns the membership value based on the labeled class index (idx) in KTX.
%
% The membership function is computed using a sigmoid-like transformation.

MU = []; % Initialize membership value storage

%% Compute membership function value for each feature
for j = 1:KTX.anzm
    % Extract input feature value
    X = table2array(Xinput(1, j));

    % Extract fuzzy parameters for the current class and feature
    r = table2array(KTX.class(idx).class(j, 'r'));   % Reference value
    a = table2array(KTX.class(idx).class(1, 'a'));   % Scaling parameter
    bl = table2array(KTX.class(idx).class(j, 'bl')); % Left boundary parameter
    br = table2array(KTX.class(idx).class(j, 'br')); % Right boundary parameter
    cl = table2array(KTX.class(idx).class(j, 'cl')); % Left characteristic width
    cr = table2array(KTX.class(idx).class(j, 'cr')); % Right characteristic width
    dl = table2array(KTX.class(idx).class(j, 'dl')); % Left exponent
    dr = table2array(KTX.class(idx).class(j, 'dr')); % Right exponent

    % Compute membership function value based on input position
    if X < r
        % Compute MU for values less than the reference point
        MU(1, j) = a / (1 + (((1 / bl) - 1) * ((r - X) / cl)^dl));
    else
        % Compute MU for values greater than or equal to the reference point
        MU(1, j) = a / (1 + (((1 / br) - 1) * ((X - r) / cr)^dr));
    end
end

%% Compute the final class-wise membership score
MU_class = (sum(MU.^-1) / KTX.anzm)^-1;  

end
