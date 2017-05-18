function style = getSectionStyle(depth)
% GETSECTIONSTYLE for use with Simulink Report Generator, returns 
%   appropriate style to use for a Chapter/Subsection component based
%   on the section's depth with respect to other sections.
%   
%   Inputs:
%       depth   Section depth within a report.
%
%   Outputs:
%       style   Text style to use.
%
%   Anticipated Changes:
%       The desired return based on depth may be changed in the future 
%       depending on user preferences; the styles aren't particularly 
%       important.

switch depth
    case 1
        style = 'rgChapterTitle';
    case 2
        style = 'rgSect1Title';
    case 3
        style = 'rgSect2Title';
    case 4
        style = 'rgSect3Title';
    case 5
        style = 'rgSect4Title';
    otherwise
        style = 'rgSect5Title';
        %Normally other headings would be used eventually, but it may
        %become hard to distinguish between section headings and plain text
        %so we stop here while the headings still stand out sufficiently
end
end