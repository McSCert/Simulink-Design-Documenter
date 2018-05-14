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
% GenSDD will do some work in the base workspace so it is best to ensure no 
% variables are in the workspace before running this. That said, the 
% workspace variables *should* be preserved.

%Need to save base workspace variables that are about to be overwritten
requiredVariables = {'model','topsys','subsystemList', ...
    'title','subtitle', ...
    'authors','titleImage','abstract','legalNotice', ...
    'getUnit', 'signatures', ...
    'removeInterfaceCols', 'removeSubCols', 'srsPath', ...
    'allowDuplicateSections', ...
    'requireInterface','includeExtraSections', ...
    'includeTableDefaults','includeReqTrace', ...
    'dataTypeMap', ...
    'badSubList','allowMissingDocBlocks','displayWarningSummary', ...
    'allowBadSubsystemNames', ...
    'alreadyWarned','summaryOfWarnings','errorIn_model_SDD_Config'};

baseVarsToSave = {requiredVariables{:},...
    'pathToIntroSections', ...
    'LinkID', 'fullFilePath', 's', ...
    'LinkText', 'haveExceededMaxDepth', 'sectNum', ...
    'address', 'i', 'sectionName', ...
    'iRPTGEN', 'sectionNameList', ...
    'appCount', 'imagePath', 'sigParams', ...
    'appID', 'imageTitle', 'sigs', ...
    'appendixTableTitles', 'includeSubsTable', 'stringToParse', ...
    'appendixTables', 'introSections', 'systemTree', ...
    'backupSystemTree', 'introSectionsInNnP', 'table', ...
    'blockType', 'j', 'tableSections', ...
    'chNum', 'k', 'tableTitle', ...
    'chStyle', 'kRPTGEN', 'treePath', ...
    'chapter', 'linkCounter', 'userData', ...
    'defaultLibraryText', 'linkMap', 'userDataWasModified', ...
    'displayWarningMessage', 'mdlNnP', 'variable', ...
    'failGenerationWithException', 'modelIsIncluded', 'warnOfDuplicates', ...
    'failGenerationWithoutException', 'paragraphTitle', 'warningMessageLevel', ...
    'file', 'parsedString', ...
    'fileType', 'removeCalCols', ...
    'filename', 'requiredFiles', ...
    'requiredVariables', ...
    };
                                
tempVarsFromBase = SaveBaseVars(baseVarsToSave); %Saves values from base workspace in tempVarsFromBase

disp(['topsys = ''' topsys ''''])
% assignin('base','topsys',topsys);
% assignin('base','model',bdroot(topsys)); 

model = bdroot(topsys); %Note: bdroot returns the name of the current top-level system.

%Execute user defined Matlab code to setup variables more appropriately
try
    disp(sprintf('\tSearching for config file named:'))
    disp(sprintf(['\t\t', get_param(topsys,'Name'), '_SDD_Config.m']))
    run([get_param(topsys,'Name'), '_SDD_Config.m']);

    errorIn_model_SDD_Config = false;
catch ME
    getReport(ME)

    errorIn_model_SDD_Config = true;
end

%Ensure variables are set to defaults
try
    run('SDD_RPT_Setup');
catch ME
    getReport(ME)
end

OverwriteBaseVars(baseVarsToSave); %Replaces values in base workspace with values from this workspace

%Generate the SDD
report('SDD_Report', '-quiet');

LoadBaseVars(baseVarsToSave,tempVarsFromBase); %Returns values in base workspace to the way they were with values from tempVarsFromBase
end

function tempVarsFromBase = SaveBaseVars(varsToSave)
%Save variables on the base workspace
tempVarsFromBase = cell(1,length(varsToSave));
for i = 1:length(varsToSave)
    %Save variable if it exists
    try
        tempVarsFromBase{i} = evalin('base', varsToSave{i});
    end
end
end

function OverwriteBaseVars(varsToSave)
%Overwrite variables on the base workspace with values from the caller
for i = 1:length(varsToSave)
    %Overwrite variable from caller
    if evalin('caller',['exist(''', varsToSave{i}, ''',''var'')'])
        assignin('base', varsToSave{i}, evalin('caller',varsToSave{i}));
    else
        evalin('base',['clear ''', varsToSave{i}, '''']);
    end
end
end

function LoadBaseVars(varsToLoad,tempVarsFromBase)
%Return base workspace to its original state
for i = 1:length(varsToLoad)
    %Load Variables
    try
        if ~isempty(tempVarsFromBase{i})
            assignin('base', varsToLoad{i}, tempVarsFromBase{i});
        else
            evalin('base', ['clear ' varsToLoad{i}])
        end
    end
end
end