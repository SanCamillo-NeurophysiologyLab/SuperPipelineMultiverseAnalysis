% SPMA_CLEANDATA - Automatic data cleaning removing bad channels.
%
% Usage:
%     >> [EEG] = SPMA_cleanData(EEG)
%     >> [EEG] = SPMA_cleanData(EEG, 'key', val) 
%     >> [EEG] = SPMA_cleanData(EEG, key=val) 
%
% Inputs:
%    EEG        = [struct] EEG struct using EEGLAB structure system
%
% Optional inputs
%    Severity  = [string] Severity of the paraemters to clean data.
%               Available values are "loose" or "strict".
%    SaveExcludedChannels = [logical] Whether to save or not the list of
%               excluded channels.
%
% Outputs:
%    EEG = [struct] EEG struct using EEGLAB structure system
%
% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024
% 
% See also: EEGLAB, POP_SELECT

function [EEG] = SPMA_cleanData(EEG, opt)
    arguments (Input)
        EEG struct
        % Optional
        opt.Severity string {mustBeMember(opt.Severity, ["loose", "strict"])}
        opt.SaveExcludedChannels logical
        opt.EEGLAB (1,:) cell
        % Save options
        opt.Save logical
        opt.SaveName string
        opt.OutputFolder string
        % Log options
        opt.LogEnabled logical
        opt.LogLevel double {mustBeInteger,mustBeInRange(opt.LogLevel,0,6)}
        opt.LogToFile logical
        opt.LogFileDir string
        opt.LogFileName string
    end

    %% Constants
    module = "preprocessing";
    
    %% Parsing arguments
    config = SPMA_loadConfig(module, "cleanData", opt);

    %% Logger
    logConfig = SPMA_loadConfig(module, "logging", opt);
    log = SPMA_loggerSetUp(module, logConfig);
    
    %% Cleaning data
    log.info(sprintf("Cleaning data with %s parameters", config.Severity))

    switch config.Severity
        case "loose"
            flatlineCrit = 5;
            channelCrit = 0.8;
            lineNoiseCrit = 4;
            highpass = 'off';
            burstCrit = 'off';
            windowCrit = 0.25;
            burstRejection = 'off';
            distance = 'Euclidian';
            windowCritTol = [-Inf 50]; 
            
        case "strict"
            flatlineCrit = 5;
            channelCrit = 0.8;
            lineNoiseCrit = 4;
            highpass = 'off';
            burstCrit = 20;
            windowCrit = 0.25;
            burstRejection = 'on';
            distance = 'Euclidian';
            windowCritTol = [-Inf 7]; 

        otherwise
            error("Available types are only 'loose' and 'strict'. %s not available.", config.Severity)
    end

    chans_before = {EEG.chanlocs.labels};

    EEG = pop_clean_rawdata(EEG, ...
        'FlatlineCriterion',flatlineCrit,...
        'ChannelCriterion',channelCrit, ...
        'LineNoiseCriterion',lineNoiseCrit, ...
        'Highpass',highpass, ...
        'BurstCriterion',burstCrit, ...
        'WindowCriterion',windowCrit, ...
        'BurstRejection',burstRejection, ...
        'Distance',distance, ...
        'WindowCriterionTolerances',windowCritTol, ...
        config.EEGLAB{:});
    
    chans_after = {EEG.chanlocs.labels};
    chans_excluded = setdiff(chans_before, chans_after);

    log.info("Excluded channels: " + strjoin(chans_excluded))
    if config.SaveExcludedChannels
        nameChansExcluded = sprintf("%s_%s",config.SaveName, "ExcludedChannels");
        log.info(sprintf("Saving excluded channels in %s", nameChansExcluded));

        logParams = unpackStruct(logConfig);

        SPMA_saveData(chans_excluded, "Name",nameChansExcluded, "Folder", module, "OutputFolder",config.OutputFolder, logParams{:});
        writematrix([preproc_path, out_subj_path, curr_subj_name, '_clean_bad_channels.txt'], EEG_chans_7_excluded);
    end


    %% Save
    if config.Save
        logParams = unpackStruct(logConfig);
        SPMA_saveData(EEG, "Name", config.SaveName, "Folder", module, "OutputFolder", config.OutputFolder, logParams{:});
    end

end

