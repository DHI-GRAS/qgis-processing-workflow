.NAME:02 - Main Processing 02, permanent water extraction
.GROUP:PG #11: Long-term and seasonal variation of wetland areas
.ALGORITHM:gdalogr:merge
.PARAMETERS:{"PCT": false, "SEPARATE": true}
.MODE:Normal
.INSTRUCTIONS:In this step a layer stack will be calculated of all water images.

SETTINGS

Input Layers:
Select and define all available water mask images.
(02_01_03_[NAME].tif)

Parameters:
Layer stack = Yes

Output Layer:
Select and define the path for output.
(e.g. 02_02_01_[NAME].tif)

FURTHER INFORMATION

Within this step, a layer stack of all water images is being created.
!INSTRUCTIONS
.ALGORITHM:otb:bandmath
.PARAMETERS:{"-ram": 128, "-exp": "im1b1+im1b2+im1b3+im1b4+im1b5+im1b6+im1b7+im1b8+im1b9+im1b10+im1b11+im1b12+im1b13+im1b14+im1b15+im1b16+im1b17"}
.MODE:Normal
.INSTRUCTIONS:In this step the layer stack will calculate to derive a raster file.

SETTINGS

Input Image List:
Select and define the output of step 02_02_01.
(02_02_01_[NAME].tif)

Expression: im1b1+im1b2+im1b3+im1b4+im1b5+im1b6+im1b7+im1b8+im1b9+im1b10+im1b11+im1b12+im1b13+im1b14+im1b15+im1b16+im1b17

Output Image:
Select and define the path for output.
(e.g. 02_02_02_[NAME].tif)

FURTHER INFORMATION

The layer stack sum is calculated to derive a raster file which shows how often a pixel is classified as water.
!INSTRUCTIONS
.ALGORITHM:gdalogr:merge
.PARAMETERS:{"PCT": false, "SEPARATE": true}
.MODE:Normal
.INSTRUCTIONS:In this step a layer stack of all cloud mask images will be created.

SETTINGS

Input Layer:
Select and define the output of step 01_02.
(01_02_[NAME]_m.tif)

Parameters:
Layer stack = Yes

Output Layer:
Select and define the path for output.
(e.g. 02_02_03_[NAME].tif)

FURTHER INFORMATION

This step creates a layer stack of all cloud mask images.
!INSTRUCTIONS
.ALGORITHM:otb:bandmath
.PARAMETERS:{"-ram": 128, "-exp": "if(im1b1==2,1,0)+if(im1b2==2,1,0)+if(im1b3==2,1,0)+if(im1b4==2,1,0)+if(im1b5==2,1,0)+if(im1b6==2,1,0)+if(im1b7==2,1,0)+if(im1b8==2,1,0)+if(im1b9==1,1,0)+if(im1b10==2,1,0)+if(im1b11==2,1,0)+if(im1b12==2,1,0)+if(im1b13==2,1,0)+if(im1b14==2,1,0)+if(im1b15==2,1,0)+if(im1b16==2,1,0)+if(im1b17==2,1,0)"}
.MODE:Normal
.INSTRUCTIONS:In this step the calculate layer stack sum will be needed to derive a raster file to show how often an image information is available.

SETTINGS

Input Image List:
Select and define the output of step 02_02_03.
(02_02_03_[NAME].tif)

Expression: if(im1b1==2,1,0)+if(im1b2==2,1,0)+if(im1b3==2,1,0)+if(im1b4==2,1,0)+if(im1b5==2,1,0)+if(im1b6==2,1,0)+if(im1b7==2,1,0)+if(im1b8==2,1,0)+if(im1b9==1,1,0)+if(im1b10==2,1,0)+if(im1b11==2,1,0)+if(im1b12==2,1,0)+if(im1b13==2,1,0)+if(im1b14==2,1,0)+if(im1b15==2,1,0)+if(im1b16==2,1,0)+if(im1b17==2,1,0)

Output Image:
Select and define the path for output.
(e.g. 02_02_04_[NAME].tif)

FURTHER INFORMATION

The layer stack sum of all pixels that have the value 2 is calculated to derive a raster file which shows how often image information are available for each pixel. This means how often is a pixel not covered by clouds.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if((A>=8 && B>=8),1,0)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the calculated layer stack sum image from step 4 will be needed to derive the permanent water mask.

SETTINGS

Raster Layer A:
Select and define the output of step 02_02_02.
(02_02_02_[NAME].tif)

Raster Layer B:
Select and define the output of step 02_02_04.
(02_02_04_[NAME].tif)

Expression (Formula):
if((A>=8 && B>=8),1,0)

Output Raster Layer:
Select and define the path for output.
(e.g. 02_02_05_[NAME].tif)

FURTHER INFORMATION

This step uses the previously calculated layer stack sum images to derive the permanent water mask. This is done by classifying these areas as permanent water which are covered by water more often than 7 times and also have image information more often than 7 times within the whole period. This number has to be adjusted depending on the number of available images. For more than 17 input images the number has to be raised and for less than 17 it has to be lowered.
!INSTRUCTIONS
