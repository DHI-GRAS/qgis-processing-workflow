.NAME:Areal analysis of population affected by delayed SoS
.GROUP:PG #08: Hydrological Characterisation
.ALGORITHM:grass:r.resamp.interp
.PARAMETERS:{"-a_r.region": false, "GRASS_REGION_CELLSIZE_PARAMETER": 0, "method": 0}
.MODE:Batch
.INSTRUCTIONS:Resample the Start of Season (SoS) data to the resolution of your population data.

SETTINGS:

Input raster layer:
Select and define all decadal "SoS" files for one year.

Interpolation method:
nearest

Align region to resolution:
Set to "Yes"

GRASS region extent
Select the canvas extent of your population layer (Note that you have to load it into your map canvas to select it in the tool)

GASS region cellsize:
Select and define the resolution of you population datatset (e.g. 0.00833333)

Output raster layer:
select and define your output raster layer by chosing "fill with numbers" at autofill settings

Load in QGIS:
Define "NO"
!INSTRUCTIONS
.ALGORITHM:grass:r.reclass
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Batch
.INSTRUCTIONS:Reclassify resampled "SoS" data

SETTINGS:

input raster layer:
Select and define all resampled SoS-files from the step before.

File containing reclass rules:
Create a txt file which contains the rules
as example:
1 = 1
2 3 4 5 6 7 8 9 = 0
with this content you use the class 1 for your analysis. you can change these rules, based on the classes you like to analyze.

Output raster layer:
Select and define your raster output file

Load in QGIS
Make sure "Load in QGIS" is set to YES

!INSTRUCTIONS
.ALGORITHM:gdalogr:merge
.PARAMETERS:{"RTYPE": 0, "PCT": false, "SEPARATE": true}
.MODE:Normal
.INSTRUCTIONS:Merge the reclassified SoS files to a layer stack

SETTINGS:

Input layers:
Select and define the reclassified SoS files (result of step 2). Note that those files have to be loaded in your map canvas to be able to select them.

Layer stack:
Activate

Output raster type:
Byte

Output layer:
Select and define your output raster (e.g. 3_Stacked_SoS_1.tif).
!INSTRUCTIONS
.ALGORITHM:otb:bandmath
.PARAMETERS:{"-ram": 128, "-exp": "im1b1 + im1b2 + im1b3 + im1b4 + im1b5 + im1b6 + im1b7 + im1b8 + im1b9 + im1b10 + im1b11 + im1b12 + im1b13 + im1b14 + im1b15 + im1b16 + im1b17 + im1b18 + im1b19 + im1b20 + im1b21 +  im1b22 +  im1b23 +  im1b24 +  im1b25 +  im1b26 +  im1b27 +  im1b28 +  im1b29 +  im1b30 + im1b31 + im1b32 + im1b33 + im1b34 + im1b35 + im1b36"}
.MODE:Normal
.INSTRUCTIONS:This steps sums up the single decades to determine the duration of the delay in start of season within agiven time period (e.g. one year)

SETTINGS:

Input image list:
Select and define the merged layer derived from step 3 (e.g. 3_Stacked_SoS_1.tif).

Expression:
im1b1 + im1b2 + im1b3 + im1b4 + im1b5 + im1b6 + im1b7 + im1b8 + im1b9 + im1b10 + im1b11 + im1b12 + im1b13 + im1b14 + im1b15 + im1b16 + im1b17 + im1b18 + im1b19 + im1b20 + im1b21 +  im1b22 +  im1b23 +  im1b24 +  im1b25 +  im1b26 +  im1b27 +  im1b28 +  im1b29 +  im1b30 + im1b31 + im1b32 + im1b33 + im1b34 + im1b35 + im1b36

Output Image:
Select and define your output raster. (e.g. 4_Duration_SoS_2012_1.tif)

!INSTRUCTIONS
.ALGORITHM:grass:r.reclass
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:Reclass the sum of the single bands from step 4.

SETTINGS:

Input raster layer:
Select the duration raster file derived from step 4 (e.g. 4_Duration_SoS_2012_1.tif)

file containing reclass rules:
Create a txt file which contains the rules
as example:
1 thru 36 = 1
* = 0
with this content you use the codes 1 thru 36 for your analysis.

Output raster layer:
Select and define your output raster. (e.g. 5_Delay_SoS_2012_1.tif)

Further information:

This step is necessary to calculate the affected population in the upcoming steps. The resulting raster depicts were a delay in start of season took place, regardless the duration.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "A*B", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:in this step the potential affected people, suffering from delay in start of season is assessed. Therefore the population raster is multiplied with the result out of step 5.

SETTINGS:

Raster layer A:
Select and define the Population Raster (e.g. "ap10v4_TOTAL_adj.tif")

Raster layer B:
Select and define your output out of step 5 (e.g. 5_Delay_SoS_2012_1.tif)

Formula:
A*B

Output raster layer:
Select and define your output raster. (e.g. 6_PotAffect_Population.tif)

Leave the rest on default

!INSTRUCTIONS
.ALGORITHM:modeler:zonal_sm4tiger
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:This Step derives information about the number of affected people from a delay in  start of season in a specific zone. Further it provides information about the duration of the delay per zone (min, max, mean)

SETTINGS:

Duration Raster:
Select and define the output of step 4 (e.g. 4_Duration_SoS_2012_1.tif)

Population raster
Select a Population Raster (e.g. "ap10v4_TOTAL_adj.tif")

Zone Layer:
Choose a Polygon, containing the zones you like to analyze (e.g. world borders, district borders...)

Zonal Statistics:
Define the output for your zonal statistics
!INSTRUCTIONS
