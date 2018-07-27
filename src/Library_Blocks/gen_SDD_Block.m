function [blockFullName, propertiesDescription] = gen_SDD_Block(system, blockTitle)
% GEN_SDD_BLOCK generates the indicated DocBlock in the given system. Also
%   returns some information about the created block for the caller to use
%   if needed.
%
%   Inputs:
%       system      A Simulink system (as returned by gcs).
%       blockTitle  The name of the DocBlock that should be generated. This
%                   is also used to determine how to set the block's
%                   UserData and Description.
%
%   Outputs:
%       blockFullName           Full name of the generated block.
%       propertiesDescription   The text included in the block's
%                               description. 
%                               With the GUI, the description of a block 
%                               can be found by right-clicking it and 
%                               selecting "Properties...", the description 
%                               will be written in the "General" tab of the
%                               window that pops up under "Description:".
%
%   This function was intended for use during development for testing and
%   to simplify updates of the SDD Block Library (it is not actually used 
%   during report generation).

blockFullName = [system, '/', blockTitle];

propertiesDescription = sprintf(getSddBlockDescription(blockTitle));

%Check if the block exists in the system already
if isempty(find_system(system, 'SearchDepth', '1', 'Parent', system, 'Name', blockTitle))
    userdataDescription = getDefaultSddBlockUserData(blockTitle);

    %Create the block
    add_block('simulink/Model-Wide Utilities/DocBlock', blockFullName, 'UserData', userdataDescription, 'Description', propertiesDescription, 'ShowName', 'on');
else
    disp([blockTitle, ' already exists in ', system])
end

set_param(blockFullName,'Selected','on');
pos = get_param(blockFullName, 'Position');
x = 40; %DocBlock width
y = 39; %DocBlock height
pos = [pos(1), pos(2), pos(1)+x, pos(2)+y];
set_param(blockFullName,'Position', pos);
end