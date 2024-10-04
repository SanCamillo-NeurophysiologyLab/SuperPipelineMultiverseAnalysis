% SPMA_CHECKDATATYPE - Check the internal dataype of a data object
%
% Usage:
%     >> [dataType] = SPMA_checkDataType(data)
%
% Inputs:
%    data        = [any] A set of data
%
% Outputs:
%    dataType = [string] The datatype of the input object. Possible values
%           are: "Unknown", "EEGLAB", "CellArray"
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: EEGLAB

function [dataType] = SPMA_checkDataType(data)
    arguments (Input)
        data
    end
    arguments (Output)
        dataType string {mustBeMember(dataType, ["Unknown", "EEGLAB", "CellArray"])}
    end

    dataType = "Unknown";

    if isEEGLAB(data)
        dataType = "EEGLAB";
        return
    elseif iscell(data)
        dataType = "CellArray";
        return
    end



end

function yesno = isEEGLAB(data)
    yesno = false;
    % All EEGLAB fields
    EEGLAB_fields = { 'setname' ...
    'filename' ...
    'filepath' ...
    'subject' ...
    'group' ...
    'condition' ...
    'session' ...
    'comments' ...
    'nbchan' ...
    'trials' ...
    'pnts' ...
    'srate' ...
    'xmin' ...
    'xmax' ...
    'times' ...
    'data' ...
    'icaact' ...
    'icawinv' ...
    'icasphere' ...
    'icaweights' ...
    'icachansind' ...
    'chanlocs' ...
    'urchanlocs' ...
    'chaninfo' ...
    'ref' ...
    'event' ...
    'urevent' ...
    'eventdescription' ...
    'epoch' ...
    'epochdescription' ...
    'reject' ...
    'stats' ...
    'specdata' ...
    'specicaact' ...
    'splinefile' ...
    'icasplinefile' ...
    'dipfit' ...
    'history' ...
    'saved' ...
    'etc' };

    if isstruct(data)
        % get the name of the fields of data
        data_fields = fieldnames(data)';
%         % if there are less fields than the expected EEGLAB fields,
%         % something is missing, therefore it is not a valid EEGLAB
%         % structure
%         if length(data_fields) < length(EEGLAB_fields)
%             return
%         end
        
        % It is an EEGLAB struct if all the EEGLAB fields are present in
        % the data structure
        yesno = all(ismember(EEGLAB_fields, data_fields));

    end
end