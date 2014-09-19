.NAME:Seasonal monitoring of landscape dynamics
.GROUP:PG #04: Medium resolution full basin characterization
.ALGORITHM:script:rfillnullsfordirectory
.PARAMETERS:{"tension": 40, "smooth": 0.1, "method": 0, "cellSize": 0}
.MODE:Normal
.INSTRUCTIONS:This step performs spatial interpolation of missing data in a data timeseries (for instance owing to cloud coverage).

SETTINGS

An image in the input directory:
Select a file from the directory where the time series of 10-day biophysical images are saved to spatially interpolate over any missing data.

Output directory:
Select the output directory 
(note: If there are no missing data in an image it will not be processed. Therefore, it is best to overwrite the input files i.e. set the output directory to be the same as the input directory) 

Other settings: 
Leave the default values.

!INSTRUCTIONS
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": true, "filenameFormat": "", "operation": 0, "outputFileFormat": "", "groupBy": 0}
.MODE:Normal
.INSTRUCTIONS:This step computes the per-pixel mean values for an image time series - in this case the long-term mean biophysical value (e.g., FAPAR, LAI, FCover) for each 10-day period.

SETTINGS

An image in the input directory:
Select the directory with the 10-day biophysical time series. Retype the image file name exactly and just replacing the date string with Y, M and D (note: respect capitals and do not forget the file extension).

Specify the iputput directory and give an output image filename format using "YMD" to inlcude a date string and avoid overwriting (e.g., 010 stands then for January first decade, 122 is December third decade).

Set "Aggregation condition" to "decadal", "Propagate NULLs" to "No" and "Aggregate operation" to "mean" to compute the mean value.

FURTHER INFORMATION

As an optional step spatial subsetting of the image can be done by using "Region extent". Region cellsize is used for spatial resampling.

!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "(100*(A-B)/B)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:This step calculates the relative biophysical difference as the difference between the current biophysical value and the long-term mean value.

SETTINGS

Raster layer A:
Select the current biophysical images

Raster layer B:
Select the long-term mean calculated in the previous step.

Fomula:
Use the follwoing equation to calculate the relative difference as a percentage: (100*(A-B)/B).

Output raster layer:
Specify the name and location of the "output raster layer".

FURTHER INFORMATION

As an optional step spatial subsetting of the image can be done by using "Region extent". Region cellsize is used for spatial resampling.



!INSTRUCTIONS
.ALGORITHM:script:grassrunivarfortimeseries
.PARAMETERS:{"percentile": 90, "e": false}
.MODE:Normal
.INSTRUCTIONS:This step can be used to extract biophysical temporal profiles by land cover type or other zoning layers.

SETTINGS

Name of input raster map(s):
Select the input biophysical time series (e.g. a current year or the decadal long-term values) as "Input raster".

Raster map used for zoning:
Select a land cover map for zoning to define the land cover classes for which statistics should be calculated (Note: the raster map needs to be in integer format).

Name for output text file:
Specify the location and name for the output text file.
!INSTRUCTIONS
