.NAME:Land cover change (image differencing)
.GROUP:PG #04: Medium resolution full basin characterization
.ALGORITHM:otb:multivariatealterationdetector
.PARAMETERS:{"-ram": 128}
.MODE:Normal
.INSTRUCTIONS:This workflow identifies areas of land cover change by taking the difference between any pair of initial state and final state images. The input images may be single-band images of any data type (e.g. spectral bands or feature indices like the NDVI).

Note: For this technique to work, the input images must have the same spatial extent and resolution.

SETTINGS

For "Input Image 1" select the image band representing the initial state, and for "Input Image 2" select the image band representing the final state.

Change Map: 01_Difference_[NAME].tif

FURTHER INFORMATION

As an embedded pre-processing step, the input images are standardized to a zero mean and unit variance.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(A>1 || A<-1,1,0)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step a binary change mask is created from the difference image computed in the previous step.

SETTINGS

Raster Layer A: 01_Difference_[NAME].tif

Formula:
"if(A>XX || A<-XX,1,0)"  where XX should be replaced by the the threshold value.

Output raster layer: 02_Difference_Mask_[NAME].tif

FURTHER INFORMATION

The change image produced using image differencing yields a normal distribution where pixels with no change are distributed around the mean and pixels of change are found at the tails of the distribution.

The mask is computed by image thresholding, where pixel values larger than the specified threshold will be identified as change pixels (value 1) while values below the threshold will have the value 0 and indicating no change. Tresholds are specified in number of standard deviations, and the typical change threshold will be within the range from 1 to 2 standard deviations.
!INSTRUCTIONS
.ALGORITHM:grass:r.neighbors
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0, "-a": false, "method": 2, "-c": false, "size": 3}
.MODE:Normal
.INSTRUCTIONS:In this step, you will apply a modal filter  to smooth out the spectral variability in the binary change mask (i.e. remove isolated pixels).

SETTINGS

Input raster layer:  02_Difference_Mask_[NAME].tif

Neighborhood operation: "Mode"

Neighborhood size: "3"

Output layer:
03_Difference_Mask_Filter_[NAME].tif


FURTHER INFORMATION

The neighborhood operation "mode"  returns the most frequently occurring value in the neighborhood. the larger the neighborhood the more "cleaning" will be performed.

!INSTRUCTIONS
