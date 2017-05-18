function gen_System_Blocks(system, sections)
%GEN_SYSTEM_BLOCKS generates DocBlocks used by SDD_REPORT in the given 
%   system.
%
%   Inputs:
%       system      A Simulink system (as returned by gcs)
%       sections    Indicates which types of sections to generate.
%                   'sub' will include the following sections:
%                       {'Purpose','Internal Design', 'Requirements Specification', 'Rationale', 'Anticipated Changes'}
%                   'top' will include the following sections:
%                       {'System Definitions', 'System Acronyms'}
%                   'all' will include all sections between 'sub' and 'top'
%                   otherwise none are included included
%
%   This function was intended for use during development for testing and
%   to simplify updating the SDD Block Library (it is not actually used 
%   during report generation). We recommend simply using the SDD Block 
%   Library, but if the user prefers, then they may use this function.

x = 160; %Horizontal spacing between the generated blocks
y = 70;  %Vertical spacing between the generated blocks

subsystemSections = {'Purpose','Internal Design', 'Requirements Specification', 'Rationale', 'Anticipated Changes'};
topLevelSections = {'System Definitions', 'System Acronyms'}; %%%TODO add changelog (unlike the other blocks, this would add the changelog from the SDD Blocks library)

%Removing the sections that aren't needed
switch sections
    case 'all'
    case 'top'
        subsystemSections = {};
    case 'sub'
        topLevelSections = {};
    otherwise
        subsystemSections = {};
        topLevelSections = {};
end

row = 0;

%TODO make this a function
firstIter = true;
row = row+1;
for iSec = subsystemSections
    %Create the DocBlock
    [blockFullName, ~] = gen_SDD_Block(system, iSec{1});
    
    %Move the DocBlock into position
    if firstIter && row==1 || ~(exist('pos','var'))
        pos = get_param(blockFullName, 'Position');
        pos1 = pos;
        firstIter = false;
    elseif firstIter && row>1 %Start a new row if it's the first block in this group (and not the first group of blocks)
        pos = nextRow(pos1, y);
        set_param(blockFullName,'Position', pos);
        firstIter = false;
    else
        pos = nextCol(pos, x);
        set_param(blockFullName,'Position', pos);
    end
end

firstIter = true;
row = row+1;
for iSec = topLevelSections %This line is the only change from the code above
    %Create the DocBlock
    [blockFullName, ~] = gen_SDD_Block(system, iSec{1});
    
    %Move the DocBlock into position
    if firstIter && row==1 || ~(exist('pos','var'))
        pos = get_param(blockFullName, 'Position');
        pos1 = pos;
        firstIter = false;
    elseif firstIter && row>1 %Start a new row if it's the first block in this group (and not the first group of blocks)
        pos = nextRow(pos1, y);
        set_param(blockFullName,'Position', pos);
        firstIter = false;
    else
        pos = nextCol(pos, x);
        set_param(blockFullName,'Position', pos);
    end
end
end

function pos = nextCol(pos, x)
pos = [pos(1)+x, pos(2), pos(3)+x, pos(4)];
end

function pos = nextRow(pos1, y)
pos = [pos1(1), pos1(2)+y, pos1(3), pos1(4)+y];
end