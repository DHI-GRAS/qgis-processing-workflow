.NAME:Zonal statistics (mulitple zones)
.GROUP:Tools
.ALGORITHM:qgis:zonalstatistics
.PARAMETERS:{"COLUMN_PREFIX": "_", "RASTER_BAND": 1, "GLOBAL_EXTENT": true}
.MODE:Normal
.INSTRUCTIONS:This algorithm calculates summary rainfall statistics within zones as defined by the polygon vector layer.

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

All results are stored  as attributed in a new output vector layer.

SETTINGS:
Under Raster layer select the input rainfall map for the summary statsistcs.

Select the vector layer containing the zones which will contstrain the calculations.

Say yes to Load whole raster in memory.

Under Output layer specify name and output for the resulting vector output layer file.
!INSTRUCTIONS
