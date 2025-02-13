function Parameter = fc_Lable(KTX, OTX, r)
% This function performs supervised parameter adaptation using labeled training data.
% It updates different adaptation methods based on known class labels.

global vParameter_r_Supervise % Access global variable for tracking parameter changes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if the user has selected a method for Nk.
% If no method is selected, the program defaults to `NK_orginal` from KTX.
if r.NK_orginal == 0 && r.NK_one == 0   
   r.NK_orginal = ~r.NK_orginal; % Enable NK_Orginal mode by default
end

% Assign Nk values based on user selection
if r.NK_orginal == 1
    NK_Orginal = KTX.Nk; % Use Nk values from KTX
end

if r.NK_one == 1
    NK_One = KTX.Nk; % Initialize Nk array
    NK_One(1:end) = 1; % Set all Nk values to 1
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize adaptation parameters for different methods
AParameter_NK_Orginal_Supervised = KTX.class;
AParameter_NK_One_Supervised = KTX.class;
AParameter_MU_Supervised = KTX.class;
AParameter_Constant_Supervised = KTX.class;
AParameter_relative_Supervised = KTX.class;

% Iterate over each input sample in OTX
for i = 1:size(OTX.input, 1)    
    Xinput = OTX.input(i, 3:end); % Extract feature input (excluding first 2 columns)
    
    % Extract the known label for supervised adaptation
    idx = table2array(OTX.input(i, 'Lable')); 
    
    % Compute membership index for MU-based adaptation
    MU_idx = fc_Lable_MU(Xinput, KTX, idx);

    % Update parameters based on selected adaptation method
    if r.NK_orginal == 1
        [AParameter_NK_Orginal_Supervised(idx).class, NK_Orginal] = ...
            fc_Lable_Parameter_r_Nk_Orginal(Xinput, AParameter_NK_Orginal_Supervised(idx).class, NK_Orginal, idx);
    end

    if r.NK_one == 1
        [AParameter_NK_One_Supervised(idx).class, NK_One] = ...
            fc_Lable_Parameter_r_Nk_One(Xinput, AParameter_NK_One_Supervised(idx).class, NK_One, idx);
    end

    if r.MU == 1
        [AParameter_MU_Supervised(idx).class] = ...
            fc_Lable_Parameter_r_MU(Xinput, AParameter_MU_Supervised(idx).class, MU_idx, idx);
    end

    if r.constant == 1
        [AParameter_Constant_Supervised(idx).class] = ...
            fc_Lable_Parameter_r_constant(Xinput, AParameter_Constant_Supervised(idx).class, r, idx);
    end

    if r.relative == 1
        [AParameter_relative_Supervised(idx).class] = ...
            fc_Lable_Parameter_r_relative(Xinput, AParameter_relative_Supervised(idx).class, idx);
    end
end

% Store computed parameters in the output structure
Parameter.AParameter_NK_Orginal_Supervised = AParameter_NK_Orginal_Supervised;
Parameter.AParameter_NK_One_Supervised = AParameter_NK_One_Supervised;
Parameter.AParameter_MU_Supervised = AParameter_MU_Supervised;
Parameter.AParameter_Constant_Supervised = AParameter_Constant_Supervised;
Parameter.AParameter_relative_Supervised = AParameter_relative_Supervised;

end
