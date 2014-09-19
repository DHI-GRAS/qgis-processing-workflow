.NAME:Model development workflow
.GROUP:PG #09: Hydrological modelling
.ALGORITHM:wg9hm:1developswatmodelmdwf
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
This module launches the MWSWAT interface. In MWSWAT, you can perform DEM hydro-processing, HRU delineation and SWAT model parameterization

SETTINGS

No settings required
Press 'Run' to launch MapWindow.

FURTHER INFORMATION

In MapWindow, create a new MWSWAT project and complete the steps (1) Delineate watershed, (2) Create HRUs. 

For support regarding SWAT model development under MapWindow, please see the TIGER-NET training material and the WaterBase project, http://www.waterbase.org/docs/MWSWAT%20Setup.pdf.

For documentation of the SWAT model itself, see http://swat.tamu.edu 

!INSTRUCTIONS
.ALGORITHM:wg9hm:2generatemodeldescriptionandclimatefilesmdwf
.PARAMETERS:{"MODEL_STARTDATE": "20000101", "MODEL_FILE": "model.txt", "MODEL_SUBCOLUMN": "Subbasin", "MODEL_FCFILE": "ForecastDates.txt", "MODEL_TYPE": 0, "MODEL_PCPFAC": 1, "MODEL_NAME": ""}
.MODE:Normal
.INSTRUCTIONS:
This module creates the model description file and the climate file templates

SETTINGS

Storage location for model description file:
Specify a local directory where the model description file will be saved, e.g.: C:\WOIS\Kavango

Name of the model description file:
Specify a name for the model description file, e.g.: model.txt

Name of the model:
Specify a name for the model, e.g.: Kavango

Type of model:
Choose 'RT' if you intend to build an operational real-time model and 'Hist' if you intend to simulate historical periods or scenarios.

Starting date of the model:
Specify the model's starting date in the format YYYYMMDD.

Model sub-basin shapefile:
Choose the shapefile containing the model's sub-basins as created in MapWindow. This shapefile must have lat-lon pseudo-projection.

Name shapefile column holding sub IDs:
Specify the name of the column of the attribute table that contains the IDs of the sub-basins.

Storage location for the model climate station file:
Specify a local directory where the climate station file will be saved, e.g.: C:\WOIS\Kavango\Climate_stations

Name of the forecast dates file:
Specify a name for the forecast dates file, e.g.: ForecastDates.txt

Precipitation scaling factor:
Constant and uniform scaling factor multiplied on the precipitation product. A value of 1 means no scaling.

Model sub-basin centroid shapefile:
Choose the shape file containing the centroids of the model's sub-basins as created in MapWindow. This shapefile must have lat-lon pseudo-projection.

Name centroid file column holding Latitude:
Specify the name of the column of the centroid attribute table that contains Latitude of centroids.

Name centroid file column holding Longitude:
Specify the name of the column of the centroid attribute table that contains Longitude of centroids.

Name centroid file column holding Elevation:
Specify the name of the column of the centroid attribute table that contains mean elevation of sub-basins.

FURTHER INFORMATION

The model description file is a text file that contains all the necessary information to handle and manage the model in the WOIS.
In order to create the model description file, you need a shapefile with the model subcatchments in lat-lon pseudo-projection.
Use MapWindow to reproject from UTM to lat-lon. Indicate, which column of the attribute table holds the sub-basin IDs.
You also need a point shapefile with the subcatchment centroids (use MapWindow). The attribute table of the centroid file
should contain columns with latitude, longitude and elevation. To compute average elevation of the subcatchments,
use MapWindow's Grid Analysis Tools plugin ("Make statistics of grid by shapfile")
!INSTRUCTIONS
.ALGORITHM:wg9hm:3generatemodelclimatedatamdwf
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
This module generates the climate forcing data.

SETTINGS

Model description file:
Choose the model description file created in step 2.

Precipitation folder:
Choose the directory containing the precipitation product, e.g.: C:\WOIS\GFS_data\APCP

Maximum temperature folder:
Choose the directory containing the daily maximum temperature product, e.g.: C:\WOIS\GFS_data\TMAX

Minimum temperature folder:
Choose the directory containing the daily minimum temperature product, e.g.: C:\WOIS\GFS_data\TMIN

Resolution of subcatchment map:
Keep at 0.01 degrees, unless you work with very small sub-basins.

FURTHER INFORMATION

Climate forcing data are read from daily geotiff files and zonal means are computed for each subcatchment of the model. 
The resulting time series are stored in SWAT format. The climate folders containing daily geotiff files are supplied with the WOIS and
can be updated using OSFWF tools 1a-1c.
!INSTRUCTIONS
.ALGORITHM:wg9hm:4runswatmodelmdwf
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
This module runs the SWAT model

SETTINGS

Model description file:
Choose the model description file created in step 2.

Model input/output folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

SWAT executable:
Select the SWAT executable (.exe) that you want to run

Update Simulation period?
Select 'Yes', if you want to extend the simulation period, otherwise 'No'.

New end date of simulation period:
If you have selected 'Yes' above, specify the new end date of the simulation period in the format YYYYMMDD, otherwise leave blank.

FURTHER INFORMATION

After the climate files are generated in step 3, MapWindow needs to be launched again and the parameterization of the SWAT model needs to be completed.
The SWAT model can then be run from within MapWindow. This module provides a possibility to directly run an existing SWAT model from the WOIS,
without having to launch MapWindow.
!INSTRUCTIONS
.ALGORITHM:wg9hm:51sensitivityanalysisandcalibrationofswatmodelwithpestmdwfgeneratetemplatefiles
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Generation of PEST template files

SETTINGS

Select model source folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

Calibration parameter:
Select a SWAT parameter that you want to calibrate. If you want to calibrate more than one parameter, run this step repeatedly.

PEST name for calibration parameter:
Specify a name for the calibration parameter.

Subbasin ID for calibration parameter:
Specify in which sub-basin of the model the parameter should be calibrated. If the same calibration parameter applies to several sub-basins,
run this step repeatedly and use the same PEST parameter name.

HRU ID for calibration parameter:
Specify in which HRU of the sub-basin the parameter should be calibrated. If the same calibration parameter applies to several HRUs,
run this step repeatedly and use the same PEST parameter name.

Starting value of parameter:
Specify the starting value for the calibration parameter.

Lower bound of parameter:
Specify a lower bound for the calibration parameter.

Upper bound of parameter:
Specify an upper bound for the calibration parameter.

FURTHER INFORMATION

PEST is a generic model calibration tool. PEST template files tell PEST which model parameters are located in which model input files.
This routine supports the generation of draft PEST input files that use default options. PEST input files can subsequently be edited in a text editor
to refine specifications and adjust options.
For details, please consult the PEST manual (http://www.pesthomepage.org/Downloads.php)
!INSTRUCTIONS
.ALGORITHM:wg9hm:52sensitivityanalysisandcalibrationofswatmodelwithpestmdwfgenerateinstructionfiles
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Generation of PEST instruction files

SETTINGS

Select model source folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

Select model description file:
Choose the model description file created in step 2.

File with observation data:
Choose the file with observation data. This file must be in comma-separated ASCII format (.csv) and must have 4 columns:

Time (in EXCEL numeric format)

Observation (e.g. discharge in cubic meters per second)

Standard error of the observation

Reach ID of the model that corresponds to the location of the observation

PEST name of observation group:
Specify a name for the PEST observation group.

Temporal resolution of reach output and observation data:
Keep 'Daily', unless only monthly observation data is available.

FURTHER INFORMATION

PEST is a generic model calibration tool. PEST instruction files tell PEST where to find simulated observations.
This routine supports the generation of draft PEST input files that use default options. PEST input files can subsequently be edited in a text editor
to refine specifications and adjust options. 
For details, please consult the PEST manual (http://www.pesthomepage.org/Downloads.php)
!INSTRUCTIONS
.ALGORITHM:wg9hm:53sensitivityanalysisandcalibrationofswatmodelwithpestmdwfgenerateparametervariationfile
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Generation of SENSAN parameter variation file

SETTINGS

Select model source folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

Select source for parameter variation:
There are 3 optional files from which the initial parameter values used in the sensitivity analysis can be read:

1.) An existing PEST control file (.pst)
2.) Initial parameter values defined when running step 5.1 (.pbf)
3.) Optimal parameter values resulting from a completed PEST run (.par)

Select PEST control file:
If you have chosen option 1.) above, select the PEST control file here, otherwise leave blank.

Select PEST output parameter file:
If you have chosen option 3.) above, select the PEST output parameter file, otherwise leave blank.

Percent deviation in parameter values:
Define the parameter variation used in the local sensitivity analysis in percent.

FURTHER INFORMATION

The parameter variation file holds parameter sets to be tested in the sensitivity analysis.
Each parameter set will have one parameter deviate form the baseline parameter set.
This routine supports the generation of draft PEST input files that use default options. PEST input files can subsequently be edited in a text editor
to refine specifications and adjust options.  
For details on the SENSAN parameter variation file, please consult the PEST manual (http://www.pesthomepage.org/Downloads.php)
!INSTRUCTIONS
.ALGORITHM:wg9hm:54sensitivityanalysisandcalibrationofswatmodelwithpestmdwfgeneratesensancontrolfile
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Generation of SENSAN control file

SETTINGS

Select model description file:
Choose the model description file created in step 2.

Select model source folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

Parameter variation file:
Select parameter variation file created in step 5.3

SWAT executable:
Select the SWAT executable (.exe) that you want to use for the sensitivity analysis

FURTHER INFORMATION

The SENSAN control file is the master file managing SENSAN execution.
This routine supports the generation of draft PEST input files that use default options. PEST input files can subsequently be edited in a text editor
to refine specifications and adjust options. 
For details, please consult the PEST manual (http://www.pesthomepage.org/Downloads.php)
!INSTRUCTIONS
.ALGORITHM:wg9hm:55sensitivityanalysisandcalibrationofswatmodelwithpestmdwfrunsensan
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Run a local sensitivity analysis

SETTINGS

Select model source folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

Select SENSAN control file:
Select the SENSAN control file created in step 5.4

FURTHER INFORMATION

You are about to run SENSAN. SENSAN is a PEST utility for model sensitivity analysis. For details, please consult the PEST manual (http://www.pesthomepage.org/Downloads.php)
!INSTRUCTIONS
.ALGORITHM:wg9hm:56sensitivityanalysisandcalibrationofswatmodelwithpestmdwfsensanresults
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Output of sensitivity analysis 

SETTINGS

Select result folder:
Choose the directory containing the SWAT input/output files in ASCII format and the SENSAN files e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

Select SENSAN control file:
Select the SENSAN control file created in step 5.4

FURTHER INFORMATION

This module reads one of the SENSAN output files and computes the composite scaled sensitivity (CSS). 
For details on the SENSAN output files, please consult the PEST manual (http://www.pesthomepage.org/Downloads.php)
!INSTRUCTIONS
.ALGORITHM:wg9hm:57sensitivityanalysisandcalibrationofswatmodelwithpestmdwfgeneratepestcontrolfile
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Generation of the PEST control file

SETTINGS

Select model description file:
Choose the model description file created in step 2.

Select model source folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

PEST name of observation group:
Specify the name for the PEST observation group.

SWAT executable:
Select the SWAT executable (.exe) that you want to use for the calibration

FURTHER INFORMATION

PEST is a generic model calibration tool. The PEST control file is the master file managing PEST execution.
This routine supports the generation of draft PEST input files that use default options. PEST input files can subsequently be edited in a text editor
to refine specifications and adjust options. 
For details, please consult the PEST manual (http://www.pesthomepage.org/Downloads.php)
!INSTRUCTIONS
.ALGORITHM:wg9hm:58sensitivityanalysisandcalibrationofswatmodelwithpestmdwfrunpest
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Run PEST

SETTINGS

Calibration Algorithm:
PEST offers three different calibration algorithms:
1.) PEST: a local gradient-based search algorithms
2.) SCEUA_P: a global search algorithm (shuffled complex evolution)
3.) CMAES_P: an alternative global search algorithm 

Select model source folder:
Choose the directory containing the SWAT input/output files in ASCII format, and PEST input files, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

Select PEST control file:
Choose the PEST control file created in step 5.7

FURTHER INFORMATION

PEST is a generic model calibration tool. For details, please consult the PEST manual (http://www.pesthomepage.org/Downloads.php)
!INSTRUCTIONS
.ALGORITHM:wg9hm:6plotresultsmdwf
.PARAMETERS:{"SUB_ID": 1, "RES_TYPE": 0, "REACH_ID": 1, "HRU_ID": 1, "RES_VAR": 0}
.MODE:Normal
.INSTRUCTIONS:
Plotting SWAT output time series

SETTINGS

Select results folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

Temporal resolution:
Select daily, weekly or monthly output

Type of result:
Select the type of result that you want to plot. For instance, river discharge is a REACH output, while soil moisture is a HRU output.

Variable:
Select the SWAT variable that you want to plot. Most SWAT output variables of interest are supported.

Reach_ID:
Specify the reach for which to plot output.

Sub-basin ID:
Specify the sub-basin ID for which to plot output.

HRU ID:
Specify the HRU ID for which to plot output.

Select file with corresponding observations:
Choose an observation file (.csv) that contains observations corresponding to the simulated results. This is optional.


FURTHER INFORMATION

The user can choose between reach, sub-basin and HRU outputs. Some other output types are also supported.
The module also supports joint plotting of model results and in-situ observations.
!INSTRUCTIONS
