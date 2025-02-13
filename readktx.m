function out = readktx(Data_ktx)
% This function reads a KTX file and extracts the parameters for each class and feature.
% The file is parsed line by line to extract class-specific parameters, such as 
% membership functions and other values. The result is returned as a structured output.
% Input:
%   Data_ktx - The path to the KTX file to be read
% Output:
%   out - A structure containing the extracted data, including class parameters

% Define the names of the parameters expected in the KTX file
par_name = {'r', 'a', 'bl', 'br', 'cl', 'cr', 'dl', 'dr'}; 

% Open the KTX file for reading as text
file = fopen(Data_ktx, 'rt'); 

% Read the title line of the KTX file
ktx.titel = fgetl(file); 

% Read the number of classes from the next line
streak = fgetl(file);
ktx.anzk = sscanf(streak, '%d'); 

% Read the number of features from the next line
streak = fgetl(file);
ktx.anzm = sscanf(streak, '%d'); 

% Skip an empty line (or another non-relevant line)
streak = fgetl(file);

% Initialize the structure to hold class data
A.class = [];
A = repmat(A, ktx.anzk, 1); 

% Loop through each class to extract its data
for k = 1:ktx.anzk
    % Read a line for the current class
    streak = fgetl(file);
    
    % Split the line based on spaces
    splitline = strsplit(streak); 
    
    % Extract the Nk value for the current class
    mystr = split(streak, "Nk="); 
    Nk(k, 1) = mystr(end, 1); 
    
    % Loop through each feature of the current class
    for m = 1:ktx.anzm
        % Read a line for the feature parameters
        streak = fgetl(file);
        
        % Parse the values from the line (skipping the first integer)
        sscanf(streak, '%d %f %f %f %f %f %f %f %f'); 
        
        % Store the parsed values in the class structure
        ans = ans(2:end)'; 
        A(k).class(m, :) = ans; 
    end
    
    % Convert the class parameters into a table with the specified column names
    A(k).class = array2table(A(k).class, 'VariableNames', par_name); 
end

% Convert the Nk values from cell format to a numeric format
ktx.Nk = str2double(Nk); 

% Store the class data in the output structure
ktx.class = A;

% Return the output structure containing all the extracted data
out = ktx;

end
