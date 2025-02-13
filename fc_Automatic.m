function Parameter = fc_Automatic(KTX, OTX, r)
% This function automatically determines and adapts classification parameters
% for unsupervised learning using various adaptation methods.

global vParameter_r_Unsupervise 

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
AParameter_NK_Orginal_Unsupervised = KTX.class;
AParameter_NK_One_Unsupervised =  KTX.class;
AParameter_MU_Unsupervised =  KTX.class;
AParameter_Constant_Unsupervised =  KTX.class;
AParameter_relative_Unsupervised =  KTX.class;

% Iterate over each input sample in OTX
for i = 1:size(OTX.input,1)    
    Xinput = OTX.input(i, 3:end); % Extract feature input (excluding first 2 columns)
    
    % Find closest match using fuzzy membership function
    [MU_idx, idx] = fc_automatic_MU(Xinput, KTX);

    % Update parameters based on selected adaptation method
    if r.NK_orginal == 1
        [AParameter_NK_Orginal_Unsupervised(idx).class, NK_Orginal] = ...
            fc_Automatic_Parameter_r_Nk_Orginal(Xinput, AParameter_NK_Orginal_Unsupervised(idx).class, NK_Orginal, idx);
    end

    if r.NK_one == 1
        [AParameter_NK_One_Unsupervised(idx).class, NK_One] = ...
            fc_Automatic_Parameter_r_Nk_One(Xinput, AParameter_NK_One_Unsupervised(idx).class, NK_One, idx);
    end

    if r.MU == 1
        [AParameter_MU_Unsupervised(idx).class] = ...
            fc_Automatic_Parameter_r_MU(Xinput, AParameter_MU_Unsupervised(idx).class, MU_idx, idx);
    end

    if r.constant == 1
        [AParameter_Constant_Unsupervised(idx).class] = ...
            fc_Automatic_Parameter_r_constant(Xinput, AParameter_Constant_Unsupervised(idx).class, r, idx);
    end

    if r.relative == 1
        [AParameter_relative_Unsupervised(idx).class] = ...
            fc_Automatic_Parameter_r_relative(Xinput, AParameter_relative_Unsupervised(idx).class, idx);
    end
end

% Store computed parameters in the output structure
Parameter.AParameter_NK_Orginal_Unsupervised = AParameter_NK_Orginal_Unsupervised;
Parameter.AParameter_NK_One_Unsupervised = AParameter_NK_One_Unsupervised;
Parameter.AParameter_MU_Unsupervised = AParameter_MU_Unsupervised;
Parameter.AParameter_Constant_Unsupervised = AParameter_Constant_Unsupervised;
Parameter.AParameter_relative_Unsupervised = AParameter_relative_Unsupervised;

end
