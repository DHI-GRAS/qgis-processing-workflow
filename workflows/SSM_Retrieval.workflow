.NAME:05 - Soil Moisture Retrieval
.GROUP:PG #07: Flood mapping system
.ALGORITHM:script:soilmoistureretrieval
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:The algorithm retrieves the surface soil moisture.

SETTINGS

Sensor:
The Sensor type.

sigma0:
sigma0 nodata:
The backscatter image and its nodata value.

local incidence angle:
lia nodata:
The local incidence angle image and its nodata value.

parameter database:
A tile based parameter database provided by TUWien is required for soil moisture retrieval. 

output raster:
Specify the output file name.

FURTHER INFORMATION

The area of standing water, oversaturated soil, dense vegetation(rainiforest), complex topography  or  desert will be masked out from the soil moisture.

!INSTRUCTIONS