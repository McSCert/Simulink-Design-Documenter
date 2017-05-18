function systemTree = getBestSystemTree(subsystemList, varargin)
% GETBESTSYSTEMTREE finds the best 'tree' to use for the system hierarchy in
%   the report.
%
%   Inputs:
%       subsystemList   n x 1 (1 column) cell array of systems (including 
%                       paths) in a model.
%       varargin        Used in recursive calls to this function to pass a 
%                       node on the tree being formed
%
%   Outputs:
%       systemTree      A 1 x 2 cell array of cell arrays structured to 
%                       form a tree of systems and their child subsystems 
%                       within subsystemList. The first entry on a row is a
%                       node, the second on a row is a cell array of that 
%                       node's next decendents in subsystemList, other rows
%                       within the cell array are siblings within the 
%                       report. 
%                       Within the report, siblings should be at the same
%                       header level, while children should be one level
%                       lower.
%                       Please see the example below for more details about
%                       the format of the output.
%                       The structure for this output was decided based on
%                       the structure we wanted for the generated report.
%
%   Example:
%       System  Direct Children
%       A       B,C
%       B       D
%       C       -
%       D       E,F
%       E       -
%       F       G
%       ^Note A,B,C,D,E,F are the system names, though fullpaths are 
%       needed. E.g. B's fullpath would be 'A/B'.
%
%       subsystemList = {'A/B';'A/C';'A/B/D/E';'A/B/D/F/G'}
%       getBestSystemTree = (subsystemList)
%       result -> {'A/B',{'A/B/D/E',{}; 'A/B/D/F/G',{}}; 'A/C',{}}
%       ^this result tells us that (within the context of the report):
%       -B and C are siblings as they are on different rows of the same 
%       cell array
%       -likewise E and G are siblings
%       -E and G are (indirect) children to B as they are in the second
%       column of the row with B
%
%   Each call finds which subsystems from subsystemList go directly below a
%   given node in the tree (or which go at the top for the first iteration)
%   and recursively calls this function to find what comes next.

systemTree = {}; %Best system tree 
iVals = []; %Each element indicates (by index value) which subsystems in subsystemList have been added to the tree

for i = 1:length(subsystemList)
    if nargin == 1 ... %1st iteration of this recursive function
            && strcmp(findClosestAncestor(subsystemList{i},subsystemList),'none') %i.e. there is no subsystem in subsystemList higher in the model hierarchy than subsystemList{i}
        systemTree{end+1,1} = subsystemList{i}; %Add subsystem to the top of the tree
        iVals = [iVals,i]; %Record which subsystem in subsystemList was added to the tree
    elseif nargin > 1 ... %Beyond 1st iteration of recursion
            && strcmp(findClosestAncestor(subsystemList{i},[subsystemList;varargin{1}]),varargin{1}) %
        systemTree{end+1,1} = subsystemList{i};
        iVals = [iVals,i];
    end
end

%Removes subsystems from subsystemList which are in the tree
for i = length(iVals):-1:1
    subsystemList(iVals(i)) = [];
end

%Recursive step
%Finds the remainder of the tree from each of the current leaf nodes (...I think...)
for j = 1:length(systemTree)
    systemTree{j,2} = getBestSystemTree(subsystemList,systemTree{j,1});
end
end