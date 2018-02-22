function [appendixTables, appendixTableTitles] = AppendixTables(subsystemList,getUnit,dataTypeMap)
% APPENDIXTABLES is capable of generating tables to be used in the appendix
%   of the report generated by SDD_Report. 
%   This function can be modified to work as desired by the user.
%   However, the interface of this function should not be altered else 
%   changes would need to be made where this function is called within 
%   SDD_Report.rpt.
%   The default of this function will not create any tables.
%
%   Two example functions have been created to generate appendix tables, 
%   they may be useful to help figure out how to make another function or 
%   they may help to see what could be inlcuded in the appendix.
%
%   Inputs:
%       subsystemList   The cell array of Simulink systems described in 
%                       Report_Specific_Files/TopsysName_SDD_Config.
%       getUnit         The user defined function described in 
%                       Report_Specific_Files/TopsysName_SDD_Config. Takes
%                       a block as input and returns the physical units of
%                       its output.
%       dataTypeMap     A Container.Map produced through a function in the
%                       Signature Tool which relates a block to its output
%                       data type.
%       ^These inputs can be used to help find information about blocks in 
%       systems in subsystemList.
%
%   Outputs:
%       appendixTables      A cell array of 1 x n matrices of 1 x 1 cell 
%                           arrays. Each row of the tables that will be 
%                           generated is represented by a 1 x n matrix in 
%                           the appendixTables cell array.
%       appendixTableTitles Provides a title to correspond with tables in
%                           appendixTables.

appendixTables = {};
appendixTableTitles = {};

%Table of variables from file (e.g. a calibration file)
% [appendixTables{end+1}, appendixTableTitles{end+1}] = tableFromVarsInFile('<insert_script_name>','Variables From File');

%Table of blocks of some description in the subsystemList (e.g. if some blocks are used as calibrations)
% [appendixTables{end+1}, appendixTableTitles{end+1}] = tableFromBlocksInSubList(subsystemList,getUnit,dataTypeMap, @findBlockFunction, title);
end

function [appendixTable, appendixTableTitle] = tableFromBlocksInSubList(subsystemList,getUnit,dataTypeMap, findXBlocks, title)
%Prepares a table listing blocks returned by the findXBlocks function
%   The tables will give the block names with their, 
%       units, min, max, data type, and block description

%Example case in which this could be used:
%   A list of all blocks of a given type are desired in the appendix

%title is a char indicating what the title of the table should be
%findXBlocks is a function which takes a simulink system as input and
%   returns a 1xn cell array of blocks

tableHeader = [{'Name'}, {'Units'}, {'Min'}, {'Max'}, {'Data Type'}, {'Description'}];
appendixTable = tableHeader;
appendixTableTitle = title; % E.g. 'X Blocks From Model'

xBlocks = [];
for sys = subsystemList
    xBlocks = [xBlocks; findXBlocks(char(sys))]; %% Change this
end

for i = 1:length(xBlocks)
    appendixTable = [appendixTable; findBlockInfo(xBlocks(i), dataTypeMap, getUnit)];
end
end

function [appendixTable, appendixTableTitle] = tableFromVarsInFile(script,title)
%Prepares a table listing variables which are declared at the end of a call to another MATLAB script
%   The tables will give the variable name with their type and value

%Example case in which this could be used:
%   The system being documented has a calibration file of some sort
%   associated with it

%Note this actually runs the given file.

%title is a char indicating what the title of the table should be
%script is the MATLAB file which will be run

tableHeader = [{'Name'}, {'Data Type'}, {'Value'}];
appendixTable = tableHeader;
appendixTableTitle = title;

currentVariables = who; % Variables already on the path
currentVariables{end+1} = 'currentVariables';
run(script);
newVariables = setdiff(who,currentVariables); % These are the variables we want to include in the appendix in this case

for i = 1:length(newVariables)
    var = newVariables{i};
    dataType = class(eval(var));
    value = eval(var);
    appendixTable = [appendixTable; {var}, {dataType}, {value}];
end
end