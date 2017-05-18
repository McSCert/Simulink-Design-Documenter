function initVar(var,val)
% INITVAR If var does not exist in the caller's workspace, initialize 
%   variable indicated by var to value, val, in caller's workspace.
%
%   Inputs:
%       var     Variable to set in caller.
%       val     Value to set the given variable to.
%
%   Example:
%       initVar('x',1) %Initialize x to 1 (x=1)
%
% May have errors when val is input as a cell array/vectors -- unchecked, 
%   but it did seem like there was a case that caused unexpected output
%   (the case is avoided where this is used...)

varExist = evalin('caller',['exist(''',var,''',''var'')']);
if ~varExist
    assignin('caller',var,val);
end
end