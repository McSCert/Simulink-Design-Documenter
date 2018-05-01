function blockInfo = findBlockInfo(block, dataTypeMap, getUnit)
%FINDBLOCKINFO Returns details about a given block. Includes: (Name, 
%   Unit, Min, Max, Data Type, Description) 
%
%   Inputs:
%       block           Full name (including path) of a given block
%       dataTypeMap     A container.map relating blocks to their output 
%                       data type
%       getUnit         A function which takes a block as input and returns
%                       the physical units of its output
%
%   Outputs:
%       blockInfo       Info about given block given in the following form:
%                       [{'Name'}, {'Min'}, {'Max'}, {'Data Type'},
%                       {'Unit'}, {'Description'}] where each char is
%                       replaced with an appropriate value for the block.

%Find appropriate values for the row entries
blockName = strrep(get_param(block,'Name'),sprintf('\n'),' ');
unit = getUnit(block);
try
    min = get_param(block,'OutMin');
    max = get_param(block,'OutMax');
catch
    min = {'N/A'};
    max = {'N/A'};
end

%TODO mapDataTypes.m needs to be improved to find a type for every block 
try
    type = dataTypeMap(char(block));
catch
    type = {''};
end

description = get_param(block, 'Description');
% if strcmp(description,'')
%     description = {'N/A'};
% end

%Set ith row entries
blockInfo = [blockName, type, min, max, unit, description];
end