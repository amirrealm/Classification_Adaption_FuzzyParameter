function vParameter_r = fc_Verlauf(class)
% This function initializes and returns a structure array with specific fields.
% The structure is created for the specified number of classes.
% Input:
%   class - The number of classes (integer)
% Output:
%   vParameter_r - A structure array with fields for each class, initialized with empty values

% Initialize the fields of the structure
vParameter_r.NK_Orginal = []; % Original NK values (empty initially)
vParameter_r.NK_One = [];     % One-dimensional NK values (empty initially)
vParameter_r.MU = [];         % Membership values (empty initially)
vParameter_r.Constant = [];   % Constant values (empty initially)
vParameter_r.Relative = [];   % Relative values (empty initially)

% Replicate the structure for the specified number of classes
vParameter_r = repmat(vParameter_r, class, 1); % Create a structure array with 'class' entries

end
