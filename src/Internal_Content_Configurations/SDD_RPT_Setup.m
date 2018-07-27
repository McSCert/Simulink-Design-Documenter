% SDD_RPT_SETUP Ensures that many variables used by SDD_Report.rpt are
% initialized to at least some default.
% While some of this might normally be done where it is relevant within
% SDD_Report.rpt, I've put it here because I can debug .m files more easily
% than .rpt files.

%Note: initVar(var,val) is used throughout this section of the script 
%   initVar initializes a variable indicated by the char, var, to val ONLY 
%   if it does not already exist in the workspace.

disp('Initializing uninitialized variables')

%This should have been set on the call to GenSDD()
assert(logical(exist('topsys','var')),'topsys variable does not exist')

%This should have been set in GenSDD()
assert(logical(exist('model','var')),'topsys variable does not exist')

%To set the significant subsystems (as they are referred to in the user guide),
%the variable "subsystemList" should be set to a cell array in which each 
%cell is a subsystem in the model that is to be included in the SDD report.
%Note: the path to the subsystems should be given, not just the name.
%Note: top-level need not be included as it is handled by default.
% E.g. subsystemList = find_system(model,'SearchDepth',<depth>,'BlockType','SubSystem','MaskType',''); % Will not include masked subsystems 
if ~(exist('subsystemList','var'))
    subsystemList = setdiff(...
        [model;find_system(gcs,'SearchDepth','3','FollowLinks','on','BlockType','SubSystem')],... % This does include masked subsystems
        find_system(gcs,'SearchDepth','3','FollowLinks','on','BlockType','SubSystem','MaskType','DocBlock')... % This removes the DocBlocks
        );
end
%The above returns all subsystems within topsys at a relative depth of 3 or less
%   e.g. in sub1/sub2/sub3/sub4, sub3 is 2 away from sub1
%In all likelihood this should be set manually using a format like the following:
%subsystemList = {<subsystem1>,<subsystem2>,...,<subsystemN>};

initVar('title', get_param(topsys,'Name'));

initVar('subtitle', 'Software Design Description');

initVar('authors', '');

initVar('titleImage', '');

initVar('abstract', 'N/A');

initVar('legalNotice', '');

initVar('cal_script', '');

%Variable: pathToIntroSections
%By default the tool will try to find the appropriate path automatically so it need not be defined
%If used, pathToIntroSections shall indicate a path to a directory which contains: 
%   SDD_Document_Purpose.txt, SDD_Scope.txt, SDD_Definitions.txt, and SDD_Acronyms.txt (at least)
%Additionally this should all be on the MATLAB path

%Create or choose a "getUnit" function.
%   It should take a block name as input and return its units using some convention.
%   The getUnit function is used to determine what physical units are 
%       associated with the output of a given block.
%   The outputs of getUnit will be shown in tables about blocks throughout the SDD.
initVar('getUnit', @(blockName){'N/A'});
%   returns 'N/A' (just avoids errors since it will be assumed that the getUnit function exists)

%Find the signature of systems in the model using the Signature Tool.
%   See the Signature Tool documentation for more information about how to use it.
%   The variable should be using the following scheme for this report generation:
%       [~ signatures] = <Weak/Strong>Signature(bdroot(topsys),1,<updates>,topsys,<txt>);
%       -Use StrongSignature to return the interface based on how the model
%       is used, or use WeakSignature to return the interface based on how
%       the model could be used.
%       -Use updates = 1 if you would like to include an updates table in 
%       the interface, or use updates = 0 if it is not desired
assert(~isempty(which('StrongSignature')),sprintf(['Could not find StrongSignature, ' ...
    'ensure that you have the Signature Tool and that it is on the MATLAB file path.' ...
    '\nGet the tool at:' ...
    '\n\thttps://www.mathworks.com/matlabcentral/fileexchange/49897-signature-tool']));
disp(sprintf('\tStarting Signature Tool'))
[~, sigs] = StrongSignature(bdroot(topsys),1,1,topsys,0);
disp(sprintf('\tFinished Signature Tool'))
initVar('signatures', sigs);

%Choose which columns to show in the tables 
%For these variables 0s indicate columns which will be included in the SDD while 1s indicate columns which will not be included
%The columns in order:
%    Blocks/Name, Units, Min, Max, Type, Descriptions
%e.g. [0 1 1 1 0 0] will give tables with just the Blocks/Name, Type, and Descriptions columns
initVar('removeInterfaceCols', [0 0 0 0 0 0]); %removeInterfaceCols corresponds to tables shown in the Interface section for each subsystem in the SDD
initVar('removeSubCols', [0 1 1 1 1 0]); %removeSubCols corresponds to tables which identify subsystems contained within each subsystem in the SDD

%Set a requirements document for the report to link to
%'' indicates that there is no requirements document, thus it will not be linked to
%If there is a requirements document, the full path should be given
%e.g. initVar('srsPath','''C:/.../mySRS.doc''') or initVar('srsPath',which('mySRS.doc'))
initVar('srsPath','');

initVar('includeReqTrace', false); % This determines whether or not to include the requirements traceability section in the report (defaults to false because it doesn't always look good and only currently links properly when generating HTML in newer versions of MATLAB)

%Leave these unless you have a particular reason to change them
initVar('allowMissingDocBlocks', false); % If true, the report generation is supposed to ignore missing docblocks however this is untested
initVar('displayWarningSummary', true); % If false, the Summary of Warnings section will be omitted from the report
initVar('allowBadSubsystemNames', false); % If true, the report generation is supposed to ignore subsystem names that don't exist however this is untested
initVar('allowDuplicateSections', false); % When true, warnings for having sections of the same name are suppressed
initVar('requireInterface', true); % When true, warnings will appear if mapDataTypes.m is not on the MATLAB path (this function is needed to fill out interface tables in the document)
initVar('includeExtraSections', true); % Includes all DocBlocks in the Overall System Design SubSystem (if false, only defaults get included)
initVar('includeTableDefaults', true); % When true, if a table would be empty and thus not be included in the report, a default message will be included in the document to indicate there is nothing to display

%Leave these(this) unless you have a particular reason to change them(it)
initVar('includeSubsTable', true);

%% 
%These variables will be used to identify links with short names - because of a cap on link name length in RTF
initVar('linkMap', containers.Map());
initVar('linkCounter', 0);

disp('Done initializing variables')

%%
%Add model to subsystemList if it's not already there

%First transpose subsystemList if it was given as a row vector
if size(subsystemList,2) ~= 1 %Catch other issues with the dimensions later
    subsystemList = subsystemList';
end

modelIsIncluded = false;
for i = 1:length(subsystemList)
    if strcmp(subsystemList{i}, topsys)
        modelIsIncluded = true;
    end
end
if ~modelIsIncluded
    subsystemList = [topsys; subsystemList];
end

%% 
%Get the types for all blocks in the model

%Variable: dataTypeMap

if exist('mapDataTypes.m','file') == 2
    dataTypeMap = mapDataTypes(bdroot(model));
else
    error('Error. \nmapDataTypes.m needs to be on the MATLAB file path (this file comes with the Signature Tool).');
end

%% 
%Finds any/all subsystems in subsystemList which are not found within the model
%Additionally, if a subsystem was given without the full path this will find
%   the subsystem's full path - if there is more than 1 subsystem with the
%   name then one is chosen randomly and no notification is given

%Variable: badSubList

badSubList = {};
%allSubs = [model;find_system(model,'BlockType','SubSystem','MaskType','')]; %(old code)
allSubs = [model;find_system(gcs,'FollowLinks','on','BlockType','SubSystem')];
for i = 1:length(subsystemList)
    if isempty(find(strcmp(subsystemList{i},allSubs),1))
        %subPath = find_system(model,'BlockType','SubSystem','MaskType','','Name',subsystemList{i}); %(old code)
        subPath = find_system(model,'FollowLinks','on','BlockType','SubSystem','Name',subsystemList{i});
        if isempty(subPath)
            badSubList{end+1} = subsystemList{i};
        else
            subsystemList{i} = subPath{1};
        end
    end
end
clear allSubs subPath

%% 

%Variable: alreadyWarned
%Variable: summaryOfWarnings

alreadyWarned = false; %Tracks whether or not the user has any warnings.
    %When the first warning is caught, the user will be prompted about whether or not 
    %    they wish to continue.
    %This variable is used to prevent that prompt from popping up repeatedly
    %    (i.e. the user is only told of a first warning during generation).

summaryOfWarnings = {}; %Stores all warning messages

%%
%Get the desired subsystem hierarchy and set other variables that get used for recursion

%Variable: systemTree
%Variable: backupSystemTree
%Variable: treePath
%Variable: haveExceededMaxDepth     %This variable is not currently in use
    %and my be deleted in the future
%Variable: sectionNameList

systemTree = getBestSystemTree(subsystemList);
backupSystemTree = systemTree;

treePath = {};

haveExceededMaxDepth = false;

sectionNameList = {};