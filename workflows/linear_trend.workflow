.NAME:Vegetation trend analysis
.GROUP:PG #03: Medium resolution land degradation index
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": false, "filenameFormat": "", "operation": 6, "outputFileFormat": "", "groupBy": 0}
.MODE:Normal
.INSTRUCTIONS:Compile a monthly maximum NDVI time series from 10-day NDVI data.

SETTINGS

An image file located in the data directory:
Select one of the NDVI files in the folder you want to process.

Input images filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., NDVI_20110523.tif becomes NDVI_YYYYMMDD.tif).

Output directory:
Define the path and folder where you want to save the processed data, e.g., C:\WOIS\PG03\MonthMax_NDVI

Output images filename:
Define an output filename using YMD for the date string position, e.g., MonthMax_NDVI_YMD.tif.

Aggregation condition:
year-month

Propagate NULLs:
If set to No, zero values won't be propagated.

Aggregate operation:
If set to maximum it will save the maximum value for each pixel.

Region extent:
Spatial subsetting of the image can be done by using Region extent. Leave it blank if you do not want to change the extent.

Other settings:
Leave the default values.
!INSTRUCTIONS
.ALGORITHM:script:rfillnullsfordirectory
.PARAMETERS:{"tension": 40, "smooth": 0.1, "method": 1, "cellSize": 0}
.MODE:Normal
.INSTRUCTIONS:Spatial interpolation of missing data (for instance owing to cloud coverage).

SETTINGS

An image in the input directory:
Select a file from the directory where the monthly maximum NDVI images of step 1 were saved.

Method:
Choose the bilinear or bicubic interpolation method. Bilinear takes 4 (2x2) pixels and bicubic 16 (4x4) pixels into account. The result of the latter is smoother but also more time demanding.
(The Spline tension and smoothig parameters are not used with the bilinear or bicubic algorithm).

Output directory:
Define the path and folder where you want to save the processed data, e.g., C:\WOIS\PG03\MonthMax_NDVI\interpolated
If there are no missing data  in an NDVI image, it will not be processed. Therefore, it is recommended to overwrite the input files and leave the Region extent unchanged. Before you start processing, make a copy of your data.

Region extent:
Spatial subsetting of the image can be done by using Region extent. Leave it blank if you do not want to change the extent.

Other settings:
Leave the default values.

FURTHER INFORMATION

This step can take quite some processing time, all depending how large your data are.
!INSTRUCTIONS
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": false, "filenameFormat": "", "operation": 0, "outputFileFormat": "", "groupBy": 3}
.MODE:Normal
.INSTRUCTIONS:Calculation of long-term mean NDVI for each month.

SETTINGS

An image file located in the data directory:
Select one of the interpolated monthly maximum NDVI files in the folder you
produced in step 2.

Input images filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., NDVI_20110523.tif becomes NDVI_YYYYMMDD.tif).

Output directory:
Define the path and folder where you want to save the processed data, e.g., C:\WOIS\PG03\LT_mean_NDVI

Output images filename:
Define an output filename using YMD for the date string position, e.g., LT_mean_NDVI_YMD.tif.

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
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": false, "filenameFormat": "", "operation": 8, "outputFileFormat": "", "groupBy": 3}
.MODE:Normal
.INSTRUCTIONS:Calculation of long-term standard deviation of NDVI for each month.

SETTINGS

An image file located in the data directory:
Select one of the interpolated monthly maximum NDVI files in the folder you
produced in step 2.

Input images filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., NDVI_20110523.tif becomes NDVI_YYYYMMDD.tif).

Output directory:
Define the path and folder where you want to save the processed data, e.g., C:\WOIS\PG03\LT_stdev_NDVI

Output images filename:
Define an output filename using YMD for the date string position, e.g., LT_stdev_NDVI_YMD.tif.

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
.PARAMETERS:{"filenameFormat1": "", "expression": "(im1b1-im2b1)/im3b1", "ram": 128, "outputFileFormat": "", "groupBy": 3, "filenameFormat3": "", "filenameFormat2": ""}
.MODE:Normal
.INSTRUCTIONS:Calculation of standardized NDVI anomalies for each month of the time series.

SETTINGS

im1:
Select one of the interpolated monthly maximum NDVI images calculated in step 2.

im1 filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., for MonthMax_NDVI_201105.tif type MonthMax_NDVI_YYYYMM.tif).

im2:
Select one of the long-term mean NDVI images calculated in step 3.

im2 filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., for LT_mean_NDVI_01 type
LT_mean_NDVI_MM.tif).

im3:
Select one of the long-term standard deviation NDVI images calculated in step 4.

im3 filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., for
LT_stdev_NDVI_01.tif type LT_stdev_NDVI_MM.tif).

Output directory:
Define the path and folder where you want to save the processed data, e.g., C:\WOIS\PG03\Norm_NDVI

Output images filename:
Define an output filename using YMD for the date string position, e.g., Norm_NDVI_YMD.tif.

Pair images by:
month

Band math expression:
With the following expression you normalise the NDVI by subtracting the long-term mean from the monthly maximum data and dividing them by the long-term standard deviation: (im1b1-im2b1)/im3b1
!INSTRUCTIONS
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": false, "filenameFormat": "", "operation": 13, "outputFileFormat": "", "groupBy": 6}
.MODE:Normal
.INSTRUCTIONS:Calculation of linear slopes by regressing standardized NDVI anomalies (dependent variable) on time (independent variable).

Before continuing with the analysis, inspect the normalised NDVI images and define roughly the growth season. Usually, fresh green vegetation has high NDVI values, whereas dry land has values close to 0. In this step, use only NDVI data of the months within the growth season. This is in particular important for regions with very distinct dry and wet seasons.

Copy all the growth season NDVI images in a separate folder and use this folder for the following steps.

SETTINGS

An image file located in the data directory:
Select one of the normalized NDVI files in the folder with data of the growth season (see comments above).

Input images filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., Norm_NDVI_201101.tif becomes Norm_NDVI_YYYYMM.tif).

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
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": false, "filenameFormat": "", "operation": 15, "outputFileFormat": "", "groupBy": 6}
.MODE:Normal
.INSTRUCTIONS:Calculation of pixelwise coefficient of determination (R2) between the standardized NDVI anomalies and time to assess statistical significance of the slopes calculated in the previous step.

SETTINGS

An image file located in the data directory:
Select one of the normalized NDVI files in the folder with data of the growth season (see comments above).

Input images filename:
Retype the input image filename incl. file extension and by replacing the date string with Y,M,D (e.g., for Norm_NDVI_201101.tif type Norm_NDVI_YYYYMM.tif).

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
