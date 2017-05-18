%SETUP_WARNINGS performs some checks for errors resulting from the initial 
%   setup before report generation begins.

%% - I intend to remove this. - the corresponding warning should be removed with it
% % % %The setup function "SDD_RPT_Setup" produced an error - variables won't be set right
% % % 
% % % if errorIn_SDD_RPT_Setup
% % %     summaryOfWarnings{end+1} = getWarningMessage('msgErrorIn_SDD_RPT_Setup', model);
% % % end

%% - Might be redundant now with assertions
%The config file '<model>_SDD_Config' did not run properly (not found/had error) - variables may not be set appropriately

if errorIn_model_SDD_Config
    summaryOfWarnings{end+1} = getWarningMessage('msgErrorIn_model_SDD_Config', model);
end

%%
%subsystemList is used assuming it is 1 by X or X by 1 so this checks if it meets that criteria
if size(subsystemList,1) ~= 1 && size(subsystemList,2) ~= 1
    summaryOfWarnings{end+1} = getWarningMessage('msgBadSubListDimension');
end

%%
%Warn the user of any subsystems that may have been specified for the model which don't exist
for i = 1:length(badSubList)
    if ~allowBadSubsystemNames
        summaryOfWarnings{end+1} = getWarningMessage('msgSubsystemNotExist', badSubList{i}, model);
    end
end