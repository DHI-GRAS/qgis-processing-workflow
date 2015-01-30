.NAME:Correlation analysis of SWI and rainfall
.GROUP:PG #08: Hydrological Characterisation
.ALGORITHM:wg9hm:12getfewsrfedataosfwf
.PARAMETERS:{"START_DATE": "20130101", "END_DATE": "20140101"}
.MODE:Normal
.INSTRUCTIONS:Download daily, pan-African FEWS-RFE precipitation data.

SETTINGS

Select precipitation folder:
Specify a local directory where the data will be downloaded to (e.g. C:\Data\RFE).

Start date:
End date:
Rainfall data will be downloaded for period between the start and end dates. For dates before the current year, the whole year of data will be downloaded.

Subset to extent (Advanced):
If this field is set, the images will be automatically subsetted to the given extent after downloading.

FURTHER INFORMATION

The module connects to the internet and downloads the latest available precipitation data from http://earlywarning.usgs.gov/fews/africa/web/imgbrowsc2.php?extent=afp6. Daily precipitation is stored as geotiff files in the folder specified by the user.

After running this module, the precipitation folder will contain data for the requested period, unless the dataset in the online archive ends earlier. Typically, FEWS-RFE is available with a real-time delay of a few days.

!INSTRUCTIONS
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": true, "filenameFormat": "", "operation": 10, "outputFileFormat": "", "groupBy": 3}
.MODE:Normal
.INSTRUCTIONS:calculate accumulated rainfall by defined period of time.

SETTINGS

An image file located in the data directory:
Select the first image file located in the directory in which the rainfall data is located (e.g. in C:\Data\RFE)

Input images filename:
Type the filename of the image selected in the above field with the date string replaced with Y, M and D (e.g. 20120824 = YYYYMMDD). Remember to include file extension (e.g. .tif) as well.

Output directory:
Specify the directory where the aggregated erainfall images are to be saved (e.g. C:\Data\RFE\MeanMonthly)

Output image filename:
Define the output image filename, with the date string replaced by "YMD" (e.g. RFE_meanMonthly_YMD.tif).

Aggregation condition:
Propagate NULLs:
Aggregate operation:
With the pre-set options the algorithm will group all the images that come from the same year and month and calculate the sum of values for each pixel. Pixels with missing values will be ignored.

Regional extent:
Region cellsize:
Those parameters are optional and allow to subset the region of interest based on a spatial extent selected on the map or based on the extent of another layer. Region cellsize is used for spatial resampling of the pixel size. If settings are left as is, the whole image will be processed at native resolution.

Other settings:
Leave the default values.

FURTHER INFORMATION

With the above settings, accumulated monthly rainfall will be calculated. If you want to calculate accumulated yearly rainfall, the "Aggregation condition" needs to be changed to "Year".

!! remeber to build a virtual raster out of these results!!
you find the tool in:
raster->miscellaneous-> build virtual raster
set the time series results as input, select seperate and click OK
!INSTRUCTIONS
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": true, "filenameFormat": "", "operation": 2, "outputFileFormat": "", "groupBy": 0}
.MODE:Normal
.INSTRUCTIONS:calculate average SWI by defined period of time.

SETTINGS

An image file located in the data directory:
Select the first image file located in the directory in which the SWI data is located (e.g. in C:\Data\SWI)

Input images filename:
Type the filename of the image selected in the above field with the date string replaced with Y, M and D (e.g. 20120824 = YYYYMMDD). Remember to include file extension (e.g. .tif) as well.

Output directory:
Specify the directory where the aggregated SWI images are to be saved (e.g. C:\Data\SWI\Monthly)

Output image filename:
Define the output image filename, with the date string replaced by "YMD" (e.g. SWI_Monthly_YMD.tif).

Aggregation condition:
Propagate NULLs:
Aggregate operation:
With the pre-set options the algorithm will group all the images that come from the same year and month and calculate the median of values for each pixel. Pixels with missing values will be ignored.

Regional extent:
Region cellsize:
Those parameters are optional and allow to subset the region of interest based on a spatial extent selected on the map or based on the extent of another layer. Region cellsize is used for spatial resampling of the pixel size. If settings are left as is, the whole image will be processed at native resolution.

Other settings:
Leave the default values.

FURTHER INFORMATION

With the above settings, median monthly SWI will be calculated. If you want to calculate accumulated yearly rainfall, the "Aggregation condition" needs to be changed to "Year".

!! remeber to build a virtual raster out of these results!!
you find the tool in:
raster->miscellaneous-> build virtual raster
set the time series results as input, select seperate and click OK

For the final correlation analysis, start the “Temporal/Spectral Profile” Tool and load both virtual raster stacks.
!INSTRUCTIONS
