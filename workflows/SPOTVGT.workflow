.NAME:SPOT VGT import
.GROUP:Tools
.ALGORITHM:gdalogr:translate
.PARAMETERS:{"ZLEVEL": 6, "SDS": false, "OUTSIZE": 100, "OUTSIZE_PERC": true, "RTYPE": 5, "COMPRESS": 0, "BIGTIFF": 0, "TILED": false, "JPEGCOMPRESSION": 75, "TFW": false, "PREDICTOR": 1, "EXPAND": 0, "EXTRA": "-a_ullr -30 40 60 -40"}
.MODE:Normal
.INSTRUCTIONS:Import SPOT VGT Africa-subset data into the WOIS.

SETTINGS

Input layer:
THe SPOT VGT HDF5-file that you want to import. When asked which raster layer to add, choose '//FAPAR'

Output projection for output file:
EPSG:4326 should be chosen.

Subset based on georeferenced coordinates:
The following must be copied into the field:
0, 10081, 8961, 0
Those are the dimensions of the SPOT VGT Africa-subset image and they are required since the image itself has no projection information and automatic image extent calculation is not possible.

Other settings:
Leave the default values.

NOTE:
After clicking "Run" you will be asked for input layer projection information. You can chose any projection since it will be overwritten during the GDAL Translate call anyway. 

!INSTRUCTIONS
