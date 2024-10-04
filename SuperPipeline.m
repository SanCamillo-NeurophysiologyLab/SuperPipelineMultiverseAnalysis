%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Super Pipeline Multiverse Analysis %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is the main script for the multiverse analysis of EEG resting state.
% The script can be used as-is or can be used as template/example for
% developing personalized scripts.
% The pipeline is developed for internal use of IRCCS San Camillo Hospital,
% but the project is open to contributions.
%
% Organization: IRCCS San Camillo Hospital (Venice, Italy)
% 
% Authors:  Giorgio Arcara
%           Sara Lago
%           Ettore Napoli
%           Silvia Saccani
%           Alessandro Tonin
%
% License: GPLv3
%
% Last update: 29.05.2024

%% Add internal functions to path
%%% Uncomment this if you run the whole file
% folder = fileparts(which(mfilename));
% functions_folder = fullfile(folder, "functions");
%%% uncomment this if you run the code line by line
functions_folder = "functions";

addpath(genpath(functions_folder));

%% Add external dependencies to path
SPMA_loadDependencies();

%% Variables
data_path = '/mnt/raid/atonin/SuperPipelineMultiverseAnalysis/data/ses-20191120/EEG_ORIG/PATHS_101_Resting_20191120_022103.mff';
pipeline = "pipeline.json";
% pipeline = "pipeline_test.json";

%% Import
EEG = pop_mffimport({data_path},'',0,0);
data_test = '';

%% Run pipeline
data = SPMA_runPipeline(pipeline, EEG);
% data = SPMA_runPipeline(pipeline, data_test);
