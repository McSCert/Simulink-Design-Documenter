function [table, title] = TableSetup(system, dataTypeMap, getUnit, blockType)
%TABLESETUP Finds blocks of a given type within a given system and returns 
%   details about those blocks to form a table in a document.
%
%   Inputs:
%       system          A Simulink system (e.g. gcs).
%       dataTypeMap     A container.map relating blocks to their output 
%                       data type.
%       getUnit         A function which takes a block as input and returns
%                       the physical units of its output
%       blockType       The type of blocks to include in the given table.
%                       This will also correspond with the title used for 
%                       the table.
%
%   Outputs:
%       table           An array which is compatible with the Array-Based 
%                       Table component in Simulink Report Generator
%                       containing details about a block within each row.
%                       The details are: [Block, Unit, Min, Max, Data Type, Description]
%       title           Title used in documentation for table.

%Set title
switch blockType
    case 'Inport'
        title = 'Inports';
    case 'DataStoreRead'
        title = 'Data Store Reads';
    case 'From'
        title = 'Froms';
    case 'Outport'
        title = 'Outports';
    case 'DataStoreWrite'
        title = 'Data Store Writes';
    case 'Goto'
        title = 'Gotos';
    case 'DataStoreMemory'
        title = 'Data Store Declarations';
    case 'GotoTagVisibility'
        title = 'Goto Tag Declarations';
    case 'SubSystem'
        title = 'Subsystems';
    otherwise
        title = blockType;
end

%Set table header
tableHeader = [{'Block'}, {'Unit'}, {'Min'}, {'Max'}, {'Data Type'}, {'Description'}];
table = tableHeader;

blocks = findBlocks(system,blockType);

%Fill the table with information about the blocks
for i = 1:length(blocks)
    table = [table; findBlockInfo(blocks(i), dataTypeMap, getUnit)];
end
end

function blocks = findBlocks(system,blockType)
%Find the blocks to fill the table

if strcmp(blockType,'SubSystem')
    blocks=find_system(system, 'SearchDepth', '1', 'LookUnderMasks', 'all', 'BlockType', blockType, 'MaskType', '');
    if ~strcmp(system,bdroot)
        blocks=blocks(2:end);
    end
elseif strcmp(blockType,'Goto')
    blocks=find_system(system, 'SearchDepth', '1', 'LookUnderMasks', 'all', 'BlockType', blockType, 'MaskType', '');
    
    % Exclude local gotos
    blocks=blocks(~strcmp(get_param(blocks,'TagVisibility'),'local'));
elseif strcmp(blockType,'From')
    blocks=find_system(system, 'SearchDepth', '1', 'LookUnderMasks', 'all', 'BlockType', blockType, 'MaskType', '');
    
    % Exclude froms at the same level, in the same subsystem, as their corresponding goto
    gotos=find_system(system, 'SearchDepth', '1', 'LookUnderMasks', 'all', 'BlockType', 'Goto', 'MaskType', '');
    for i = 1:length(gotos)
        % if any from has the same goto tag as the current goto, then it isn't needed for the interface (as the source is from within)
        blocks=blocks(~strcmp(get_param(blocks,'GotoTag'),get_param(gotos{i},'GotoTag')));
    end
    
    % Exclude local froms
    blocks=blocks(~strcmp(get_param(blocks,'TagVisibility'),'local'));
else
    blocks=find_system(system, 'SearchDepth', '1', 'LookUnderMasks', 'all', 'BlockType', blockType);
end
end