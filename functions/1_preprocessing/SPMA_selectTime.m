% SPMA_SELECTTIME - Select a time window from an EEG dataset.
%
% Usage:
%     >> [EEG] = SPMA_selectTime(EEG)
%     >> [EEG] = SPMA_selectTime(EEG, 'key', val) 
%     >> [EEG] = SPMA_selectTime(EEG, key=val) 
%
% Inputs:
%    EEG        = [struct] EEG struct using EEGLAB structure system
%
% Optional inputs
%    AfterStart  = [double] Seconds to select after the start of the
%                   recording
%    BeforeEnd   = [double] Seconds to select before the end of the
%                   recording
%
% Outputs:
%    EEG = [struct] EEG struct using EEGLAB structure system
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: EEGLAB, POP_SELECT

function [EEG] = SPMA_selectTime(EEG, opt)
    arguments (Input)
        EEG struct
        opt.AfterStart (1,1) double
        opt.BeforeEnd (1,1) double
        opt.Save logical
        opt.SaveName string
    end
    
    %% Parsing arguments
    config = SPMA_loadConfig("preprocessing", "selectTime", opt);

    %% Logger
    log = SPMA_loggerSetUp("preprocessing");
    
    %% Removing channels
    log.info("Select time")

    % Check if the selected times are reasonable
    EEG_duration = EEG.xmax - EEG.xmin;

    if EEG_duration < config.AfterStart 
        log.error(sprintf("The recording is %.3fs, you cannot select %.3f seconds after the start.", EEG_duration, config.AfterStart))
    elseif EEG_duration - config.AfterStart < config.BeforeEnd
        log.error(sprintf("The recording is %.3fs, you requested %.3fs after start, you cannot select %.3f seconds before the end.", EEG_duration, config.AfterStart, config.BeforeEnd))
    end

    time_from = EEG.xmin + config.AfterStart;
    time_to = EEG.xmax - config.BeforeEnd;

    log.info(sprintf("Selected time [%.3f, %.3f] (%.3f after start, %.3f before end)", time_from, time_to, config.AfterStart, config.BeforeEnd))

    EEG = pop_select(EEG, 'time', [time_from, time_to]);

    %% Save
    if config.Save
        SPMA_saveData(EEG,config.saveName)
    end

end
