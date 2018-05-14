% Find the appropriate file to add to the document

clear 'fullFilePath'
fileType = '';
% Prioritize finding a .txt file
defaultFileType = '.txt';
secondFileType = '.doc';
if exist('pathToIntroSections','var')
    % Try finding file with defaultFileType
    fullFilePath = which([pathToIntroSections, ...
        '\SDD_', introSections{RPTGEN_LOOP}, defaultFileType]);
else
    fullFilePath = which(['\SDD_', ...
        introSections{RPTGEN_LOOP}, defaultFileType]);
end

if ~isempty(fullFilePath)
    fileType = defaultFileType(2:end);
end

if ~strcmp(fileType,defaultFileType(2:end))
    % Try finding file with secondFileType
    if exist('pathToIntroSections','var')
        fullFilePath = which([pathToIntroSections, ...
            '\SDD_', introSections{RPTGEN_LOOP}, secondFileType]);
    else
        fullFilePath = which(['\SDD_', ...
            introSections{RPTGEN_LOOP}, secondFileType]);
    end
    
    if ~isempty(fullFilePath)
        fileType = secondFileType(2:end);
    end
end

% If .txt then get the text
if strcmp(fileType,'txt')
    if ~isempty(fullFilePath)
        stringToParse = fileread(fullFilePath);
        if isempty(stringToParse) || ...
                strcmp(...
                strrep(stringToParse,sprintf('\r\n'),sprintf('\n')),...
                getDefaultLibraryBlockUserData(...
                ['General ', introSectionsInNnP{RPTGEN_LOOP}])...
                )
            
            stringToParse = 'N/A';
        end
    end
end
if ~strcmp(fileType,secondFileType(2:end)) %If not doc and not txt
    % Then just pretend it's a text file that says N/A
    fileType = 'txt';
    stringToParse = 'N/A';
end