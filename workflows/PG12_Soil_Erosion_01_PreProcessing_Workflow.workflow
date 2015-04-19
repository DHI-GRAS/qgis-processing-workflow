.NAME:01 - Data pre-processing
.GROUP:PG #12: Medium resolution erosion potential indicator
.ALGORITHM:gdalogr:merge
.PARAMETERS:{"RTYPE": 5, "PCT": false, "SEPARATE": true}
.MODE:Normal
.INSTRUCTIONS:In this step you will stack the rainfall data for calculation of mean annual rainfall in the following step.

SETTINGS

Input Layers:
Select and define the 36 decadal rainfall data files (.tif).

Layer stack:
Yes

Output Layers:
Select and define the path of output.
(e.g. 01_01_[NAME].tif)

!INSTRUCTIONS
.ALGORITHM:otb:bandmath
.PARAMETERS:{"-ram": 128, "-exp": "(im1b1+im1b2+im1b3+im1b4+im1b5+im1b6+im1b7+im1b8+im1b9+im1b10+im1b11+im1b12+im1b13+im1b14+im1b15+im1b16+im1b17+im1b18+im1b19+im1b20+im1b21+im1b22+im1b23+im1b24+im1b25+im1b26+im1b27+im1b28+im1b29+im1b30+im1b31+im1b32+im1b33+im1b34+im1b35+im1b36)/36"}
.MODE:Normal
.INSTRUCTIONS:In this step you will calculate the mean annual rainfall as input to calculate the R factor.

SETTINGS

Input Image List:
Select and define the output of the 36 band outputs of step 01_01.
(01_01_[NAME].tif )

Expression: (im1b1+im1b2+im1b3+im1b4+im1b5+im1b6+im1b7+im1b8+im1b9+im1b10+im1b11+im1b12+im1b13+im1b14+im1b15+im1b16+im1b17+im1b18+im1b19+im1b20+im1b21+im1b22+im1b23+im1b24+im1b25+im1b26+im1b27+im1b28+im1b29+im1b30+im1b31+im1b32+im1b33+im1b34+im1b35+im1b36)/36

Output Image:
Select and define the path for output.
(e.g. 01_02_[NAME].tif)

FURTHER INFORMATION

This step has to be done as the USLE model needs the mean annual rainfall as input values to calculate the R factor.
!INSTRUCTIONS
.ALGORITHM:gdalogr:merge
.PARAMETERS:{"RTYPE": 5, "PCT": false, "SEPARATE": false}
.MODE:Normal
.INSTRUCTIONS:In this step you will mosaic the single DEM tiles to create a continuous DEM for the area of interest.

SETTINGS

Input Layers:
Select and define the multiple DEM files for the area of interest.

Parameters:
Keep default values (all set to "No")

Output Layer:
Select and define the path for output.
(e.g. 01_03_[NAME].tif)

!INSTRUCTIONS
.ALGORITHM:gdalogr:translate
.PARAMETERS:{"ZLEVEL": 6, "SDS": false, "OUTSIZE": 100, "OUTSIZE_PERC": true, "RTYPE": 0, "COMPRESS": 0, "NO_DATA": "none", "BIGTIFF": 0, "TILED": false, "JPEGCOMPRESSION": 75, "TFW": false, "PREDICTOR": 1, "EXPAND": 0, "EXTRA": ""}
.MODE:Batch
.INSTRUCTIONS:This step is used to reduce the data to the area of interest. All data will be cliped to the aoi extent.

SETTINGS

Input Layers:
1. 01_02_[NAME].tif
2. Soil raster dataset
3. 01_03_[NAME].tif
4. GlobCover dataset (Land cover)
5. Medium Resolution Land Degradation Index

Parameters:
"Subset based on georeferenced coordinates" -> use layer/canvas extent: select the AOI shapefile

Define “Float32” as “output raster type” for: 
1. 01_04_01_rainfall_[NAME].tif
3. 01_04_03_DEM_[NAME].tif
5. 01_04_05_degradation_[NAME].tif

Output Layers:
Select and define the path for output.
1. 01_04_01_rainfall_[NAME].tif
2. 01_04_02_soil_[NAME].tif
3. 01_04_03_DEM_[NAME].tif
4. 01_04_04_landcover_[NAME].tif
5. 01_04_05_degradation_[NAME].tif

!INSTRUCTIONS
.ALGORITHM:gdalogr:warpreproject
.PARAMETERS:{"ZLEVEL": 6, "RTYPE": 0, "BIGTIFF": 0, "TR": 0, "EXTRA": "", "COMPRESS": 0, "NO_DATA": "-9999", "TILED": false, "JPEGCOMPRESSION": 75, "TFW": false, "METHOD": 0, "PREDICTOR": 1}
.MODE:Batch
.INSTRUCTIONS:In this step all data (raster only) will be projected to UTM zone 36 (EPSG: 32636) This step is necessary because in a later step metric values are needed for calculation.

SETTINGS

Input Layers:
1. 01_04_01_rainfall_[NAME].tif
2. 01_04_02_soil_[NAME].tif
3. 01_04_03_DEM_[NAME].tif
4. 01_04_04_landcover_[NAME].tif
5. 01_04_05_degradation_[NAME].tif

Parameter:
Set "Destination SRS (EPSG Code)" to EPSG: 32636

Define “Float32” as “output raster type” for: 
1. 01_04_01_rainfall_[NAME].tif
3. 01_04_03_DEM_[NAME].tif
5. 01_04_05_degradation_[NAME].tif

Output Layers:
Select and define the path for output.
1. 01_05_01_rainfall_[NAME].tif
2. 01_05_02_soil_[NAME].tif
3. 01_05_03_DEM_[NAME].tif
4. 01_05_04_landcover_[NAME].tif
5. 01_05_05_degradation_[NAME].tif

!INSTRUCTIONS
.ALGORITHM:grass:r.resamp.stats
.PARAMETERS:{"-w": false, "-n": false, "GRASS_REGION_CELLSIZE_PARAMETER": 150, "method": 0, "-a_r.region": false}
.MODE:Normal
.INSTRUCTIONS:In this step the DEM will be resampled to a lower resolution.

SETTINGS

Input Raster Layer:
Select and define the output of 01_05_03.
(01_05_03_DEM_[NAME].tif)

Set "Align region to resolution" to "Yes"

GRASS region extent:
=>"use layer/canvas extent"
=> choose soil layer (01_05_02_soil_[NAME].tif)

Set GRASS region cell size = 150

Output Raster Layer:
Select and define the path for output. (e.g. 01_06_DEM_[NAME].tif)

FURTHER INFORMATION

To guarantee an efficient processing within the following processing step, the DEM will be resampled to a lower resolution.
!INSTRUCTIONS
.ALGORITHM:qgis:reprojectlayer
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:In this step you adjust the AOIs projection to UTM zone 36 (EPSG: 32636).

SETTINGS

Input Layer:
Select and define the shapefile with area of interest.

Target CRS:
to EPSG: 32636

Output (Reprojected Layer):
Select and define the path for output.
(e.g. 01_07_[NAME].shp)
!INSTRUCTIONS
