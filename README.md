# SuperPipelineMultiverseAnalysis
A modular pipeline for connectivity and network analysis of resting state EEG data

## Install

To install the software you need to use git (in the future there will be downloadable released versions).

If you don't have git on your computer, you can follow for example [this tutorial](https://github.com/git-guides/install-git).

Once you have git installed go in the folder where you want to install the toolbox and from the terminal run:

```bash
git clone --recurse-submodules https://github.com/SanCamillo-NeurophysiologyLab/SuperPipelineMultiverseAnalysis.git
```

It is very important to add `--recurse-submodules` to the command, since all the external dependencies are included as submodules!

## Pipeline structure
The pipeline is structured in 5 main modules:

1. Preprocessing
2. Head Model
3. Source Estimation
4. Connectivity Analysis
5. Network Analysis

Each module is composed of different steps (developed as matlab functions), each of them is highly customizable.
The goal is to have a pipeline with default steps to run coherent analysis over different sets of data. However, this tool wants just to provide a support for the analysis, therefore it will be automatized as much as possible, but keeping a human supervision on the critical point of the analysis.

## Dependencies
The pipeline is developed with `Matlab 2022b`.

Moreover it is built over different open source packages:

| Package   | Version  |
| ---       | ---      |
| [EEGLAB](https://github.com/sccn/eeglab) | 2024.2 |

The external dependencies are included as submodules in the folder `external`

## Code structure
The code is structured in a modular way, where each function can be used as it is, or combined with other functions to build up a complete pipeline.

The file `SuperPipeline.m` is just a template to build a pipeline. (let's see...)

The pipeline is defined with a json or yaml file. The structure of the file is the following:

#### Pipeline JSON

```json
{
	"step1": {
        "function": "SPMA_resample",
		"name": "downsampling",
        "save": true,
		"params": {
		    "Frequency": 250
        }
	},
	"step2.5": [
        {
		"function": "SPMA_filter",
        "name": "bandpass",
        "save": true,
		"params": {
            "Type": "bandpass",
            "LowCutoff": 0.5,
            "HighCutoff": 48
            }        
	    },
        {
		"function": "SPMA_filter",
        "name": "lowpass",
		"params": {
            "Type": "lowpass",
            "HighCutoff": 48
            }
	    }
    ],
    "step30": {
        "function": "SPMA_removeChannels",
        "params": {
            "Channels": ["E67","E73","E82","E91","E92","E102","E111","E120","E133","E145","E165","E174","E187","E199","E208","E209","E216","E217","E218","E219","E225","E226","E227","E228","E229","E230","E231","E232","E233","E234","E235","E236","E237","E238","E239","E240","E241","E242","E243","E244","E245","E246","E247","E248","E249","E250","E251","E252","E253","E254","E255","E256"]
        }
    },
    "step4": {
        "function": "SPMA_selectTime",
        "params": {
            "AfterStart": 5,
            "BeforeEnd": 5
        }
    },
    "step5": {
        "function": "SPMA_cleanData",
        "save": true,
        "params": {
            "Severity": "loose"
        }
    }
}
```

#### Pipeline YAML
```yaml
step1:
  function: SPMA_resample
  name: downsampling
  save: true
  params:
    Frequency: 250

step2:
  - function: SPMA_filter
    name: bandpass
    save: true
    params:
      Type: bandpass
      LowCutoff: 0.5
      HighCutoff: 48
  - function: SPMA_filter
    name: lowpass
    params:
      Type: lowpass
      HighCutoff: 48

step3:
  function: SPMA_removeChannels
  params:
    Channels: ["E67","E73","E82","E91","E92","E102","E111","E120","E133","E145","E165","E174","E187","E199","E208","E209","E216","E217","E218","E219","E225","E226","E227","E228","E229","E230","E231","E232","E233","E234","E235","E236","E237","E238","E239","E240","E241","E242","E243","E244","E245","E246","E247","E248","E249","E250","E251","E252","E253","E254","E255","E256"]

step4:
  function: SPMA_selectTime
  params:
    AfterStart: 5
    BeforeEnd: 5

step5:
  function: SPMA_cleanData
  save: true
  params:
    Severity: loose
```
The `functions` directory stores one subdirectory for each of the included modules. Each of the module-subdirectory contains all the functions that implement the developed steps.

All the functions have the prefix `SPMA_` in order to avoid conflicts with other Matlab packages.

### Functions - Misc
Here there are all the general functions not related to any specific module.

### Functions - 1_preprocessing
Here there are all the functions related to the preprocessing module.

### Functions - 2_head_model
Here there are all the functions related to the head modelling.

### Functions - 3_source_estimation
Here there are all the functions related to the source estimation.

### Functions - 4_connectivity
Here there are all the functions related to the connectivity analysis.

### Functions - 5_network
Here there are all the functions related to the network analysis.

## Settings

The code is supposed to work out of the box using default parameters, however no parameter is hardcoded but all of them are stored in `functions/0_misc/SPMA_defaultConfig`.

The internal structure of the parameters is a matlab nested struct where the first level is the name of the module, the second the name of the function , and finally the name of the parameter. The full list of default configurations is listed in the following table:

| Module        | Function      | Parameter     | Value |
| ---           | ---           | ---           | ---   |
| general       | -             | customConfigFileName | SPMA_config |
| preprocessing | resample      | Frequency     | 250   |
| preprocessing | resample      | Save          | false   |
| preprocessing | filter        | Type          | bandpass   |
| preprocessing | filter        | LowCutoff     | 0.5   |
| preprocessing | filter        | HighCutoff    | 48   |
| preprocessing | filter        | Save          | false   |


