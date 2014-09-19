.NAME:03 - Post-processing
.GROUP:PG #11: Long-term and seasonal variation of wetland areas
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(A==1,1,if((A!=1 && B==2),2,if(C>=2,3,0)))", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the permanent water bodies will cut into the wetlands area mask.

SETTINGS

Raster Layer A:
Select and define the permanent water bodies of step 02_02_05.
(02_02_05_[NAME].tif)

Raster Layer B:
Select and define the seasonal wetlands of step 02_03_05.
(02_03_05_[NAME].tif)

Raster Layer C:
Select and define the seasonal cloud mask sum image of step 02_03_04.
(02_03_04_[ANME].tif)

Expression (Formula):
if(A==1,1,if((A!=1 && B==2),2,if(C>=2,3,0)))

Output Raster Layer:
Select and define the path for output.
(e.g. 03_01_[NAME].tif)

FURTHER INFORMATION

This workflow will cut the permanent water bodies into the wetlands area mask. This workflow has only one single step.
!INSTRUCTIONS
