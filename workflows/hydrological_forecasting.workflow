.NAME:Operational simulation and forecasting workflow
.GROUP:PG #09: Hydrological modelling
.ALGORITHM:wg9hm:11getnewnoaagfsdataosfwf
.PARAMETERS:{"TOP_LAT": 40, "RIGHT_LONG": 55, "LEFT_LONG": -20, "BOTTOM_LAT": -40}
.MODE:Normal
.INSTRUCTIONS:
Update NOAA-GFS climate forcing data.

SETTINGS

Select precipitation folder:
Choose the folder containing the NOAA-GFS precipitation product, e.g.: c:\WOIS\GFS_data\APCP

Select maximum temperature folder:
Choose the folder containing the NOAA-GFS daily maximum temperature product, e.g.: c:\WOIS\GFS_data\TMAX

Select minimum temperature folder:
Choose the folder containing the NOAA-GFS daily minimum temperature product, e.g.: c:\WOIS\GFS_data\TMIN

Other settings:
You can specify a geographic sub-area. If you leave the defaults (recommended), data for all of Africa will be downloaded.

FURTHER INFORMATION

The module connects to the internet and downloads the latest available precipitation and temperature data from http://nomads.ncep.noaa.gov/.
Daily precipitation, minimum and maximum temperature are computed and stored as geotiff files in the folders specified by the user. 
The user can change the default geographical area (which is set to include all of Africa) by changing the advanced parameters.

After running this module, the folders will contain forecasted climate forcing data to present plus 8 days and 1-day-ahead forecasts
for the historical period.
!INSTRUCTIONS
.ALGORITHM:wg9hm:12getfewsrfedataosfwf
.PARAMETERS:{"START_DATE": "20130101", "END_DATE": "20130218"}
.MODE:Normal
.INSTRUCTIONS:
Update FEWS-RFE precipitation data.

SETTINGS

Select precipitation folder:
Choose the folder containing the FEWS-RFE precipitation product, e.g.: c:\WOIS\FEWS_RFE

Start date:
Starting date of the download period in the format YYYYMMDD. Must be later than Jan 1st, 2001.

End date:
End date of the download period in the format YYYYMMDD.

FURTHER INFORMATION

The module connects to the internet and downloads the latest available precipitation data from 
http://earlywarning.usgs.gov/fews/africa/web/imgbrowsc2.php?extent=afp6. 
Daily precipitation is stored as geotiff files in the folder specified by the user. The user can adjust the period for which data should be downloaded.

After running this module, the precipitation folder will contain data for the requested period, unless the dataset in the online archive ends earlier.
Typically, FEWS-RFE is available with a real-time delay of a few days. No forecasted precipitation is available from FEWS-RFE.
!INSTRUCTIONS
.ALGORITHM:wg9hm:13getecmwfdataosfwf
.PARAMETERS:{"RIGHT_LONG": 55, "LEFT_LONG": -20, "END_DATE": "20120601", "EMAIL": "", "TOP_LAT": 40, "TOKEN": "", "START_DATE": "20120101", "BOTTOM_LAT": -40}
.MODE:Normal
.INSTRUCTIONS:
Update ECMWF ERA-Interim temperature data.

SETTINGS

Select maximum temperature folder:
Choose the folder containing the ERA-Interim daily maximum temperature product, e.g.: c:\WOIS\ECMWF\TMAX

Select minimum temperature folder:
Choose the folder containing the ERA-Interim daily minimum temperature product, e.g.: c:\WOIS\ECMWF\TMIN

Start date:
Starting date of the download period in the format YYYYMMDD. Must be later than Jan 1st, 1979.

End date:
End date of the download period in the format YYYYMMDD. Do not download more than 6 month worth of data at the time.

Email:
Email address of registered ECMWF user account. Please register your email address at ECMWF and obtain a token. Use this page https://apps.ecmwf.int/registration/ and follow any instructions given by ECMWF. 

Token:
ECMWF authorization code for registered user account.

Other settings:
You can specify a geographic sub-area. If you leave the defaults (recommended), data for all of Africa will be downloaded.

FURTHER INFORMATION

The module connects to the internet and downloads the latest available temperature data from http://data-portal.ecmwf.int/data/d/interim_full_daily/. 
Daily minimum and maximum temperature is computed and is stored as geotiff files in the folders specified by the user. 
The user can adjust the period for which data should be downloaded.

After running this module, the temperature folders will contain data for the requested period, unless the dataset in the online archive ends earlier.
Typically, ECMWF ERA-Interim data is available with a real-time delay of a few months. No forecasts are available from ECMWF ERA-Interim.
!INSTRUCTIONS
.ALGORITHM:wg9hm:2updatemodelclimatedataosfwf
.PARAMETERS:{"SUBCATCH_RES": 0.01}
.MODE:Normal
.INSTRUCTIONS:
Update SWAT climate input files

SETTINGS

Model description file:
Choose the model description file created in step 2 of the model development workflow.

Precipitation folder:
Choose the directory containing the precipitation product, e.g.: C:\WOIS\GFS_data\APCP

Maximum temperature folder:
Choose the directory containing the daily maximum temperature product, e.g.: C:\WOIS\GFS_data\TMAX

Minimum temperature folder:
Choose the directory containing the daily minimum temperature product, e.g.: C:\WOIS\GFS_data\TMIN

Resolution of subcatchment map:
Keep at 0.01 degrees, unless you work with very small sub-basins.

FURTHER INFORMATION

This module computes zonal means of the climate forcing data for each subcatchment and stores the resulting time series in SWAT format.
The module requires a model description file as input. This file can be generated in step 2 of the MDWF.
The pixel resolution of the subcatchment map should be sufficient to resolve the smallest subcatchment in the model.
!INSTRUCTIONS
.ALGORITHM:wg9hm:3runswatmodelosfwf
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Run SWAT to forecast horizon

SETTINGS

Select model description file:
Choose the model description file created in step 2 of the model development workflow.

Select model source folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

SWAT executable:
Select the SWAT executable (.exe) that you want to use for the simulation.

FURTHER INFORMATION

This module runs the SWAT model to the forecasting time. 
Simulation timing is updated in the SWAT input files and the simulation is run to the forecasting date.
!INSTRUCTIONS
.ALGORITHM:wg9hm:41assimilateobservationsosfwfprepareinputdata
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Create assimilation input files

SETTINGS

Select model source folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

Select model description file:
Choose the model description file created in step 2 of the model development workflow.

Select assimilation folder:
Select a local directory where assimilation files and results will be stored, e.g.: C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut\Assimilation

FURTHER INFORMATION

The WOIS assimilation module assimilates in-situ discharge observations and issues updated forecasts along with forecast uncertainties.
Runoff from each subcatchment is read from SWAT output files. A simple Muskingum routing model is established, based on available channel cross-sectional information. 
An autocorrelated lag-1 model is parameterised that represents the model error of the SWAT model. A Kalman filter routine is run to produce the best estimate of discharge in real time and forecast discharge 8 days ahead

!INSTRUCTIONS
.ALGORITHM:wg9hm:42assimilateobservationsosfwffiterrormodel
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Fit error model

SETTINGS

Select model source folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

Select model description file:
Choose the model description file created in step 2 of the model development workflow.

Select assimilation folder:
Select a local directory where assimilation files and results will be stored, e.g.: C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut\Assimilation

File with observation data:
Choose an observation file that contains the observations to be assimilated. This file must be in comma-separated ASCII format (.csv) and must have 4 columns:

Time (in EXCEL numeric format)

Observation (e.g. discharge in cubic meters per second)

Standard error of the observation

Reach ID of the model that corresponds to the location of the observation

FURTHER INFORMATION

In this step an autocorrelated lag-1 model is parameterised and fitted to the simulated discharge, representing the model error of the SWAT model.
The fitted error model parameters can be found in the ErrorModelReachX.txt file with X being the reach IDs specified in the file with observation data.
!INSTRUCTIONS
.ALGORITHM:wg9hm:43assimilateobservationsosfwfupdateassimilationfile
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Error parameterization

SETTINGS

Replace with global parameters:
If you choose 'Yes' the error parameters fitted in step 4.2 will be used for all reaches.
If you choose 'No' nothing will be done. In this case you have to manually edit the file 'Assimilation.txt' and specify individual error parameters for each reach.

Select model description file:
Choose the model description file created in step 2 of the model development workflow.

Select assimilation folder:
Select a local directory where assimilation files and results will be stored, e.g.: C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut\Assimilation

File with observation data:
Choose an observation file that contains the observations to be assimilated. 

FURTHER INFORMATION

Do not forget to manually edit the file 'Assimilation.txt' if you choose 'No'. Doing nothing will cause the assimilation to fail as default values for the error model parameters are set to -99.0.
!INSTRUCTIONS
.ALGORITHM:wg9hm:44assimilateobservationsosfwfrunassimilation
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:
Run assimilation

SETTINGS

Select model source folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

Select model description file:
Choose the model description file created in step 2 of the model development workflow.

Select assimilation folder:
Select a local directory where assimilation files and results will be stored, e.g.: C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut\Assimilation

Issue date:
Specify the issue date of the forecast in the format yyyy-mm-dd. The default is today's date.

File with observation data:
Choose an observation file that contains the observations to be assimilated. 

FURTHER INFORMATION

The WOIS assimilation module assimilates in-situ discharge observations and issues updated forecasts along with forecast uncertainties.
Runoff from each subcatchment is read from SWAT output files. A simple Muskingum routing model is established, based on available channel cross-sectional information. 
An autocorrelated lag-1 model is parameterised that represents the model error of the SWAT model. A Kalman filter routine is run to produce the best estimate of discharge in real time and forecast discharge 8 days ahead

!INSTRUCTIONS
.ALGORITHM:wg9hm:5plotresultsosfwf
.PARAMETERS:{"SUB_ID": 1, "RES_TYPE": 0, "REACH_ID": 1, "HRU_ID": 1, "RES_VAR": 0}
.MODE:Normal
.INSTRUCTIONS:
Plot assimilation and forecasting results

SETTINGS

Select assimilation folder:
Select a local directory where assimilation files and results will be stored, e.g.: C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut\Assimilation

Select model source folder:
Choose the directory containing the SWAT input/output files in ASCII format, e.g.:
C:\WOIS\Kavango\SWAT_model\Scenarios\Default\TxtInOut

Issue date:
Specify the issue date of the forecast in the format yyyy-mm-dd. The default is today's date.

Select file with corresponding observations:
Choose an observation file (.csv) that contains observations corresponding to the simulated results. This is optional.

Reach_ID:
Specify the reach for which to plot output.

FURTHER INFORMATION

This step will produce graphics with assimilation and forecasting results.

!INSTRUCTIONS
