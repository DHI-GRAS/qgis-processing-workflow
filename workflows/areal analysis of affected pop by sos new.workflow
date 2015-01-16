.NAME:Areal analysis of population affected by delayed SoS
.GROUP:PG #08: Hydrological Characterisation
.ALGORITHM:grass:r.resamp.interp
.PARAMETERS:{"-a_r.region": false, "GRASS_REGION_CELLSIZE_PARAMETER": 0, "method": 0}
.MODE:Batch
.INSTRUCTIONS:Resample the Start of Season data to the same cellsize as the population data.

SETTINGS:

Input: chose all decadal "SoS" files for one year.

Interpolation method: nearest neighbor, since this is a thematic dataset

Set align region to resolution to "Yes"

For GRASS region extent chose the population layer (you have to load it into your map canvas to select it in the tool)

Name your output raster layer by chosing "fill with numbers" at autofill settings

Chose "NO" for the "Load in QGIS" option
!INSTRUCTIONS
.ALGORITHM:grass:r.reclass
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Batch
.INSTRUCTIONS:Reclassify resampled "SoS" data

SETTINGS:

Fill the the column “input raster layer” and select all resampled SoS-files from the step before.

file containing reclass rules:
-create a txt file which contains the rules
-for example:
1 = 1
2 3 4 5 6 7 8 9 = 0
with this content you use the class 1 for your analysis. you can change these rules, based on the classes you like to analyze

Make sure "Load in QGIS" is set to YES

!INSTRUCTIONS
.ALGORITHM:gdalogr:merge
.PARAMETERS:{"PCT": false, "SEPARATE": true}
.MODE:Normal
.INSTRUCTIONS:Merge the reclassified SoS files to a layer stack

SETTINGS:

Input: reclassified SoS files (result of step 2). those files have to be loaded in your map canvas to be able to select them.

Leave all settings to default.
!INSTRUCTIONS
.ALGORITHM:otb:bandmath
.PARAMETERS:{"-ram": 128, "-exp": "im1b1 + im1b2 + im1b3 + im1b4 + im1b5 + im1b6 + im1b7 + im1b8 + im1b9 + im1b10 + im1b11 + im1b12 + im1b13 + im1b14 + im1b15 + im1b16 + im1b17 + im1b18 + im1b19 + im1b20 + im1b21 +  im1b22 +  im1b23 +  im1b24 +  im1b25 +  im1b26 +  im1b27 +  im1b28 +  im1b29 +  im1b30 + im1b31 + im1b32 + im1b33 + im1b34 + im1b35 + im1b36"}
.MODE:Normal
.INSTRUCTIONS:This tool sums up the single decades to determine the duration of the delay in start of season in one year

SETTINGS:

Input: Layer stack derived from Step 3

!INSTRUCTIONS
.ALGORITHM:grass:r.reclass
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:Reclass the sum of the single bands from step 4.

SETTINGS:

file containing reclass rules:
-create a txt file which contains the following rules:

1 thru 36 = 1
* = 0

Further information:

This is necessary to calculate the affected population in further steps.
The resulting raster depicts were a delay in start of season takes place, regardless of duration.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": " A*B", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:This step calculates the number of people, suffering from delay in start of season. Therefor the population raster is multiplied with the result from step 5

SETTINGS:

Choose the population raster ("ap10v4_TOTAL_adj.tif") as input A
and the result from step 5 as input B

Leave the rest on default

!INSTRUCTIONS
.ALGORITHM:modeler:zonal_sm4tiger
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:This tool derives information about how many people are affected by a delay in start of season in a specific zone. Further it provides information about the duration of the delay per zone (min, max, mean)

SETTINGS:

Zone Layer:
Choose a Polygon, containing the zones you like to analyze (e.g. world borders, district borders...)

Population Raster:
Select a Population Raster (e.g. "ap10v4_TOTAL_adj.tif" from WorldPop)

Duration Raster:
Select the result of step 4 (band math)
!INSTRUCTIONS
