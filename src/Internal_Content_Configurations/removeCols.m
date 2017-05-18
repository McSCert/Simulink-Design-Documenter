function table = removeCols(table, cols)
% REMOVECOLS Removes columns indicated by cols from table.
%
%	Inputs:
%		table 	n x m cell array
%		cols 	1 x m array, for every true value in cols, the 
%				corresponding column will be REMOVED from table.
%
%	Outputs:
%		table 	Modified table with indicated columns removed
%
%	Example:
%		table = removeCols([1 4 7 2],[0 1 0 1])
%		returns [1 7]

assert(size(table,2) == length(cols)) %Ensure appropriate input
for i = length(cols):-1:1 %Reverse order to avoid altering indices part-way
    if cols(i) %Current value is 1 (or otherwise true..)
        table(:,i) = []; %Remove column
    end
end
end