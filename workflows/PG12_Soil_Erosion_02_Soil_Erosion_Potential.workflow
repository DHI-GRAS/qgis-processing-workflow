.NAME:02 - Soil Erosion Potential
.GROUP:PG #12: Medium resolution erosion potential indicator
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "(A*0.4669)-12.1415", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the R-factor will be calculated.

SETTINGS

Raster Layer A:
Select and define the output of step 01_05_01.
(01_05_01_rainfall_[NAME].tif)

Expression (Formula):
(A*0.4669)-12.1415

Output Raster Layer:
Select and define the path for output.
(e.g. 02_01_[NAME].tif)

FURTHER INFORMATION

Within this step, the R factor is calculated according to the following equation: R = 0,4669 X - 12,1415 where, R = the rainfall-runoff erosivity factor in MJ.mm.ha-1.h-1 yr-1 and X = mean annual rainfall (mm). The mean annual rainfall was calculated from the FEWS decadal rainfall data (Step 1, workflow 1).
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(A==1,0.17,if(A==2,0.26,if(A==3,0.22,if(A==4,0.32,if(A==5,0.30,if(A==6,0.43,if(A==7,0.38,if(A==8,0.35,if(A==9,0.30,if(A==10,0.20,if(A==11,0.13,if(A==12,0.04,if(A==13,0.02,0)))))))))))))", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the K-factor will be calculated.

SETTINGS

Raster Layer A:
Select and define the output of 01_05_02.
(01_05_02_soil_[NAME].tif)

Expression (Formula): if(A==1,0.17,if(A==2,0.26,if(A==3,0.22,if(A==4,0.32,if(A==5,0.30,if(A==6,0.43,if(A==7,0.38,if(A==8,0.35,if(A==9,0.30,if(A==10,0.20,if(A==11,0.13,if(A==12,0.04,if(A==13,0.02,0)))))))))))))

Output Raster Layer:
Select and define the path for output. (e.g. 02_02_[NAME].tif)

FURTHER INFORMATION

In this step the K factor is determined by assigning erodibility values to the USDA texture classes of the FAO Digital Soil Map of the World.
The average values of the erodibility classes from the USLE fact sheet by the Ministry of Agriculture, Food and Rural Affairs, Ontario will be assigned to equivalent classes of the Digital Soil Map of the World.
These values define how erodible different types of soil are. Some soils have a low erodibility factor, depending on their texture, of e.g. 0.02 while others have a high erodibility of e.g. 0.38.
!INSTRUCTIONS
.ALGORITHM:grass:r.terraflow.short
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0, "-s": false}
.MODE:Normal
.INSTRUCTIONS:In this step the flow accumulation will be calculated as well as other intermediate catchment characteristics.

SETTINGS

Input (Name of elevation raster map):
Select and define the output of step 01_06_DEM.
01_06_DEM_[NAME].tif

Parameters:
Keep all default settings

Output:
Define filename for each output file 02_03_[NAME].tif for the statistic file use 02_03_[NAME].txt

use unique names to identify the "flow accumulation" file in the next step.

FURTHER INFORMATION

In this step the flow accumulation will be calculated which will be used to calculate the flow length which is needed to calculate the L-factor. The other calculated outputs are not needed. But these additional outputs have to be calculated as there is no other comparable tool to calculate the flow accumulation.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "A*150.0", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the flow accumulation will be weighted with the cell size in meter.

SETTINGS

Raster Layer A:
02_03_[NAME].tif
(Flow accumulation raster)

Expression (Formula):
A*150.0

Output Raster Layer:
Select and define the path for output.
(e.g. 02_04_[NAME].tif)

FURTHER INFORMATION

In this step the flow accumulation will be weighted with the cell size in meter to derive the slope length which will be needed during the L-factor calculation.
!INSTRUCTIONS
.ALGORITHM:grass:r.slope
.PARAMETERS:{"-a": true, "format": 1, "prec": 0, "min_slp_allowed": 0, "zfactor": 1, "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the steepness of slopes will be calculated in percent.

SETTINGS

Input (Name of elevation raster map):
Select and define the resampled DEM of step 01_06_DEM.
(01_06_DEM_[NAME].tif)

Parameters:
Keep all default values

Output (Name for output slope raster map):
Select and define the path for output.
(e.g. 02_05_[NAME].tif)

FURTHER INFORMATION

In this step the steepness of the slopes will be calculated in percent. This output will be used to calculate the L-factor, as it varies with different slope angles.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(A<4, pow(B/22.13,0.3),if(A==4,pow(B/22.13,0.4),if(A>4, pow(B/22.13,0.5),0)))", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the L-factor will be calculated.

SETTINGS

Raster Layer A:
Select and define the output of step 02_05.
(02_05_[NAME].tif)

Raster Layer B:
Select and define the output of step 02_04.
(02_04_[NAME].tif)

Expression (Formula):
if(A<4, pow(B/22.13,0.3),if(A==4,pow(B/22.13,0.4),if(A>4, pow(B/22.13,0.5),0)))

Output Raster Layer:
Select and define the path for output.
(e.g. 02_06_[NAME].tif)

FURTHER INFORMATION

In this step the L factor is calculated by the equation L = (x/22,13)m. Where x is the slope length in meter and m is the weight factor depending on the slope steepness.
Slope
< 1: m = 0.2
= 1 - < 3: m = 0.3
= 3 - < 5: m = 0.4
= 5: m = 0.5
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "0.065+0.045*A+0.0065*pow(A,2)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the S-factor will be calculated.

SETTINGS

Raster Layer A:
Select and define the output of step 02_05.
(02_05_[NAME].tif)

Expression (Formula): 0.065+0.045*A+0.0065*pow(A,2)

Output Raster Layer:
Select and define the path for output.
(e.g. 02_07_[NAME].tif)

FURTHER INFORMATION

In this step the S factor (slope coefficient) is calculated. It is calculated by the equation:[0.065+0.0456(slope)+0.006541(slope)^2 ].
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "A*B", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the LS-factor will be calculated.

SETTINGS

Raster Layer A:
Select and define the output of step 02_06.
(02_06_[NAME].tif)

Raster Layer B:
Select and define the output of step 02_07.
(02_07_[NAME].tif)

Expression (Formula):
A*B

Output Raster Layer:
Select and define the path for output.
(e.g. 02_08_[NAME].tif)

FURTHER INFORMATION

In this step the LS factor is calculated by multiplying the L and S values.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(A==11,0.525,if(A==14,0.525,if(A==20,0.255,if(A==30,0.255,if(A==40,0.003,if(A==50,0.048,if(A==60,0.048,if(A==70,0.003,if(A==90,0.025,if(A==100,0.048,if(A==110,0.088,if(A==120,0.088,if(A==130,0.100,if(A==140,0.015,if(A==150,0.200,if(A==160,0.280,if(A==170,0.280,if(A==180,0.280,if(A==190,0.000,if(A==200,0.600,if(A==210,0.000,if(A==220,0.000,0.000))))))))))))))))))))))", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the C-factor will be calculated.

SETTINGS

Raster Layer A:
Select and define the output of step 01_05_04.
(01_05_04_landcover_[NAME].tif)

Expression: if(A==11,0.525,if(A==14,0.525,if(A==20,0.255,if(A==30,0.255,if(A==40,0.003,if(A==50,0.048,if(A==60,0.048,if(A==70,0.003,if(A==90,0.025,if(A==100,0.048,if(A==110,0.088,if(A==120,0.088,if(A==130,0.100,if(A==140,0.015,if(A==150,0.200,if(A==160,0.280,if(A==170,0.280,if(A==180,0.280,if(A==190,0.000,if(A==200,0.600,if(A==210,0.000,if(A==220,0.000,0.000))))))))))))))))))))))

Output Raster Layer:
Select and define the path for output.
(e.g. 02_09_[NAME].tif)

FURTHER INFORMATION

In this step the C factor (crop/vegetation and management factor) is determined by assigning values to the different land cover classes of the GlobCover data set. The values where derived from specific or averaged values of the table shown in the introduction. The values can vary von 0 to 1 depending on the land cover type. Thick and dense vegetation offers higher protection against erosion and thus has a lower C factor values compared to e.g. bare soil with no protection against erosion and a C factor of 1.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "A*B*C*D", "GRASS_REGION_CELLSIZE_PARAMETER": 149.989396}
.MODE:Normal
.INSTRUCTIONS:In this step the USLE will be calculated out of the R- ,K-, LS- and C-factor.

SETTINGS

Raster Layer A:
Select and define the output of step 02_01.
(02_01_[NAME].tif)

Raster Layer B:
Select and define the output of step 02_02.
(02_02_[NAME].tif)

Raster Layer C:
Select and define the output of step 02_08.
(02_08_[NAME].tif)

Raster Layer D:
Select and define the output of step 02_09.
(02_09_[NAME].tif)

Expression (Formula):
A*B*C*D

GRASS region cell size:
choose LS-factor layer cell size (or set to 150.00)

Output Raster Layer:
Select and define the path for output. (e.g. 02_10_[NAME].tif)

FURTHER INFORMATION

In this step the USLE is calculates by multiplying all four single factors (R, K, LS and C)
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(A==0,0,if(A<=1,1,if(A<=3,2,if(A<=5,3,if(A<=10,4,if(A<=15,5,6))))))", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the USLE soil loss values will be classified.

SETTINGS

Raster Layer A:
Select and define the output of step 02_10.
02_10_[NAME].tif

Expression (Formula): if(A==0,0,if(A<=1,1,if(A<=3,2,if(A<=5,3,if(A<=10,4,if(A<=15,5,6))))))

Classes of soil erosion potential:
0 = No soil erosion (water mask)
1 = very low
2 = low
3 = low to medium
4 = medium to high
5 = high
6 = very high

Output Raster Layer:
Select and define the path for output.
(e.g. 02_11_[NAME].tif)

FURTHER INFORMATION

In this step the derived USLE values will be classified into classes from "very low" to "very high" soil erosion.
!INSTRUCTIONS
