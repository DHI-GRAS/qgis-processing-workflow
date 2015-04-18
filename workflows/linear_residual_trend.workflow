.NAME:Vegetation trend analysis (with rainfall control)
.GROUP:PG #03: Medium resolution land degradation index
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": false, "filenameFormat": "", "operation": 10, "outputFileFormat": "", "groupBy": 0}
.MODE:Normal
.INSTRUCTIONS:Compile a monthly rainfall time series from daily rainfall data.

SETTINGS

An image file located in the data directory:
Select one of the rainfall files in the folder you want to process.

Input images filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., RFE_20110523.tif becomes RFE_YYYYMMDD.tif).

Output directory:
Define the path and folder where you want to save the processed data, e.g., C:\WOIS\PG03\Month_RFE

Output images filename:
Define an output filename using YMD for the date string position, e.g., Month_RFE_YMD.tif.

Aggregation condition:
year-month

Propagate NULLs:
If set to No, zero values won't be propagated.

Aggregate operation:
If set to maximum it will save the maximum value for each pixel.

Region extent:
Spatial subsetting of the image can be done by using Region extent.Choose the same extent as the NDVI files which will be used as the dependant variable in step 7.

Other settings:
Leave the default values.
!INSTRUCTIONS
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": false, "filenameFormat": "", "operation": 0, "outputFileFormat": "", "groupBy": 4}
.MODE:Normal
.INSTRUCTIONS:Calculation of long-term mean rainfall for each month.

SETTINGS

An image file located in the data directory:
Select one of the monthly RFE files in the folder you
produced in step 1.

Input images filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., RFE_20110523.tif becomes RFE_YYYYMMDD.tif).

Output directory:
Define the path and folder where you want to save the processed data, e.g., C:\WOIS\PG03\LT_mean_RFE

Output images filename:
Define an output filename using YMD for the date string position, e.g., LT_mean_RFE_YMD.tif.

Aggregation condition:
Set to month, to calculate long-term mean NDVI for each month. For instance you will get one image with the mean NDVI for all Januaries in your time series.

Propagate NULLs:
If set to No, zero values won't be propagated.

Aggregate operation:
If set to average, it will save the mean value for each pixel.

Region extent:
Spatial subsetting of the image can be done by using Region extent. Leave it blank if you do not want to change the extent.

Other settings:
Leave the default values.
!INSTRUCTIONS
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": false, "filenameFormat": "", "operation": 8, "outputFileFormat": "", "groupBy": 4}
.MODE:Normal
.INSTRUCTIONS:Calculation of long-term standard deviation of RFE for each month.

SETTINGS

An image file located in the data directory:
Select one of the interpolated monthly maximum RFE files in the folder you
produced in step 2.

Input images filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., RFE_20110523.tif becomes RFE_YYYYMMDD.tif).

Output directory:
Define the path and folder where you want to save the processed data, e.g., C:\WOIS\PG03\LT_stdev_RFE

Output images filename:
Define an output filename using YMD for the date string position, e.g., LT_stdev_RFE_YMD.tif.

Aggregation condition:
Set to month, to calculate long-term standard deviation NDVI for each month. For instance you will get one image with the standard deviation of NDVI for all Januaries in your time series.

Propagate NULLs:
If set to No, zero values won't be propagated.

Aggregate operation:
If set to stddev, it will save the standard deviation value for each pixel.

Region extent:
Spatial subsetting of the image can be done by using Region extent. Leave it blank if you do not want to change the extent.

Other settings:
Leave the default values.
!INSTRUCTIONS
.ALGORITHM:script:otbbandmathfortemporaldata
.PARAMETERS:{"filenameFormat1": "", "expression": "(im1b1-im2b1)/im3b1", "ram": 128, "outputFileFormat": "", "groupBy": 4, "filenameFormat3": "", "filenameFormat2": ""}
.MODE:Normal
.INSTRUCTIONS:Calculation of standardized RFE anomalies for each month of the time series.

SETTINGS

im1:
Select one of the monthly rainfall images calculated in step 1.

im1 filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., for Month_RFE_201105.tif type Month_RFE_YYYYMM.tif).

im2:
Select one of the long-term mean rainfall images calculated in step 2.

im2 filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., for LT_mean_RFE_01 type
LT_mean_RFE_MM.tif).

im3:
Select one of the long-term standard deviation rainfall images calculated in step 4.

im3 filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., for
LT_stdev_RFE_01.tif type LT_stdev_RFE_MM.tif).

Output directory:
Define the path and folder where you want to save the processed data, e.g., C:\WOIS\PG03\Norm_RFE

Output images filename:
Define an output filename using YMD for the date string position, e.g., Norm_RFE_YMD.tif.

Pair images by:
month

Band math expression:
With the following expression you normalise the rainfall by subtracting the long-term mean from the monthly maximum data and dividing them by the long-term standard deviation: (im1b1-im2b1)/im3b1
!INSTRUCTIONS
.ALGORITHM:script:timeseriesresidual
.PARAMETERS:{"outputFileFormat": "", "filenameFormat1": "", "filenameFormat2": ""}
.MODE:Normal
.INSTRUCTIONS:Calculation of standardized NDVI residuals  (dependent variable) on rainfall (independent variable).

Before continuing with the analysis, inspect the normalised NDVI images and define roughly the growth season. Usually, fresh green vegetation has high NDVI values, whereas dry land has values close to 0. In this step, use only NDVI data of the months within the growth season. This is in particular important for regions with very distinct dry and wet seasons.

Copy all the growth season NDVI images in a separate folder and use this folder for the following steps.

SETTINGS

im1 - An image file located in the time series 2 (independent variable) data directory:
Select one of the normalized Rainfall files in the folder with data of the growth season (see comments above).

im1 filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., Norm_Rain_201101.tif becomes Norm_Rain_YMD.tif).

im2 - An image file located in the time series 2 (dependent variable) data directory:
Select one of the normalized NDVI files in the folder with data of the growth season (see comments above).

im2 filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., Norm_NDVI_201101.tif becomes Norm_NDVI_YMD.tif).

Output directory:
Define the path and folder where you want to save the processed data, e.g., C:\WOIS\PG03\

Output images filename:
Define an output filename, e.g., Residual_NDVI_YYYYMM.tif
!INSTRUCTIONS
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": false, "filenameFormat": "", "operation": 13, "outputFileFormat": "", "groupBy": 7}
.MODE:Normal
.INSTRUCTIONS:Calculation of linear slopes by regressing residual NDVI anomalies (dependent variable) on time (independent variable).

SETTINGS

An image file located in the data directory:
Select one of the residual NDVI files computed in the previous step.

Input images filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., Residual_NDVI_201101.tif becomes Residual_NDVI_YYYYMM.tif).

Output directory:
Define the path and folder where you want to save the processed data, e.g., C:\WOIS\PG03\

Output images filename:
Define an output filename, e.g., slope.tif.
(there is no need to use YMD in the Output images filename, as there will be only one output file).

Aggregation condition:
Set to format (then the algorithm will take all images with the same format, such as .tif, into account).

Propagate NULLs:
No

Aggregate operation:
Set to slope, to calculate the slope of the trendline.

Other settings:
Leave the default values.
!INSTRUCTIONS
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": false, "filenameFormat": "", "operation": 15, "outputFileFormat": "", "groupBy": 7}
.MODE:Normal
.INSTRUCTIONS:Calculation of pixelwise coefficient of determination (R2) between the residual NDVI anomalies and time to assess statistical significance of the slopes calculated in the previous step.

SETTINGS

An image file located in the data directory:
Select one of the residual NDVI files in the folder with data of the growth season (see comments above).

Input images filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., for residual_NDVI_201101.tif type residual_NDVI_YMD.tif).

Output directory:
Define the path and folder where you want to save the processed data, e.g., C:\WOIS\PG03\

Output images filename:
Define an output filename, e.g., coeff_det.tif.
(there is no need to use YMD in the Output images filename, as there will be only one output file).

Aggregation condition:
Set to format (then the algorithm will take all images with the same format, such as .tif, into account).

Aggregate operation:
Set to detcoeff to compute the coefficient of determination (R2).

Other settings:
Leave the default values.
!INSTRUCTIONS
