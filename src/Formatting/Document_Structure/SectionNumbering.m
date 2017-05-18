classdef SectionNumbering < handle
% SECTIONNUMBERING keeps track of the relative position of the current 
%   chapter/subsection in report generator.
%
%   Examples:
%       obj = SectionNumbering() - create an instance at the start of a report
%       obj = SectionNumbering(Pos) - create an instance at the point 
%           designated by Pos where Pos is a cell array of integers
%
%   Properties (note these will be illustrated below as well):
%       Pos     Indicates relative position of a given chapter/subsection
%               in a cell array.
%       PosStr  Represents Pos as a string which can be used in chapter/
%               subsection headings.
%       Depth   Indicates the degree of nesting for a chapter/subsection.
%
% The layout below represents sections in a report and gives the Pos and 
%   PosStr values that correspond with it:
%  1. xxx           % Pos = {1};        PosStr = ''; <- when there's a single element, report generator will take care of the posStr automatically
%   1.1 xxx         % Pos = {1,1};      PosStr = '1.1.';
%       1.1.1 xxx   % Pos = {1,1,1};    PosStr = '1.1.1.';
%   1.2 xxx         % Pos = {1,2};      PosStr = '1.2.';    <-Depth = 2
%   1.3 xxx         % Pos = {1,3};      PosStr = '1.3.';
%       1.3.1 xxx   % Pos = {1,3,1};    PosStr = '1.3.1.';  <-Depth = 3
%       1.3.2 xxx   % Pos = {1,3,2};    PosStr = '1.3.2.';
%  2. xxx           % Pos = {2};        PosStr = '';        <-Depth = 1
%   2.1 xxx         % Pos = {2,1};      PosStr = '2.1.';
    
    properties
        Pos %Relative position
        PosStr %String representation of Pos (i.e. PosStr)
        Depth %Section depth
    end
    methods
        function obj = SectionNumbering(Pos)
            %SectionNumbering constructor, optionally takes Pos as
            %   described earlier.
            %Pos should represent the current Pos in the report
            %Pos is a cell array in which each element should be an integer
            if nargin == 0
                obj.Pos = {0}; %This is before entering the first chapter, obj.step() would need to be run before entering to get the Pos for that section
            elseif nargin == 1
                obj.Pos = Pos;
            end
            obj.upDepth();
            obj.upPosStr();
        end
        function obj = step(obj)
            %Use before starting a section (before the Chapter/Subsection component)
            obj.Pos{end} = obj.Pos{end} + 1;
            obj.upDepth();
            obj.upPosStr();
        end
        function obj = stepin(obj)
            %Use when entering a section (after the Chapter/Subsection component)
            obj.Pos{end+1} = 0;
            obj.upDepth();
            obj.upPosStr();
        end
        function obj = stepout(obj)
            %Use when exiting a section
            %   (Note this function may need to be called multiple times as
            %   the report may step out more than one section level)
            obj.Pos = obj.Pos(1:end-1);
            obj.upDepth();
            obj.upPosStr();
        end
        function obj = upPosStr(obj)
            %Update PosStr
            if length(obj.Pos) == 1
                obj.PosStr = '';
            elseif length(obj.Pos) > 1
                obj.PosStr = '';
                for i = 1:length(obj.Pos)
                    obj.PosStr = [obj.PosStr, num2str(obj.Pos{i}), '.'];
                end
           end
        end
        function obj = upDepth(obj)
            %Update Depth
            obj.Depth = length(obj.Pos);
        end
    end
end