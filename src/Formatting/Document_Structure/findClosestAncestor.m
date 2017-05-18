function closestAncestor = findClosestAncestor(system, subsystemList)
% FINDCLOSESTANCESTOR finds the closest ancestor of system in
%   subsystemList. 
%   Returns 'none' if no subsystems in the list are a direct ancestor of 
%   system.
%   Ancestor refers to a system/subsystem higher in the subsystem hierarchy
%   with a direct path to the given subsystem (i.e. not an uncle, but a 
%   grandparent for example).
%
%   Inputs:
%       system          A system including its path (same format as 
%                       returned by gcs).
%       subsystemList   A cell array of systems (including paths) in a 
%                       model.
%
%   Outputs:
%       closestAncestor A system including its path (same format as 
%                       returned by gcs).

if any(strcmp(subsystemList, get_param(system, 'Parent')))
    closestAncestor = get_param(system, 'Parent');
else %system parent isn't available in subsystemList
    if strcmp(get_param(system, 'Parent'), '') %system is top-level and has no parent
        closestAncestor = 'none';
    else
        %closest ancestor is the same as the closest ancestor of the parent
        closestAncestor = findClosestAncestor(get_param(system, 'Parent'), subsystemList); %Recursive step - other steps were base cases
    end
end
end