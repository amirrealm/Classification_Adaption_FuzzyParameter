function out = readotx(Data_otx)
% This function reads an OTX file and extracts the features and input data.
% It parses the file line by line to get the feature names and values for each test sample.
% The result is returned as a structured output.
% Input:
%   Data_otx - The path to the OTX file to be read
% Output:
%   out - A structure containing the extracted data, including feature names and input values

% Define the initial names for the parameters (columns)
par_name = {'Nr', 'Lable'}; 

% Open the OTX file for reading as text
file = fopen(Data_otx, 'rt'); 

% Read the title line of the OTX file
otx.titel = fgetl(file); 

% Read the number of features from the next line
streak = fgetl(file); 
otx.anzm = sscanf(streak, '%d'); 

% Loop through each feature to extract its name
for i = 1:otx.anzm
    streak = fgetl(file); 
    otx.Merk.name(1, i) = string(char(sscanf(streak, '%s')')); % Store the feature name
    
    % Generate a new parameter name for the feature and add it to the parameter list
    (['m' num2str(i)]); 
    par_name = [par_name, ans]; 
end

% Skip the next empty line or non-relevant line
streak = fgetl(file);

% Initialize the row index for the input data
k = 1;

% Loop to read the input data until an empty line or end of file is encountered
while true
    streak = fgetl(file); 
    
    % Check for end of file, empty line, or non-data line
    if isempty(streak)==1 |  streak==-1 | isempty(find(~isspace(streak)))==1 
        break
    end    
    
    % Parse the current line for feature values and store it in the input table
    otx.input(k, :) = sscanf(streak, '%d%f %f %f %f %f %f')'; 
    k = k + 1; % Increment the row counter
end

% Convert the input data into a table with the specified column names
otx.input = array2table(otx.input, 'VariableNames', par_name); 

% Return the output structure containing the extracted data
out = otx;

end
