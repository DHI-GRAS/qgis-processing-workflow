.NAME:Correlation analysis of SWI with biomass indices
.GROUP:PG #08: Hydrological Characterisation
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": true, "filenameFormat": "", "operation": 0, "outputFileFormat": "", "groupBy": 5}
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
