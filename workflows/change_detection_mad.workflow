.NAME:Land cover change (MAD/MAF)
.GROUP:PG #04: Medium resolution full basin characterization
.ALGORITHM:otb:multivariatealterationdetector
.PARAMETERS:{"-ram": 128}
.MODE:Normal
.INSTRUCTIONS:This application detects change between two given multi-spectral images based on Multivariate Alteration Detection (MAD), and Maximum Autocorrelation Factor (MAF) analyses.

SETTINGS

For "Input Image 1" select the image band representing the initial state, and for "Input Image 2" select the image band representing the final state.

Note: For this technique to work, the input images must have the same spatial extent and resolution.

Change Map: 01_MAD_[NAME].tif

FURTHER INFORMATION

MAD takes two images as inputs and produces a set of N change maps as a vector image (where N is the maximum number of bands in the first and second image). This is a statistical method which can handle different modalities (e.g. differences in offset and gain settings and/or radiometric and atmospheric correction schemes) and even different bands and number of bands between images. If numbers of bands in image 1 and 2 are equal, then change maps are sorted by increasing correlation (i.e. maximum change information is retained in the first MAD components with increasing levels of noise in the higher-order MADs). If the number of bands is different, the change maps are sorted by decreasing correlation.
!INSTRUCTIONS
.ALGORITHM:otb:dimensionalityreductionmaf
.PARAMETERS:{"-normalize": true, "-method": 0, "-nbcomp": 0}
.MODE:Normal
.INSTRUCTIONS:The Maximum Autocorrelation Factor (MAF) can be considered as a spatial extension of the MAD, in which new variates try to maximize auto-correlation between neighbouring pixels instead of variance.

SETTINGS

Input Image:  01_MAD_[NAME].tif

Algorithm: "maf"

Number of components: "0"

Normalize: "Yes"

Output Image:
02_MAD_MAF_[NAME].tif

FURTHER INFORMATION

Because the MAFs preserve the spatial structure in the data, taken the MAFs of the MADs provide a way to retain the spatial context of neighbourhood pixels in the resulting change images.
!INSTRUCTIONS
.ALGORITHM:otb:splitimage
.PARAMETERS:{"-ram": 128}
.MODE:Normal
.INSTRUCTIONS:This step splits the MAD/MAFs components into single files for easier inspection and reclassification into change and no-change.

SETTINGS

Input Image:  02_MAD_MAF_[NAME].tif

Output Image:
"03_MAD_MAF_[NAME].tif"

FURTHER INFORMATION

The individual MAD/MAFs images generated from the split routine will be autamtically numbered and should afterwards be inspected to identify th eimage or those images with the most change information
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(A>1 || A<-1,1,0)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:This step creates a binary change mask from the reclassified MAD/MAF component.

SETTINGS

Raster Layer A: 03_MAD_MAF_[NAME]_n.tif
where n refers to the number of the component with most change information

Formula:
"if(A>XX || A<-XX,1,0)"  where XX should be replaced by the the threshold value.

Output raster layer: 04_MAD_MAF_Mask_[NAME].tif

FURTHER INFORMATION

The change image produced using image differencing yields a normal distribution where pixels with no change are distributed around the mean and pixels of change are found at the tails of the distribution.

The mask is computed by image thresholding, where pixel values larger than the specified threshold will be identified as change pixels (value 1) while values below the threshold will have the value 0 and indicating no change. Tresholds are specified in number of standard deviations, and the typical change threshold will be within the range from 1 to 2 standard deviations.

!INSTRUCTIONS
.ALGORITHM:grass:r.neighbors
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0, "-a": false, "method": 2, "-c": false, "size": 3}
.MODE:Normal
.INSTRUCTIONS:In this step a modal filter  will be applied to smooth out the spectral variability in the binary change mask (i.e. remove isolated pixels).

SETTINGS

Input raster layer:  04_MAD_MAF_Mask_[NAME].tif

Neighborhood operation: "Mode"

Neighborhood size: "3"

Output layer:
05_MAD_MAF_Mask_Filter_[NAME].tif

FURTHER INFORMATION

The neighborhood operation "mode"  returns the most frequently occurring value in the neighborhood. the larger the neighborhood the more "cleaning" will be performed.
!INSTRUCTIONS
