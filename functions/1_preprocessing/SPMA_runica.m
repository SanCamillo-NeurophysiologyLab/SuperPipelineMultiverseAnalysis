function [EEG] = SPMA_runica(EEG, opt)
% SPMA_RUNICA - Perform ICA decomposition with Infomax ICA algorithm.
%
% Examples:
%     >>> [EEG] = SPMA_runica(EEG)
%     >>> [EEG] = SPMA_runica(EEG, 'key', val) 
%     >>> [EEG] = SPMA_runica(EEG, key=val) 
%
% Parameters:
%    EEG (struct): EEG struct using EEGLAB structure system
%
% Other Parameters:
%    Extended (integer): perform TANH "extended-ICA" with sign estimation
%               N training blocks
%    Interrupt (logical): draw interrupt figure
%    SaveBefore (logical): save data before running ICA
%    SaveBeforeName (string): name of saved data before running ICA
%
% Returns:
%    EEG (struct): EEG struct using EEGLAB structure system
% 
% See also:
%    EEGLAB, POP_RUNICA, RUNICA

% Authors: Alessandro Tonin, IRCCS San Camillo Hospital, 2024

    arguments (Input)
        EEG struct
        % Optional
        opt.Extended double {mustBeInteger}
        opt.Interrupt logical
        opt.EEGLAB (1,:) cell
        opt.SaveBefore logical
        opt.SaveNameBefore string
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
    config = SPMA_loadConfig(module, "runica", opt);

    %% Logger
    logConfig = SPMA_loadConfig(module, "logging", opt);
    log = SPMA_loggerSetUp(module, logConfig);
    
    %% Save ICA
    if config.SaveBefore
        log.info("Saving data before ICA")
        SPMA_saveData(EEG,config.saveNameBefore)
    end

    %% Run ICA
    log.info(sprintf("Starting ICA with runICA algorithm, with Extended value %d", config.Extended))

    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',config.Extended,'interrupt', bool2onoff(config.Interrupt), config.EEGLAB{:}); 

    %% Save
    if config.Save
        logParams = unpackStruct(logConfig);
        SPMA_saveData(EEG, "Name", config.SaveName, "Folder", module, "OutputFolder", config.OutputFolder, logParams{:});
    end

end

