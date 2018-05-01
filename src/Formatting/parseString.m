function parsedString = parseString(str)
% PARSESTRING parses through a char array (a string), str, to put it in a 
%   format for RptGen to use to determine what to do (syntax and options 
%   will be described later).
%
%   Inputs:
%       str             A string.  
%
%   Outputs:
%       parsedString    A cell array in which the entries sequentially 
%                       separate str into parts depending on what RptGen 
%                       will need to do and when it will need to do it.
%                       The entries in the cell array are 1 x n cell arrays
%                       in which the first cell indicates what RptGen will 
%                       need to do, and the following cells 
%                       provide details.
%                       The firs cell may be: 'Linking anchor', 
%                       'Internal document link', 'Text', or 'Newline'.
%                       For 'Linking anchor' and 'Internal document link',
%                       the following 2 cells shall indicate a LinkID and 
%                       the LinkText.
%                       For 'Text' the following cell should simply be the 
%                       appropriate text to print in the report.
%                       For 'Newline' there are no following cells.
%
%   Details on the syntax for the input string:
%       Lines starting with '%' are ignored.
%
%       Refer to a variable:
%           [var=<VariableName>]
%       <VariableName> is a variable in the base workspace of type char
%           array (e.g. topsys or some other config variable)
%       
%       Make an 'Internal Document Link' (i.e. a link):
%           [goto=<LinkID>]<LinkText>[/goto]
%       <LinkID> identifies a point in the document to link to 
%           (you'll most likely need to define this with a linking anchor which is described below)
%           LinkID may not contain a ']' as this character indicates the
%           end of the LinkID
%       <LinkText> is the text that you'll press to go to the linking anchor
%
%       Make a "Linking Anchor" (i.e. the spot the corresponding Internal Document Link takes you to):
%           [anchor=<LinkID>]<LinkText>[/anchor]
%       <LinkText> is the text that gets linked to (this may be left blank)
%
%        E.g. In the middle of a sentence you can add a linking anchor: [anchor=my anchor]link destination[/anchor].
%        You can later create a link to that anchor with: [goto=my anchor]this[/goto]
%           -when "this" is clicked in the report you will be taken to "link destination".
%
%       Newlines occur when there are 2 or more consecutive newlines in the input string
%       Specifically the number of newlines that will appear is 1 less than the number of consecutive newline characters
%       (The reason for this is so the text file used for the input can still be readable without needing text wrapping)
%
%   Example:
%       A text file that will be parsed within SDD_Report may look as in the following 5 lines (ignore the 1st '%' on each line here):
% 1Lorem ipsum [anchor=my anchor]2Lorem[/anchor]
% %This will not matter
% 3Lorem ipsum
%
% [goto=my anchor]4Lorem[/goto] 5Lorem
%
%       ^This is essentially equivalent to the result of the following in Matlab:
%           sprintf(['1Lorem ipsum [anchor=my anchor]2Lorem[/anchor]\n%%This will not matter\n3Lorem ipsum\n\n[goto=my anchor]4Lorem[/goto] 5Lorem'])
%
%       Since the text file will be parsed within SDD_Report, it will be 
%       read and passed into this function to give the following:
%       {{{'Text'},{sprintf('1Lorem ipsum ')}}, {{'Linking anchor'},{sprintf('my anchor')},{sprintf('2Lorem')}},{{'Text'},{sprintf('3Lorem ipsum\n')}},{{'Newline'}},{{'Text'},{sprintf('\n')}},{{'Internal document link'},{sprintf('my anchor')},{sprintf('4Lorem')}},{{'Text'},{sprintf(' 5Lorem')}}}
%
%       Note that this output is usable within SDD_Report if it is set up accordingly
%       Also note that: things like {{'Text'},{sprintf'\n'}} should have no effect in SDD_Report (it is set up to essentially ignore newlines).
%
%
%   If the output doesn't look as you expect, it may be useful to note that
%   the the output, parsedString, is sent to a Text component within report generator
%   (which may result in some awkward formatting).

%First remove the user commented lines (lines beginning with a '%'
percents = strfind(str,'%');
if ~isempty(percents) && percents(1) == 1 %Checking the first line right away since it wouldn't be noticed with the method used for finding the commented lines in the code below
    commentPos = 1;
else
    commentPos = [];
end
startOfLinePercents = strfind(str,[sprintf('\n'), '%']) + 1;
commentPos = [commentPos, startOfLinePercents];

for i = length(commentPos):-1:1
    newline = strfind(str(commentPos(i):end),sprintf('\n'));
    
    if isempty(newline)
        str = str(1:commentPos(i)-2);
    else
        str = [str(1:commentPos(i)-1),str(commentPos(i)+newline(1):end)];
    end
end

%Next use the syntax described at the top of this function to separate str into appropriate parts

parsedString={};
varName = '[var=';
gotoStart = '[goto=';
gotoEnd = '[/goto]';
anchorStart = '[anchor=';
anchorEnd = '[/anchor]';
urlStart = '[url=';
urlEnd = '[/url]';
imageStart = '[image=';
imageEnd = '[/image]';

% Make the newline notation consistent regardless of platform (this was not well tested)
str = strrep(str,sprintf('\r\n'),sprintf('\n'));
str = strrep(str,sprintf('\r'),sprintf('\n'));

newline = sprintf('\n\n');

while ~isempty(str)
    varLoc = strfind(str,varName);
    anchorLoc = strfind(str,anchorStart);
    gotoLoc = strfind(str,gotoStart);
    urlLoc = strfind(str,urlStart);
    imageLoc = strfind(str,imageStart);
    newlineLoc = strfind(str,newline);
    
    keyLocs = {varLoc, anchorLoc, gotoLoc, urlLoc, imageLoc, newlineLoc};
    if ~isempty(varLoc) && varLoc(1) == 1
        [parsedString, str] = parseVarTag(parsedString,str,varName);
    elseif ~isempty(gotoLoc) && gotoLoc(1) == 1
        [parsedString, str] = parseLinkTag(parsedString,str,gotoStart,gotoEnd,'Internal document link');
    elseif ~isempty(anchorLoc) && anchorLoc(1) == 1
        [parsedString, str] = parseLinkTag(parsedString,str,anchorStart,anchorEnd,'Linking anchor');
    elseif ~isempty(urlLoc) && urlLoc(1) == 1
        [parsedString, str] = parseLinkTag(parsedString,str,urlStart,urlEnd,'URL (external) link');
    elseif ~isempty(imageLoc) && imageLoc(1) == 1
        [parsedString, str] = parseImageTag(parsedString,str,imageStart,imageEnd);
    elseif ~isempty(newlineLoc) && newlineLoc(1) == 1
        parsedString{end+1} = {{'Newline'}};
        try
            str = str(2:end);
        catch
            str = [];
        end
    else
        nextKeyLoc = findNextKeyLoc(str, keyLocs);
        parsedString{end+1} = {{'Text'},{str(1:nextKeyLoc-1)}};
        try
            str = str(nextKeyLoc:end);
        catch
            str = [];
        end
    end
end

if isempty(parsedString)
    parsedString = 'N/A';
end
end

function [parsedString, str] = parseVarTag(parsedString,str,tag)
%For a given string, str, this will identify the string on the base
%workspace with the same name and add value in parsedString.
%Also updates the str to exclude everything before the parsed text
varStart = 1+length(tag);
varEnd = strfind(str,']')-1; %1st value of pathEnd is the index of the last character in the varName
varName = str(varStart:varEnd(1));
varValue = evalin('base', varName);
assert(ischar(varValue))
parsedString{end+1} = {{'Text'},{varValue}};

try
    str = str(varEnd+1+1:end);
catch
    str = [];
end
end

function [parsedString, str] = parseImageTag(parsedString,str,startTag,endTag)
%For a given string, str, this will identify imagePath and imageTitle and add them to parsedString appropriately
%Also updates the str to exclude everything before the parsed text
pathStart = 1+length(startTag);
pathEnd = strfind(str,']')-1; %1st value of pathEnd is the index of the last character in the imagePath
imagePath = str(pathStart:pathEnd(1));
titleStart = pathEnd(1)+2;
titleEnd = titleStart + strfind(str(titleStart:end),endTag)-2; %1st value of titleEnd is the index of the last character in the imageTitle
imageTitle = str(titleStart:titleEnd(1));
parsedString{end+1} = {{'Image'},{imagePath},{imageTitle}};

try
    str = str(titleEnd+length(endTag)+1:end);
catch
    str = [];
end
end

function [parsedString, str] = parseLinkTag(parsedString,str,startTag,endTag,linkType)
%For a given string, str, this will identify LinkID and LinkText and add them to parsedString appropriately
%Also updates the str to exclude everything before the parsed text
idStart = 1+length(startTag);
idEnd = strfind(str,']')-1; %1st value of idEnd is the index of the last character in the LinkID
assert(~isempty(idEnd),'Error in parseLinkTag in parseString.m. There''s likely an issue with the string being parsed.');
linkID = str(idStart:idEnd(1));
textStart = idEnd(1)+2;
textEnd = textStart + strfind(str(textStart:end),endTag)-2; %1st value of textEnd is the index of the last character in the LinkText
assert(~isempty(textEnd),'Error in parseLinkTag in parseString.m. There''s likely an issue with the string being parsed.');
linkText = str(textStart:textEnd(1));
parsedString{end+1} = {{linkType},{linkID},{linkText}};

try
    str = str(textEnd+length(endTag)+1:end);
catch
    str = [];
end
end

function nextKeyLoc = findNextKeyLoc(str, locationSets)
%Finds the next important location in str
%locationSets is a cell array
%	Each element is a matrix of positions corresponding to all of the different types of important points
%	Each matrix is 1D, the values are ordered from lowest to highest, and each value represents the location of a important point in str

if isempty(locationSets)
    nextKeyLoc = length(str);
else
    next = length(str)+1; %This is worst case for reasonable inputs
    for i = 1:length(locationSets)
        if ~isempty(locationSets{i})
            check = locationSets{i}(1);
            if check < next
                next = check;
            end
        end
    end
    nextKeyLoc = next;
end
end