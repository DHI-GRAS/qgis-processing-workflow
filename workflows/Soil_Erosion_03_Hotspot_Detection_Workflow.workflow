.NAME:03 - Hot Spot Detection
.GROUP:PG #12: Medium resolution erosion potential indicator
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(A>=0,0,A*(-100000))", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the land degradation data will be reduced and the negative values will be scaled to positive values.

SETTINGS

Raster Layer A:
Select and define the output of step 01_05_05.
(01_05_05_degradation_[NAME].tif)

Expression (Formula):
if(A>=0,0,A*(-100000))

Output Raster Layer:
Select and define the path for output.
(e.g. 03_01_[NAME].tif)

FURTHER INFORMATION

In this step the land degradation data will be reduced to the areas with negative land degradation values. At the same time the negative values will be scaled to positive values for further calculations.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(A==0 || B==0,0,if(A<=1,10,if(A<=5,20,if(A<=10,30,if(A<=15,40,if(A<=20,50,60))))))", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the land degradation data will be reclassified.

SETTINGS

Raster Layer A:
Select and define the output of step 03_01.
(03_01_[NAME].tif)

Raster Layer B:
Select and define the output of step 02_11.
(02_11_[NAME].tif)

Expression (Formula):
if(A==0 || B==0,null(),if(A<=1,10,if(A<=5,20,if(A<=10,30,if(A<=15,40,if(A<=20,50,60))))))

Land degradation values of the output raster:
0 = No land degradation / water mask
1 = very low
2 = low
3 = low to medium
4 = medium to high
5 = high
6 = very high

Output Raster Layer:
Select and define the path for output.
(e.g. 03_02_[NAME].tif)

FURTHER INFORMATION

In this step the land degradation data will be reclassified to the same scale (classes) as the USLE data.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "A+B", "GRASS_REGION_CELLSIZE_PARAMETER": 150}
.MODE:Normal
.INSTRUCTIONS:In this step the calssified land degradation and the soil erosion potential will be combined.

SETTINGS

Raster Layer A:
Select and define the output of step 02_11.
02_11_[NAME].tif

Raster Layer B:
Select and define the output of step 03_02.
03_02_[NAME].tif

Expression:
A+B

Output Raster Layer:
Select and define the path for output.
(e.g. 03_03_[NAME].tif)

FURTHER INFORMATION

In this step the "classified land degradation" and "soil erosion potential" data will be combined. This will be done to generate a raster holding the information of both files. Land degradation information represented by decade values (10, 20, 30, 40, 50, 60) and soil erosion potential by units digits (1, 2, 3, 4, 5, 6). This results in a raster with unique combinations of both indicators. Very high soil erosion potential and very high land degradation for example is represented by 66.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(A==0,0,if(A==44,2,if(A==45,2,if(A==46,2,if(A==54,2,if(A==55,2,if(A==56,2,if(A==64,2,if(A==65,2,if(A==66,2,1))))))))))", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step a hotspot raster will be created.

SETTINGS

Raster Layer A:
Select and define the output of step 03_03.
(03_03_[NAME].tif)

Expression (Formula): if(A==0,0,if(A==44,2,if(A==45,2,if(A==46,2,if(A==54,2,if(A==55,2,if(A==56,2,if(A==64,2,if(A==65,2,if(A==66,2,1))))))))))

Output Raster Values:
0 = water mask
1 = areas with very low to medium soil erosion potential and very low to medium land degradation
2 = hotspots of anthropogenic caused soil erosion

Output Raster Layer:
Select and define the path for output.
(e.g. 03_04_[NAME].tif)

FURTHER INFORMATION

In this step all areas with medium to very high soil erosion potential and medium to very high land degradation are classified as hotspots of anthropogenic caused soil erosion. The classification scheme was described in the previous step.
!INSTRUCTIONS
