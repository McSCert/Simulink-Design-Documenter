function [sddBlockDescription, specificComments] = getSddBlockDescription(blockTitle)
% GETSDDBLOCKDESCRIPTION Gives descriptions for DocBlocks depending on
%   what the contents of the documentation should be.
%
%   Inputs:
%       blockTitle                  The name of the DocBlock that should be
%                                   generated. This is also used to 
%                                   determine how to set the block's
%                                   UserData and Description.
%                                   Its value should be in the following 
%                                   list:
%                                   {'Purpose','Internal Design',
%                                   'Rationale',
%                                   'Requirements Specification',
%                                   'Anticipated Changes',
%                                   'Document Purpose',
%                                   'Scope','General Definitions',
%                                   'General Acronyms','General Notation',
%                                   'System Definitions','System Acronyms',
%                                   'System Notation'}
%
%   Outputs:
%       sddBlockDescription     Description used by the blocks in the
%                                   "SDD Blocks" library.
%                                   Empty string for an unexpected 
%                                   blockTitle.
%       specificComments            Additional description for the blocks
%                                   which can be used as well.

switch blockTitle
    case 'Purpose'
        sddBlockDescription = ['This is the ', blockTitle, ' which ', ...
            'should specify what the system is designed to accomplish.\n'];
        specificComments = 'It should explain the need of the system.\n';
    
    case 'Internal Design'
        sddBlockDescription = ['This is the ', blockTitle, ' which ', ...
            'should specify how the internal structure of the system fulfills its purpose.\n'];
        specificComments = 'It should describe internal algorithms, signals, and constants.\n';    
        
    case 'Rationale'
        sddBlockDescription = ['This is the ', blockTitle, ' which ', ...
            'should justify why design decisions were made.\n'];
        specificComments = 'It should also justify why alternative design decisions that were considered were not selected.\n';
        
    case 'Anticipated Changes'
        sddBlockDescription = ['This is the ', blockTitle, ' which ', ...
            'should describe alterations that may need to be made to the system.\n'];
        specificComments = ['This information should help developers to implement designs which will be easier to modify to accommodate these changes.\n', ...
            'If no changes have been anticipated, the contents can be set to "N/A".\n'];
    
    case 'Requirements Specification'
        sddBlockDescription = ['This is the ', blockTitle, ' DocBlock which ', ...
            'should specify system requirements that should be addressed in the given system.\n'];
        specificComments = '';
        
        
    case 'Document Purpose'
        sddBlockDescription = ['This is the ', blockTitle, ' which should explain purpose of software design description documents.\n'];
        specificComments = 'The contents for this should be general enough that it may be used verbatim in a number of internal reports.\n';
        
    case 'Scope'
        sddBlockDescription = ['This is the ', blockTitle, ' which should elaborate on what is and is not to be included in software design description documents.\n'];
        specificComments = 'The contents for this should be general enough that it may be used verbatim in a number of internal reports.\n';

    case 'General Definitions'
        sddBlockDescription = ['This is the ', blockTitle, ' which should list and explain any definitions, not specific to the system, that may be helpful for the reader of the document to know.\n'];
        specificComments = ['It may be useful to link to the definitions listed here from other parts of the document.\n', ...
            'You may allow this by writing the definitions in the following format for example: [anchor=<word being defined>]<word being defined>: <definition of the word>[/anchor]\n', ...
            'You could then link to it from other DocBlocks being used in the report like this: [goto=<word being defined>]<word being defined>[/goto]\n'];
        
    case 'General Acronyms'
        sddBlockDescription = ['This is the ', blockTitle, ' which should list and explain any acronyms, not specific to the system, that may be helpful for the reader of the document to know.\n'];
        specificComments = ['It may be useful to link to the acronyms listed here from other parts of the document.\n', ...
            'You may allow this by writing the acronyms in the following format for example: [anchor=<acronym>]<acronym>: <acronym written in words>[/anchor]\n', ...
            'You could then link to it from other DocBlocks being used in the report like this: [goto=<acronym>]<acronym>[/goto]\n'];
        
    case 'General Notation'
        sddBlockDescription = ['This is the ', blockTitle, ' which should explain any notation, not specific to the system, that may be helpful for the reader of the document to know.\n'];
        specificComments = '';
            
    case 'System Definitions'
        sddBlockDescription = ['This is the ', blockTitle, ' which should list and explain any definitions, specific to the system, that may be helpful for the reader of the document to know.\n'];
        specificComments = ['It may be useful to link to the definitions listed here from other parts of the document.\n', ...
            'You may allow this by writing the definitions in the following format for example: [anchor=<word being defined>]<word being defined>: <definition of the word>[/anchor]\n', ...
            'You could then link to it from other DocBlocks being used in the report like this: [goto=<word being defined>]<word being defined>[/goto]\n'];
        
    case 'System Acronyms'
        sddBlockDescription = ['This is the ', blockTitle, ' which should list and explain any acronyms, specific to the system, that may be helpful for the reader of the document to know.\n'];
        specificComments = ['It may be useful to link to the acronyms listed here from other parts of the document.\n', ...
            'You may allow this by writing the acronyms in the following format for example: [anchor=<acronym>]<acronym>: <acronym written in words>[/anchor]\n', ...
            'You could then link to it from other DocBlocks being used in the report like this: [goto=<acronym>]<acronym>[/goto]\n'];

    case 'System Notation'
        sddBlockDescription = ['This is the ', blockTitle, ' which should explain any notation, specific to the system, that may be helpful for the reader of the document to know.\n'];
        specificComments = '';

    otherwise
        sddBlockDescription = '';
        specificComments = '';
end