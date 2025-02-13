function z = fc_Save_Supervised_relative(KTX, Parameter, name, name_3)
% This function saves the supervised adaptation parameters for the "Relative" method.
% It creates a `.ktx` file with formatted parameter values for further analysis.

%% Construct File Name and Title
name1 = 'Adaption_Supervised_Relative_';
name2 = '.ktx';
name1_2 = ' mit '; % German for "with"
Name_String = append(name1, name, name1_2, name_3, name2); % Full file name
Name_title = append(name1, name, name1_2, name_3, name2); % File title

%% Open File for Writing
fileID = fopen(Name_String, 'wt'); % Open the file for text writing
if fileID == -1
    error('Error opening file: %s', Name_String); % Error handling for file opening
end

%% Write Header Information
fprintf(fileID, '%s\n', Name_title); % File title
fprintf(fileID, string(KTX.anzk)); % Number of classes
fprintf(fileID, '     Klassen \n'); % Label for number of classes
fprintf(fileID, string(KTX.anzm)); % Number of features
fprintf(fileID, '     Merkmale \n'); % Label for number of features

%% Write Column Headers
fprintf(fileID, 'Mnr');      % Feature number
fprintf(fileID, '%7s', 'REP');
fprintf(fileID, '%10s', 'WINKEL'); % Angle
fprintf(fileID, '%7s', 'BL');      % Boundary Left
fprintf(fileID, '%9s', 'BR');      % Boundary Right
fprintf(fileID, '%9s', 'CL');      % Characteristic Left
fprintf(fileID, '%9s', 'CR');      % Characteristic Right
fprintf(fileID, '%11s', 'DL');     % Degree Left
fprintf(fileID, '       DR \n');   % Degree Right

%% Write Parameter Data for Each Class
for i = 1:KTX.anzk
    fprintf(fileID, '%d', i); % Class number
    fprintf(fileID, '     Klassen_%d\n', i); % Label class section

    % Write feature-wise parameter values
    for p = 1:KTX.anzm
        s = table2array(Parameter(i).class(p, :)); % Extract parameters for feature 'p'
        s = [p, s]; % Prepend feature number
        s = num2str(s, 4); % Convert to string with 4 significant digits
        fprintf(fileID, '%s\n', s); % Write to file
    end
end

%% Close File
fclose(fileID);

%% Display Confirmation Message
disp(['File saved successfully: ', Name_String]);

end
