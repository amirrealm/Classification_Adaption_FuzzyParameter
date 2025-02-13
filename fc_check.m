function [] = fc_check(Manuel, Automatic, Test, KTX)
% This function checks the validity of input selections and data dimensions.
% It ensures that at least one classification method is selected (Supervised or Unsupervised)
% and that the dimensions of the test data match the expected input format.

%% Check Classification Mode Selection
if Manuel == 0 && Automatic == 0
    % Display error message if neither Supervised nor Unsupervised is selected
    msg = 'You should select either (Supervised or Unsupervised) mode.';
    fig = uifigure;
    uialert(fig, msg, "Invalid Selection");
end

%% Check Data Dimensions
T = size(Test.input, 2) - 2; % Compute expected feature dimension (excluding labels)

% Check if the test data dimension matches the expected input size
if Test.anzm ~= T
    msg = 'The dimension in OTX_Test is not correct.';
    fig = uifigure;
    uialert(fig, msg, "Dimension Mismatch");
end

% Check if the KTX data dimension also matches the expected input size
if KTX.anzm ~= T
    msg = 'The dimensions in OTX_Test and KTX are not correct.';
    fig = uifigure;
    uialert(fig, msg, "Dimension Mismatch");
end

end
