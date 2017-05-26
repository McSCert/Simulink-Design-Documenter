% This script explains and sets configuration options for documents 
%   generated with GenSDD.
%
% The original version of this file has been named TopsysName_SDD_Config.m,
%   TopsysName will need to be replaced with the name of the system for
%   which documentation is being generated. This is also discussed in 5.2.1
%   of the Guide and Reference Manual for this documentation tool.
%
% Each block of comments will describe a different variable which may be
%   set by the user (examples will be written below most of these blocks of 
%   comments) with exception to model and topsys (these variables are
%   described for reference).
% Any variable described below that is not set in this file will be set to
%   its default in SDD_RPT_Setup.m. Please at least consider setting the 
%   subsystemList and authors variables manually.

%   topsys - refers to the system which will be documented 
%          - this should be set by the input to the GenSDD function
%          - you probably shouldn't modify this variable, but you may use
%          it when setting others if it's useful

%   model - refers to the model topsys is in
%         - defaults to top-level system of the model topsys is in (model = bdroot(topsys);)
%         - you probably shouldn't modify this variable, but you may use
%         it when setting others if it's useful

%   subsystemList - indicates which systems within topsys which will be documented (topsys will always be included automatically if not already included) 
%                 - note the gcs command returns the fullpath of the current
%                 subsystem and may help if setting this variable manually
%                 - also note clicking in the address bar in Simulink will
%                 select the current subsystem path name (so it can be
%                 copied)
%                 - e.g. subsystemList = {<subsystem1>,<subsystem2>,...,<subsystemN>};
%                 - e.g. subsystemList = find_system(topsys,'SearchDepth','3','FollowLinks','on','BlockType','SubSystem','MaskType',''); %This will exclude masked subsystems
%                 - The default includes subsystems within the first 3 levels of topsys (and excludes DocBlocks)

%   authors - author(s) of the document
authors = ''; % Default is empty

%   title - document title
title = topsys; % Default is the name of the system being documented

%   subtitle - document subtitle
subtitle = 'Software Design Description'; % Default is the document type generated by this tool

%   titleImage - path to image to be displayed on the title page
titleImage = ''; % Default is empty

%   pathToIntroSections - a path to a directory with the introductory sections (these are: Document Purpose, Scope, Definitions, and Acronyms) to be included in the document
%                       - default leaves this undeclared and will find the files with: 
%							which(['\SDD_', <section name>, '.doc']) or 
%							which(['\SDD_', <section name>, '.txt']) if the first is not found 
%							- the filenames should match this convention

%   includeReqTrace - determines whether or not to include the requirements traceability section in the report
%                   - defaults to false
includeReqTrace = false;

%   srsPath - indicates path to the requirements document associated with the model
%           - the document will be linked in the generated report
%           - e.g. srsPath = which('reqdoc.doc') - note that if reqdoc.doc is not found '' will be returned
srsPath = ''; % Default of '' indicates no requirements document

%   allowMissingDocBlocks - determines whether warnings will or will not be displayed in the report for 'required' DocBlocks being missing
allowMissingDocBlocks = false; % Defaults to include warnings

%   displayWarningSummary - determines whether the Summary of Warnings section will be displayed in the report
displayWarningSummary = true; % Defaults to include the Summary of Warnings

%   getUnit - function to find a unit associated with a given block 
%           - defaults to return '' for all blocks
%           - e.g. getUnit = @myGetUnitFunction
%           %the example function below is just a quick example, the real thing should probably do more
%           function unit = myGetUnitFunction(block)
%               if strcmp(get_param(block,'Name'), 'Velocity')
%                   unit = 'm/s';
%               else
%                   unit = '';
%               end
%           end
%           %below is another possible function
%           function unit = myGetUnitFunction(block)
%               unit = get_param(block,'Unit'); 
%               %Added in MATLAB R2016a, the unit block parameter would need
%               %to be set for everything in the interface sections of the report for this to work
%           end

%   removeInterfaceCols - indicates which columns to not include in tables of the system interface sections of the report
%                       - For these variables 0s indicate columns which will be included in the SDD while 1s indicate columns which will not be included
%                       - The columns in order:
%                           Blocks/Name, Units, Min, Max, Type, Descriptions
%                       - e.g. [0 1 1 1 0 0] will give tables with just the Blocks/Name, Type, and Descriptions columns
removeInterfaceCols = [0 0 0 0 0 0]; % Defaults to include all sections

%   removeSubCols - indicates which columns to not include in tables of the subsystem specification sections of the report (these sections list subsystems within the current system)
%                 - The columns in order:
%                       Blocks/Name, Units, Min, Max, Type, Descriptions
%                 - e.g. [0 1 1 1 0 0] will give tables with just the Blocks/Name, Type, and Descriptions columns
removeSubCols = [0 1 1 1 1 0]; % Defaults to just include the Blocks/Name column and the Description column because the remaining columns aren't likely to have meaningful values

%   abstract - abstract for the document
abstract = 'N/A'; % Default is N/A

%   legalNotice - a legal notice for the document 
legalNotice = ''; % Default is empty

%   signatures - is a representation of the signature of the model based on output from the Signature Tool.
%              - The variable should be set using the following scheme for this report generation:
%                  [~ signatures] = <Weak/Strong>Signature(bdroot(topsys),1,<updates>,topsys,<txt>);
%                       - Use StrongSignature to return the interface based on how the model
%                       is used, or use WeakSignature to return the interface based on how
%                       the model could be used.
%                       - Use updates = 1 if you would like to include an updates table in 
%                       the interface, or use updates = 0 if it is not desired
%              - see the Signature Tool documentation for more information about how to use it
%[~, signatures] = StrongSignature(bdroot(topsys),1,1,topsys,3); % Defaults to StrongSignature of the topsys, with updates on and generating no document and not modifying the model	%%%This is commented out because the signature may take a decent bit of time to run thus calling it here may slow down the tool

%%%%%%%%%%%%%%% Remaining configurations are considered less useful and are relatively untested %%%%%%%%%%%%%%%
%   allowBadSubsystemNames - determines whether warnings will or will not be displayed in the report for subsystemList names that do not exist
%                          - untested if set to true
%                          - defaults to false
%   allowDuplicateSections - when true, warnings for having sections of the same name are suppressed
%                          - defaults to false
%   requireInterface - when true, warnings will appear if mapDataTypes.m is not on the MATLAB path (this function is needed to fill out interface tables in the document)
%                    - defaults to true
%   includeExtraSections - currently does nothing
%                        - will remove this (or give it fucntionality) in the future
%                        - defaults to true
%   includeTableDefaults - when true, if a table would be empty and thus not be included in the report, a default message will be included in the document to indicate there is nothing to display
%                        - defaults to true
%   includePortTables - determines whether or not to include the Inport and Outport tables
%                     - defaults to true
%   includeDSTables - determines whether or not to include the Data Store tables
%                   - defaults to true
%   includeGotoTables - determines whether or not to include the Goto and From tables
%                     - defaults to true
%   includeTagVis - determines whether or not to include the table for GotoTagVisibility
%                 - if includeGotoTables is false then the table is not included either way
%                 - defaults to true
%   includeSubsTable - determines whether or not to include the SubSystems table
%                    - defaults to true