function GenSDD(topsys)
    % GENSDD Generates an SDD document from the SDD_Report setup file and its
    %   components.
    %
    %   Inputs:
    %       topsys  The system which will be documented. Referred to as the
    %               Top-System in the user guide.
    %               The model containing topsys should be open before this is called
    %
    %   Example:
    %       GenSDD(gcs)
    
    %
    saved_workspace = SaveAndClearBaseVars('pre-sdd-gen'); % Saves base workspace variables in mat file
    
    %
    assignin('base', 'topsys', topsys);
    assignin('base', 'model', bdroot(topsys));
    
    % Execute user defined Matlab code to setup variables more appropriately
    % I.e. run the config
    try
        evalin('base', ['run(''', get_param(topsys,'Name'), '_SDD_Config.m', ''')']);
        fprintf(['\tRan config file at:', '\n']);
        disp(which([get_param(topsys,'Name'), '_SDD_Config.m']));
        
        assignin('base', 'errorIn_model_SDD_Config', false);
    catch ME
        getReport(ME)
        
        assignin('base', 'errorIn_model_SDD_Config', true);
    end
    
    %Ensure variables are set to defaults
    try
        evalin('base', ['run(', '''SDD_RPT_Setup''', ')']);
    catch ME
        getReport(ME)
    end
    
    % List of required variables for the report generation
    requiredVariables = {'model','topsys','subsystemList', ...
        'title','subtitle', ...
        'authors','titleImage','abstract','legalNotice', ...
        'getUnit', 'signatures', ...
        'removeInterfaceCols', 'removeSubCols', 'srsPath', ...
        'allowDuplicateSections', ...
        'requireInterface','includeExtraSections', ...
        'includeTableDefaults','includeReqTrace', ...
        'cal_script', ...
        'dataTypeMap', ...
        'badSubList','allowMissingDocBlocks','displayWarningSummary', ...
        'allowBadSubsystemNames', ...
        'alreadyWarned','summaryOfWarnings','errorIn_model_SDD_Config'};
    
    %Generate the SDD
    try
        report('SDD_Report', '-quiet');
    catch ME
        getReport(ME)
    end
    
    % Return values in base workspace to the way they were with values from tempVarsFromBase
    LoadAndDeleteMat(saved_workspace)
end