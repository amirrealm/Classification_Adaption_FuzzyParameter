clear all; clc; close all; 

%% File Paths
% Define paths to the required files (KTX, OTX, Test data)
KTX = "Colorexperiment1-2d4k-ug.ktx";  
% KTX file selection (Color experiment data)

OTX = "Tag2d.otx";  
% OTX file selection (Tagging data for classification)

Test = "Tag2d.otx";  
% Test data selection (Same as OTX file)

%% Settings Area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Classification Mode Selection
Supervised = true;    % Enable supervised learning mode
UnSupervised = true;  % Enable unsupervised learning mode

% Save Adaptations
Save_Adaption = true; % Enable saving of adaptive changes

% Accuracy Display Options
Confusion_Matrix = true; % Enable confusion matrix display
MU_Accuracy = true;      % Enable Mean-Unit accuracy display

%% Adaptation Parameters
% Parameters for adapting 'r' in classification
r.NK_orginal = true; % Use original NK adaptation
r.NK_one = true;     % Use single NK adaptation
r.MU = true;         % Enable Mean-Unit adaptation
r.relative = true;   % Use relative adaptation method
r.constant = true;   % Use constant adaptation method

% Weighting Factors for Adaptation
r.Old_factor = 0.8;   % Weight for old data
r.New_factor = 1 - r.Old_factor; % Compute weight for new data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract file name from the full path for KTX file
myKTX = split(KTX, "\");             % Split file path by backslash "\"
Data_KTX = myKTX(end, 1);            % Extract the file name (last element of the split path)
clear KTX myKTX;                     % Clear unnecessary variables
KTX = readktx(Data_KTX);             % Read the KTX file using the custom function `readktx`
clear Data_KTX;                      % Clear temporary variable

% Extract file name from the full path for OTX file
myOTX = split(OTX, "\");             % Split file path by backslash "\"
Data_OTX = myOTX(end, 1);            % Extract the file name (last element of the split path)
clear OTX myOTX;                     % Clear unnecessary variables
OTX = readotx(Data_OTX);             % Read the OTX file using the custom function `readotx`
clear Data_OTX;                      % Clear temporary variable

% Extract file name from the full path for Test data file
myTest = split(Test, "\");           % Split file path by backslash "\"
Data_Test = myTest(end, 1);          % Extract the file name (last element of the split path)
clear Test myTest;                   % Clear unnecessary variables
Test = readotx(Data_Test);           % Read the test file using the custom function `readotx`
clear Data_Test;                     % Clear temporary variable

% Perform a classification check using the function `fc_check`
fc_check(Supervised, UnSupervised, Test, KTX);

% Define global variables for classification parameters and accuracy tracking
global vParameter_r_Unsupervise vParameter_r_Supervise ACC_Unsupervise ACC_Supervise

% Initialize parameter tracking for supervised and unsupervised learning
vParameter_r_Unsupervise = fc_Verlauf(KTX.anzk);  % Track parameter evolution in unsupervised mode
vParameter_r_Supervise = fc_Verlauf(KTX.anzk);    % Track parameter evolution in supervised mode

% Initialize accuracy tracking for supervised and unsupervised learning
ACC_Unsupervise = fc_Verlauf2();        % Accuracy tracking for unsupervised mode
Lable_ACC_Unsupervise = fc_Verlauf2();  % Label accuracy tracking for unsupervised mode
MU_ACC_Unsupervise = fc_Verlauf2();     % Mean-unit accuracy tracking for unsupervised mode

ACC_Supervise = fc_Verlauf2();          % Accuracy tracking for supervised mode
Lable_ACC_Supervise = fc_Verlauf2();    % Label accuracy tracking for supervised mode
MU_ACC_Supervise = fc_Verlauf2();       % Mean-unit accuracy tracking for supervised mode

% Calculation of Parameter 'r' based on selected learning mode

% If unsupervised learning is enabled, compute adaptation parameters automatically
if UnSupervised == 1
   Adaption_Parameter_UnSupervised = fc_Automatic(KTX, OTX, r);
   % Calls `fc_Automatic` function to calculate adaptation parameters in unsupervised mode
   % Uses KTX (data), OTX (labels), and parameter 'r' for adaptation
end

% If supervised learning is enabled, compute adaptation parameters based on labels
if Supervised == 1
   Adaption_Parameter_Supervised = fc_Lable(KTX, OTX, r);
   % Calls `fc_Lable` function to compute adaptation parameters in supervised mode
   % Uses KTX (data), OTX (labels), and parameter 'r' for adaptation
end

%%
%% Accuracy Evaluation for Unsupervised Learning
if UnSupervised == 1
    % Evaluate accuracy using different adaptation methods for Unsupervised Learning
    
    if r.NK_orginal == 1
        % Test using NK_Original adaptation
        Par_Test = Adaption_Parameter_UnSupervised.AParameter_NK_Orginal_Unsupervised;
        ACC_Unsupervise.NK_Orginal = fc_Test(Test, Par_Test, KTX); 
        clear Par_Test;
    end
    
    if r.NK_one == 1
        % Test using NK_One adaptation
        Par_Test = Adaption_Parameter_UnSupervised.AParameter_NK_One_Unsupervised;
        ACC_Unsupervise.NK_One = fc_Test(Test, Par_Test, KTX);
        clear Par_Test;
    end
    
    if r.MU == 1
        % Test using Mean-Unit (MU) adaptation
        Par_Test = Adaption_Parameter_UnSupervised.AParameter_MU_Unsupervised;
        ACC_Unsupervise.MU = fc_Test(Test, Par_Test, KTX);
        clear Par_Test;
    end
    
    if r.relative == 1
        % Test using Constant adaptation
        Par_Test = Adaption_Parameter_UnSupervised.AParameter_Constant_Unsupervised;
        ACC_Unsupervise.Constant = fc_Test(Test, Par_Test, KTX);
        clear Par_Test;
    end
    
    if r.constant == 1
        % Test using Relative adaptation
        Par_Test = Adaption_Parameter_UnSupervised.AParameter_relative_Unsupervised;
        ACC_Unsupervise.Relative = fc_Test(Test, Par_Test, KTX);
        clear Par_Test;
    end
end

%% Accuracy Evaluation for Supervised Learning
if Supervised == 1
    % Evaluate accuracy using different adaptation methods for Supervised Learning
    
    if r.NK_orginal == 1
        % Test using NK_Original adaptation
        Par_Test = Adaption_Parameter_Supervised.AParameter_NK_Orginal_Supervised;
        ACC_Supervise.NK_Orginal = fc_Test(Test, Par_Test, KTX); 
        clear Par_Test;
    end
    
    if r.NK_one == 1
        % Test using NK_One adaptation
        Par_Test = Adaption_Parameter_Supervised.AParameter_NK_One_Supervised;
        ACC_Supervise.NK_One = fc_Test(Test, Par_Test, KTX);
        clear Par_Test;
    end
    
    if r.MU == 1
        % Test using Mean-Unit (MU) adaptation
        Par_Test = Adaption_Parameter_Supervised.AParameter_MU_Supervised;
        ACC_Supervise.MU = fc_Test(Test, Par_Test, KTX);
        clear Par_Test;
    end
    
    if r.relative == 1
        % Test using Constant adaptation
        Par_Test = Adaption_Parameter_Supervised.AParameter_Constant_Supervised;
        ACC_Supervise.Constant = fc_Test(Test, Par_Test, KTX);
        clear Par_Test;
    end
    
    if r.constant == 1
        % Test using Relative adaptation
        Par_Test = Adaption_Parameter_Supervised.AParameter_relative_Supervised;
        ACC_Supervise.Relative = fc_Test(Test, Par_Test, KTX);
        clear Par_Test;
    end
end
%%
% Plot Confusion Matrix and Accuracy Comparison if enabled
if Confusion_Matrix == 1
    % Extract ground truth labels from test data
    g1 = Test.input.Lable;  % Known groups (true labels)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Unsupervised Learning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Plot confusion matrix for NK_Original adaptation
    if r.NK_orginal == 1
        g2 = ACC_Unsupervise.NK_Orginal.Lable_Predict; % Predicted labels
        figure()
        cm = confusionchart(g1, g2);
        cm.RowSummary = 'row-normalized';
        title('Adaption Parameter: UnSupervised NK-Orginal')
        
        % Compute classification accuracy for each class
        for i = 1:size(cm.NormalizedValues, 1)
            ACC(1, i) = (cm.NormalizedValues(i, i) / sum(cm.NormalizedValues(i, :))) * 100;
        end
        Lable_ACC_Unsupervise.NK_Orginal = mean(ACC); clear ACC
    end

    % Plot confusion matrix for NK_One adaptation
    if r.NK_one == 1
        g2 = ACC_Unsupervise.NK_One.Lable_Predict;
        figure()
        cm = confusionchart(g1, g2);
        cm.RowSummary = 'row-normalized';
        title('Adaption Parameter: UnSupervised NK-One')
        
        for i = 1:size(cm.NormalizedValues, 1)
            ACC(1, i) = (cm.NormalizedValues(i, i) / sum(cm.NormalizedValues(i, :))) * 100;
        end
        Lable_ACC_Unsupervise.NK_One = mean(ACC); clear ACC
    end

    % Plot confusion matrix for MU adaptation
    if r.MU == 1
        g2 = ACC_Unsupervise.MU.Lable_Predict;
        figure()
        cm = confusionchart(g1, g2);
        cm.RowSummary = 'row-normalized';
        title('Adaption Parameter: UnSupervised MU')
        
        for i = 1:size(cm.NormalizedValues, 1)
            ACC(1, i) = (cm.NormalizedValues(i, i) / sum(cm.NormalizedValues(i, :))) * 100;
        end
        Lable_ACC_Unsupervise.MU = mean(ACC); clear ACC
    end

    % Plot confusion matrix for Constant adaptation
    if r.constant == 1
        g2 = ACC_Unsupervise.Constant.Lable_Predict;
        figure()
        cm = confusionchart(g1, g2);
        cm.RowSummary = 'row-normalized';
        title('Adaption Parameter: UnSupervised Constant')
        
        for i = 1:size(cm.NormalizedValues, 1)
            ACC(1, i) = (cm.NormalizedValues(i, i) / sum(cm.NormalizedValues(i, :))) * 100;
        end
        Lable_ACC_Unsupervise.Constant = mean(ACC); clear ACC
    end

    % Plot confusion matrix for Relative adaptation
    if r.relative == 1
        g2 = ACC_Unsupervise.Relative.Lable_Predict;
        figure()
        cm = confusionchart(g1, g2);
        cm.RowSummary = 'row-normalized';
        title('Adaption Parameter: UnSupervised Relative')
        
        for i = 1:size(cm.NormalizedValues, 1)
            ACC(1, i) = (cm.NormalizedValues(i, i) / sum(cm.NormalizedValues(i, :))) * 100;
        end
        Lable_ACC_Unsupervise.Relative = mean(ACC); clear ACC
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Supervised Learning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Plot confusion matrix for NK_Original adaptation
    if r.NK_orginal == 1
        g2 = ACC_Supervise.NK_Orginal.Lable_Predict;
        figure()
        cm = confusionchart(g1, g2);
        cm.RowSummary = 'row-normalized';
        title('Adaption Parameter: Supervised NK-Orginal')
        
        for i = 1:size(cm.NormalizedValues, 1)
            ACC(1, i) = (cm.NormalizedValues(i, i) / sum(cm.NormalizedValues(i, :))) * 100;
        end
        Lable_ACC_Supervise.NK_Orginal = mean(ACC); clear ACC
    end

    % Plot confusion matrix for NK_One adaptation
    if r.NK_one == 1
        g2 = ACC_Supervise.NK_One.Lable_Predict;
        figure()
        cm = confusionchart(g1, g2);
        cm.RowSummary = 'row-normalized';
        title('Adaption Parameter: Supervised NK-One')
        
        for i = 1:size(cm.NormalizedValues, 1)
            ACC(1, i) = (cm.NormalizedValues(i, i) / sum(cm.NormalizedValues(i, :))) * 100;
        end
        Lable_ACC_Supervise.NK_One = mean(ACC); clear ACC
    end

    % Plot confusion matrix for MU adaptation
    if r.MU == 1
        g2 = ACC_Supervise.MU.Lable_Predict;
        figure()
        cm = confusionchart(g1, g2);
        cm.RowSummary = 'row-normalized';
        title('Adaption Parameter: Supervised MU')
        
        for i = 1:size(cm.NormalizedValues, 1)
            ACC(1, i) = (cm.NormalizedValues(i, i) / sum(cm.NormalizedValues(i, :))) * 100;
        end
        Lable_ACC_Supervise.MU = mean(ACC); clear ACC
    end

    % Plot confusion matrix for Constant adaptation
    if r.constant == 1
        g2 = ACC_Supervise.Constant.Lable_Predict;
        figure()
        cm = confusionchart(g1, g2);
        cm.RowSummary = 'row-normalized';
        title('Adaption Parameter: Supervised Constant')
        
        for i = 1:size(cm.NormalizedValues, 1)
            ACC(1, i) = (cm.NormalizedValues(i, i) / sum(cm.NormalizedValues(i, :))) * 100;
        end
        Lable_ACC_Supervise.Constant = mean(ACC); clear ACC
    end

    % Plot confusion matrix for Relative adaptation
    if r.relative == 1
        g2 = ACC_Supervise.Relative.Lable_Predict;
        figure()
        cm = confusionchart(g1, g2);
        cm.RowSummary = 'row-normalized';
        title('Adaption Parameter: Supervised Relative')
        
        for i = 1:size(cm.NormalizedValues, 1)
            ACC(1, i) = (cm.NormalizedValues(i, i) / sum(cm.NormalizedValues(i, :))) * 100;
        end
        Lable_ACC_Supervise.Relative = mean(ACC); clear ACC
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Accuracy Comparison Bar Chart %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Define labels for different adaptation methods
    X1 = ["NK-Orginal", "NK-One", "MU", "Constant", "Relative"];
    
    % Collect accuracy values for supervised and unsupervised methods
    Y1 = [Lable_ACC_Supervise.NK_Orginal, Lable_ACC_Supervise.NK_One, ...
          Lable_ACC_Supervise.MU, Lable_ACC_Supervise.Constant, ...
          Lable_ACC_Supervise.Relative];

    Y2 = [Lable_ACC_Unsupervise.NK_Orginal, Lable_ACC_Unsupervise.NK_One, ...
          Lable_ACC_Unsupervise.MU, Lable_ACC_Unsupervise.Constant, ...
          Lable_ACC_Unsupervise.Relative];

    Y = [Y1; Y2]; % Combine accuracy values
    Y = round(Y); % Round values for better visualization

    % Create bar chart
    figure()
    b = bar(X1, Y);
    
    % Add labels to the bars for Supervised accuracy
    xtips1 = b(1).XEndPoints;
    ytips1 = b(1).YEndPoints;
    labels1 = string(b(1).YData);
    text(xtips1, ytips1, labels1, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')

    % Add labels to the bars for Unsupervised accuracy
    xtips2 = b(2).XEndPoints;
    ytips2 = b(2).YEndPoints;
    labels2 = string(b(2).YData);
    text(xtips2, ytips2, labels2, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')

    grid on
    legend('Supervised', 'UnSupervised')
end
%%
% Compute Mean Membership Function Accuracy if enabled
if MU_Accuracy == 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Unsupervised Learning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Compute mean accuracy for NK_Original adaptation
    if ~isempty(ACC_Unsupervise.NK_Orginal)
        for i = 1:KTX.anzk
            A(1, i) = table2array(mean(ACC_Unsupervise.NK_Orginal(:, i)));   
        end
        MU_ACC_Unsupervise.NK_Orginal = mean(A); clear A   
    end

    % Compute mean accuracy for NK_One adaptation
    if ~isempty(ACC_Unsupervise.NK_One)
        for i = 1:KTX.anzk
            A(1, i) = table2array(mean(ACC_Unsupervise.NK_One(:, i)));   
        end
        MU_ACC_Unsupervise.NK_One = mean(A); clear A   
    end

    % Compute mean accuracy for MU adaptation
    if ~isempty(ACC_Unsupervise.MU)
        for i = 1:KTX.anzk
            A(1, i) = table2array(mean(ACC_Unsupervise.MU(:, i)));   
        end
        MU_ACC_Unsupervise.MU = mean(A); clear A   
    end

    % Compute mean accuracy for Constant adaptation
    if ~isempty(ACC_Unsupervise.Constant)
        for i = 1:KTX.anzk
            A(1, i) = table2array(mean(ACC_Unsupervise.Constant(:, i)));   
        end
        MU_ACC_Unsupervise.Constant = mean(A); clear A   
    end

    % Compute mean accuracy for Relative adaptation
    if ~isempty(ACC_Unsupervise.Relative)
        for i = 1:KTX.anzk
            A(1, i) = table2array(mean(ACC_Unsupervise.Relative(:, i)));   
        end
        MU_ACC_Unsupervise.Relative = mean(A); clear A   
    end 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Supervised Learning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Compute mean accuracy for NK_Original adaptation
    if ~isempty(ACC_Supervise.NK_Orginal)
        for i = 1:KTX.anzk
            A(1, i) = table2array(mean(ACC_Supervise.NK_Orginal(:, i)));   
        end
        MU_ACC_Supervise.NK_Orginal = mean(A); clear A   
    end

    % Compute mean accuracy for NK_One adaptation
    if ~isempty(ACC_Supervise.NK_One)
        for i = 1:KTX.anzk
            A(1, i) = table2array(mean(ACC_Supervise.NK_One(:, i)));   
        end
        MU_ACC_Supervise.NK_One = mean(A); clear A   
    end

    % Compute mean accuracy for MU adaptation
    if ~isempty(ACC_Supervise.MU)
        for i = 1:KTX.anzk
            A(1, i) = table2array(mean(ACC_Supervise.MU(:, i)));   
        end
        MU_ACC_Supervise.MU = mean(A); clear A   
    end

    % Compute mean accuracy for Constant adaptation
    if ~isempty(ACC_Supervise.Constant)
        for i = 1:KTX.anzk
            A(1, i) = table2array(mean(ACC_Supervise.Constant(:, i)));   
        end
        MU_ACC_Supervise.Constant = mean(A); clear A   
    end

    % Compute mean accuracy for Relative adaptation
    if ~isempty(ACC_Supervise.Relative)
        for i = 1:KTX.anzk
            A(1, i) = table2array(mean(ACC_Supervise.Relative(:, i)));   
        end
        MU_ACC_Supervise.Relative = mean(A); clear A   
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot Comparison of Mean Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define labels for adaptation methods
    X1 = ["NK-Orginal", "NK-One", "MU", "Constant", "Relative"];
    
    % Collect mean accuracy values for supervised and unsupervised learning
    Y3 = [MU_ACC_Supervise.NK_Orginal, MU_ACC_Supervise.NK_One, ...
          MU_ACC_Supervise.MU, MU_ACC_Supervise.Constant, ...
          MU_ACC_Supervise.Relative];

    Y4 = [MU_ACC_Unsupervise.NK_Orginal, MU_ACC_Unsupervise.NK_One, ...
          MU_ACC_Unsupervise.MU, MU_ACC_Unsupervise.Constant, ...
          MU_ACC_Unsupervise.Relative];

    % Convert to percentages and round values for better visualization
    Y5 = [Y3; Y4] * 100;
    Y5 = round(Y5);

    % Create bar chart
    figure()
    bb = bar(X1, Y5);
    
    % Add labels to the bars for Supervised accuracy
    xtips1 = bb(1).XEndPoints;
    ytips1 = bb(1).YEndPoints;
    labels1 = string(bb(1).YData);
    text(xtips1, ytips1, labels1, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')

    % Add labels to the bars for Unsupervised accuracy
    xtips2 = bb(2).XEndPoints;
    ytips2 = bb(2).YEndPoints;
    labels2 = string(bb(2).YData);
    text(xtips2, ytips2, labels2, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')

    % Formatting
    grid on
    legend('Supervised', 'UnSupervised')
    title('Comparison of Mean Membership Function Values for Supervised and Unsupervised Learning')
end
%%
% Save Adaptation Parameters if enabled
if Save_Adaption == 1
    % Extract relevant names from KTX and Test file titles
    S = split(KTX.titel);   % Split title string into parts
    S1 = split(Test.titel); % Split test title string into parts
    name = S{4, 1};         % Extract specific name from KTX title
    name_2 = S1{2, 1};      % Extract specific name from Test title

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Unsupervised Learning Adaptation Save %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if UnSupervised == 1
        % Save NK_Original adaptation parameters
        if r.NK_orginal == 1
            Par = Adaption_Parameter_UnSupervised.AParameter_NK_Orginal_Unsupervised;
            fc_Save_UnSupervised_NK_Orginal(KTX, Par, name, name_2);
        end

        % Save NK_One adaptation parameters
        if r.NK_one == 1
            Par = Adaption_Parameter_UnSupervised.AParameter_NK_One_Unsupervised;
            fc_Save_UnSupervised_NK_One(KTX, Par, name, name_2);
        end

        % Save MU adaptation parameters
        if r.MU == 1
            Par = Adaption_Parameter_UnSupervised.AParameter_MU_Unsupervised;
            fc_Save_UnSupervised_MU(KTX, Par, name, name_2);
        end

        % Save Relative adaptation parameters
        if r.relative == 1
            Par = Adaption_Parameter_UnSupervised.AParameter_relative_Unsupervised;
            fc_Save_UnSupervised_relative(KTX, Par, name, name_2);
        end

        % Save Constant adaptation parameters
        if r.constant == 1
            Par = Adaption_Parameter_UnSupervised.AParameter_Constant_Unsupervised;
            fc_Save_UnSupervised_constant(KTX, Par, name, name_2);
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Supervised Learning Adaptation Save %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if Supervised == 1
        % Save NK_Original adaptation parameters
        if r.NK_orginal == 1
            Par = Adaption_Parameter_Supervised.AParameter_NK_Orginal_Supervised;
            fc_Save_Supervised_NK_Orginal(KTX, Par, name, name_2);
        end

        % Save NK_One adaptation parameters
        if r.NK_one == 1
            Par = Adaption_Parameter_Supervised.AParameter_NK_One_Supervised;
            fc_Save_Supervised_NK_One(KTX, Par, name, name_2);
        end

        % Save MU adaptation parameters
        if r.MU == 1
            Par = Adaption_Parameter_Supervised.AParameter_MU_Supervised;
            fc_Save_Supervised_MU(KTX, Par, name, name_2);
        end

        % Save Relative adaptation parameters
        if r.relative == 1
            Par = Adaption_Parameter_Supervised.AParameter_relative_Supervised;
            fc_Save_Supervised_relative(KTX, Par, name, name_2);
        end

        % Save Constant adaptation parameters
        if r.constant == 1
            Par = Adaption_Parameter_Supervised.AParameter_Constant_Supervised;
            fc_Save_Supervised_constant(KTX, Par, name, name_2);
        end
    end
end
