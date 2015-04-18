.NAME:Evapotranspiration
.GROUP:PG #08: Hydrological Characterisation
.ALGORITHM:script:downloadfromftp
.PARAMETERS:{"username": "", "timestamp": "", "host": "", "remoteDir": "", "password": "", "overwrite": false}
.MODE:Normal
.INSTRUCTIONS:Download daily, Pan-African evapotranspiration (ET) estimate maps (mm/day) via FTP.

The subsequent steps can be used to calculate the daily mean ET per month (mm/day/month) and monthly mean ET (mm/month).

Note: download of real time ET products only for registered users upon request.

SETTINGS

FTP server address:
Username: Define
Password: Define
Remote Directory: Define

Local Directory:
Specify a local directory where the data will be downloaded to (e.g.
C:\Data\Evapotranspiration).

Download files modified since:
Only files which have been last modified on or after the specified date will be downloaded.

Overwrite existing files:
If set to yes any files located in the Local Directory which have the same filename as the newly downloaded files will be overwritten.

Extent to subset (Advanced):
If this field is set, the images will be automatically subsetted to the given extent after downloading.

FURTHER INFORMATION

The ET estimate is based on LSA-SAF ET product and has been subsetted and reprojected by the TIGER-NET consortium before being made available on the FTP server. If interested in this product please contact the TIGER-NET consortium.



!INSTRUCTIONS
.ALGORITHM:script:grassrseriesforwholedirectory
.PARAMETERS:{"cellSize": 0, "range": "0,60000", "propagateNulls": false, "filenameFormat": "", "operation": 0, "outputFileFormat": "", "groupBy": 0}
.MODE:Normal
.INSTRUCTIONS:Calculate mean daily evapotranspiration per month (mm/day/month).

SETTINGS

An image file located in the data directory:
Select the first image file located in the directory to which the data was downloaded (e.g. in C:\Data\Evapotranspiration)

Input images filename:
Type the filename of the image selected in the above field with the date string replaced with Y, M and D (e.g. 20120824 = YYYYMMDD). Remember to include file extension (e.g. .tif) as well.

Output directory:
Specify the directory where the aggregated evapotranspiration images are to be saved (e.g. C:\Data\Evapotranspiration\MeanDailyPerMonth)

Output image filename:
Define the output image filename, with the date string replaced by "YMD" (e.g. ET_meanDailyPerMonth_YMD.tif).

Aggregation condition:
Propagate NULLs
Aggregate operation:
With the pre-set options the algorithm will group all the images that come from the same year and month and calculate the average value for each pixel, while ignoring any missing data.

Regional extent:
Region cellsize:
Those parameters are optional and allow to subset the region of interest based on a spatial extent selected on the map or based on the extent of another layer. Region cellsize is used for spatial resampling of the pixel size. If settings are left as is, the whole image will be processed at native resolution.

Other settings:
Leave the default values.
!INSTRUCTIONS
.ALGORITHM:script:otbbandmathfortemporaldata
.PARAMETERS:{"filenameFormat1": "", "expression": "im1b1*30", "ram": 128, "outputFileFormat": "", "groupBy": 0, "filenameFormat3": "", "filenameFormat2": ""}
.MODE:Normal
.INSTRUCTIONS:Estimate the total monthly evapotranspiration (mm/month) from monthly-mean daily evapotranspiration (mm/day/month).

SETTINGS

im1:
Select the first image located in the directory with the monthly-mean daily evapotranspiration files (e.g.  C:\Data\Evapotranspiration\MeanDailyPerMonth\ET_meanDailyPerMonth_201303.tif).

im1 filename:
Retype the input image filename incl. file extension (e.g., .tif) and replace the date string with Y,M,D (e.g. ET_meanDailyPerMonth_YYYYMM.tif).

Output directory:
Define the directory where output files will be saved (e.g. C:\Data\Evapotranspiration\TotalMonthly).

Output images filename:
Define the output image filename, with the date string replaced by "YMD" (e.g. ET_totalMonthly_YMD.tif).

Pair images by:
year-month

Band math expression:
With the pre-set options the algorithm will group all images with the same year and month and multiply each image by 30 to calculate total monthly ET. In this case each group will only have one image, since in the previous step the mean daily ET per month was calculated.

Other settings:
Leave the default values.
!INSTRUCTIONS
.ALGORITHM:qgis:zonalstatistics
.PARAMETERS:{"COLUMN_PREFIX": "ET_", "RASTER_BAND": 1, "GLOBAL_EXTENT": true}
.MODE:Normal
.INSTRUCTIONS:Calculate summary ET statistics within zones as defined by the polygon vector layer.

SETTINGS

Raster layer:
Select the input ET map for the summary statistics (e.g. C:\Data\Evapotranspiration\TotalMonthly\ET_totalMonthly_201303.tif)

Vector layer containing zones:
Select the vector layer containing the zones which will constrain the calculations (e.g. C:\Data\AfricanBasins.shp).

Output column prefix:
Since we are dealing with rainfall ET_ is set as prefix.

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
