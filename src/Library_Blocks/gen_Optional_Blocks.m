function gen_Optional_Blocks(system)
% This function has been outdated by new requirements (in principal the idea
%   was the same as with gen_SDD_Blocks).

x = 90; %Horizontal spacing between the generated blocks

[blockFullName, ~] = gen_SDD_Block(system, 'Purpose');
pos = get_param(blockFullName, 'Position');

[blockFullName, ~] = gen_SDD_Block(system, 'Scope');
pos = [pos(1)+x, pos(2), pos(3)+x, pos(4)];
set_param(blockFullName,'Position', pos);

[blockFullName, ~] = gen_SDD_Block(system, 'Definitions');
pos = [pos(1)+x, pos(2), pos(3)+x, pos(4)];
set_param(blockFullName,'Position', pos);

[blockFullName, ~] = gen_SDD_Block(system, 'Acronyms');
pos = [pos(1)+x, pos(2), pos(3)+x, pos(4)];
set_param(blockFullName,'Position', pos);
end