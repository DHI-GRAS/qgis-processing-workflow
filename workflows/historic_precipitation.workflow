.NAME:Historic precipitation
.GROUP:PG #08: Hydrological Characterisation
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "-10000000000,10000000000", "propagateNulls": true, "filenameFormat": "", "operation": 10, "outputFileFormat": "", "groupBy": 0}
.MODE:Normal
.INSTRUCTIONS:Calculate accumulated rainfall by month or year.

SETTINGS

An image file located in the data directory:
Select the first image file located in the directory in which the rainfall data is located (e.g. in C:\Data\RFE)

Input images filename:
Type the filename of the image selected in the above field with the date string replaced with Y, M and D (e.g. 20120824 = YYYYMMDD). Remember to include file extension (e.g. .tif) as well.

Output directory:
Specify the directory where the aggregated evapotranspiration images are to be saved (e.g. C:\Data\RFE\MeanMonthly)

Output image filename:
Define the output image filename, with the date string replaced by "YMD" (e.g. RFE_meanMonthly_YMD.tif).

Aggregate operation:
With the pre-set options the algorithm will group all the images that come from the same year and month and calculate the sum of values for each pixel. 

Propagate NULLs: when checked  pixels with missing values will be ignored.

Regional extent:
Region cellsize:
Those parameters are optional and allow to subset the region of interest based on a spatial extent selected on the map or based on the extent of another layer. Region cellsize is used for spatial resampling of the pixel size. If settings are left as is, the whole image will be processed at native resolution.

Other settings:
Leave the default values.

FURTHER INFORMATION

With the above settings, accumulated monthly rainfall will be calculated. If you want to calculate accumulated yearly rainfall, the "Aggregation condition" needs to be changed to "Year".
!INSTRUCTIONS
.ALGORITHM:qgis:zonalstatistics
.PARAMETERS:{"COLUMN_PREFIX": "_", "RASTER_BAND": 1, "GLOBAL_EXTENT": true}
.MODE:Normal
.INSTRUCTIONS:Calculate summary rainfall statistics within zones as defined by the polygon vector layer.

SETTINGS

Raster layer:
Select the input rainfall map for the summary statistics (e.g. C:\Data\RFE\MeanMonthly\RFE_meanMonthly_201303.tif)

Vector layer containing zones:
Select the vector layer containing the zones which will constrain the calculations (e.g. C:\Data\AfricanBasins.shp).

Output layer
Specify name for the vector output layer file which will contain the statistics (e.g. C:\Data\AfricanBasinsStast_201303.shp).

Other settings:
Leave the default values.

FURTHER INFORMATION

For each zone the following values are calculated:
	- minimum
	- maximum
	- sum
	- count
	- mean
	- standard deviation
	- number of unique values
	- range
	- variance

All results are stored as attributes in a new output vector layer.
!INSTRUCTIONS
.ALGORITHM:script:buildvirtualrasterdirectory
.PARAMETERS:{"proj_difference": false, "resolution": 0, "separate": true}
.MODE:Normal
.INSTRUCTIONS:Build virtual raster file from a time-series of rainfall images.

SETTINGS

Image located in input directory:
Select an image from a directory containing the time-series of images (e.g. C:\Data\RFE\rain_20140101.tif). The virtual raster will be created from all images located in the same directory and with same file extension as the selected image.

Layer stack:
Set to "Yes" to add each image as a separate band of the output virtual raster.

Output file:
The name of the output virtual raster file (e.g. C:\Data\RFE\rain_2014.vrt). If the file extension is different from .vrt then it will be automatically changed to .vrt.

Other settings:
Leave the default values.

FURTHER INFORMATION

The virtual raster can be used with Temporal/Spectral Profile Tool to display time-series graphs of rainfall at individual pixels.
!INSTRUCTIONS
