.NAME:02 - Main Processing 03, wet season wetland extraction
.GROUP:PG #11: Long-term and seasonal variation of wetland areas
.ALGORITHM:gdalogr:merge
.PARAMETERS:{"PCT": false, "SEPARATE": true}
.MODE:Normal
.INSTRUCTIONS:In this step we will create a layer stack of all water images of one wet season in the year x.

SETTINGS

Input Layers:
Select and define output form step 02_01_03.
(02_01_03_[NAME].tif)

Parameter:
Layer stack = Yes

Output Layer:
Select and define path for output.
(e.g. 02_03_01_[NAME].tif)

FURTHER INFORMATION

This step creates a layer stack of all water images of one wet season. In this case we use the wet season 2005.
!INSTRUCTIONS
.ALGORITHM:otb:bandmath
.PARAMETERS:{"-ram": 128, "-exp": "im1b1+im1b2+im1b3+im1b4"}
.MODE:Normal
.INSTRUCTIONS:In this step we want to analyse how often a pixel will be classified as water. The result should be a calculated layer stack sum.

SETTINGS

Input Image List:
Select and define output from step 02_03_01.
(02_03_01_[NAME].tif)

Expression:
(Adjust if needed)
im1b1+im1b2+im1b3+...+im1bn

In this case:
n=number of band (water mask images)

Output Image:
Select and define path for output.
(e.g. 02_03_02_[NAME].tif)

FURTHER INFORMATION

The layer stack sum is calculated to derive a raster file which shows how often a pixel is classified as water.
!INSTRUCTIONS
.ALGORITHM:gdalogr:merge
.PARAMETERS:{"PCT": false, "SEPARATE": true}
.MODE:Normal
.INSTRUCTIONS:In this step we want summarise all cloud mask images of one wet season in the year x.

SETTINGS

Input Layers:
Select and define n cloud mask images for year x.
(01_02_[NAME]_m.tif)

In this case:
n = number of images

Layer stack:
Yes

Output Layer:
Select and define path for output.
(e.g. 02_03_03_[NAME].tif)

FURTHER INFORMATION

This step creates a layer stack of all cloud mask images of one wet season.
!INSTRUCTIONS
.ALGORITHM:otb:bandmath
.PARAMETERS:{"-ram": 128, "-exp": "if(im1b1==2,1,0)+if(im1b2==2,1,0)+if(im1b3==2,1,0)+if(im1b4==2,1,0)"}
.MODE:Normal
.INSTRUCTIONS:In this step we will made a derivation of a raster file, which will show how often image information during the wet season is available.

SETTINGS

Input Image List:
Select and define cloud mask layer stack. (02_03_03_[NAME].tif)

Expression: if(im1b1==2,1,0)+if(im1b2==2,1,0)+if(im1b3==2,1,0)+if(im1b4==2,1,0)+...+if(im1bn==2,1,0)

In this case:
n=number of band (equal to number of water mask images)

Output Image:
Select and define path for output.
(e.g. 02_03_04_[NAME].tif)

FURTHER INFORMATION

The layer stack sum of all pixels that have the value 1 is calculated to derive a raster file which shows how often image information during the wet season is available for each pixel. This means how often is a pixel not covered by clouds.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if((A>=2 && B>=1),2,10)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the wetlands area mask will be reviewed to know the correctly detected presense of wetlands.

SETTINGS

Raster Layer A:
Select and define the cloud mask sum image of output 02_03_04.
(02_03_04_[NAME].tif)

Raster Layer B:
Select and define the water mask sum image of output 02_03_02.
(02_03_02_[NAME].tif)

Expression (Formula):
if((A>=2 && B>=1),2,10)

Output Raster Layer:
(e.g. 02_03_05_[NAME].tif)

FURTHER INFORMATION

This step uses the previously calculated layer stack sum images to derive the wetlands area mask. In order to correctly detect presence of wetlands, at least 2 times image information has to be given with one or more often water coverage. This is done by classifying these areas as wetland which are covered by water once or more times and in addition, has image information more often than 2 times within the whole period. These values have to be adopted depending on the available images.
!INSTRUCTIONS
