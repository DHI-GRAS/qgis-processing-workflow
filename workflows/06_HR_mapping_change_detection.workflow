.NAME:06 - HR mapping (change detection)
.GROUP:PG #05: High resolution basin characterization
.ALGORITHM:modeler:hrl_intermediate_lcc_change
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:Within this step, an intermediate land cover change classification is derived to serve as input for the MMU mask identification.

SETTINGS

Input: Past land cover classification:
Select and define the classification result representing your past land cover classification.
(05_01_spot4_2005.tif)

Input: Recent land cover classification:
Select and define the classification result representing your recent land cover classification.
(05_01_spot5_2011.tif)

Output: adapted past LCC:
Select and define the path and name of your adapted (reduce to relevant land cover information) past land cover classification (LCC).
(e.g. 06_01_past_LCC_[NAME].tif)

Output: adapted recent LCC:
Select and define the path and name of your adapted (reduce to relevant land cover information) recent land cover classification (LCC).
(e.g. 06_01_recent_LCC_[NAME].tif)

Output: adapted past LCC 100: (required)
Select and define the path and name of your adapted (reduce to relevant land cover information) past land cover classification (LCC) multiplied by 100.
(e.g. 06_01_past_100_LCC_[NAME].tif)

Output: Intermediate change detection:
(Required)
Select and define the path and name of your intermediate land cover change classification.
(e.g. 06_01_intermediate_LCC_[NAME].tif)

FURTHER INFORMATION

This is done by reducing the area of interest to land cover information of both land cover classification (adapted past/recent LCC).

In a second step, land cover values from the past are multiplied by 100 in order to assess the final land cover change classes (adapted past LCC 100).

Finally, an intermediate land cover change classification is derived (Intermediate change detection). Intermediate in the sense, as this product still has land cover change areas below a defined minimal mapping unit (MMU).
!INSTRUCTIONS
.ALGORITHM:modeler:hrl_mmu_filter
.PARAMETERS:{"NUMBER_FINALMMUPIXELS": 1, "NUMBER_PRELIMINARYMMUHA": 0}
.MODE:Normal
.INSTRUCTIONS:This step identifies isolated changes patches (MMU) which will be neglected in the change detection analyses as they are considered as too small.

SETTINGS

Input: Intermediate change detection:
Select and define the output of the previous step.
(06_01_intermediate_LCC_[NAME].tif)

Preliminary MMU (ha):
Select and define the preliminary MMU in hectares (ha) for which the MMU (Pixels) identification will take place.

Final MMU (Pixels):
Select and define here the amount of pixels and the related area which will finally represent the isolated changes patches (MMU).

Output: MMU filter mask
Select and define here the output for the MMU filter mask.
(e.g. 06_02_MMU_filter_mask_[NAME].tif)

FURTHER INFORMATION:

The final filter mask is coded with 1 and 2 values where 2 stands for areas having been identified as changes being below the defined area (Pixels).
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(A==100 && B==2,101,if(A==200 && B==2,202,if(A==300 && B==2,303,if(A==400 && B==2,404,if(A==500 && B==2,505,if(A==600 && B==2,606,if(A==700 && B==2,707,if(A==800 && B==2,808,if(A==900 && B==2,909,if(A==1000 && B==2,1010,if(A==1100 && B==2,1111,if(A==1200 && B==2,1212,if(A==1400 && B==2,1414,if(A==1500 && B==2,1515,0))))))))))))))", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:Within this step, a kind of interim change detection layer is derived defining no change within derived MMU filter mask when comparing past to recent as they are considered as too small.

SETTINGS

Raster Layer A:
Select and define the adapted past layer multiplied by 100 out of step 1.
(06_01_past_100_LCC_[NAME].tif)

Raster Layer B:
Select and define the MMU filter mask having been derived in the previous step 2.
(06_02_MMU_filter_mask_[NAME].tif)

Expression (Formula)
(If considering 15 Land cover classes - to be adjusted if necessary):
if(A==100 && B==2,101,if(A==200 && B==2,202,if(A==300 && B==2,303,if(A==400 && B==2,404,if(A==500 && B==2,505,if(A==600 && B==2,606,if(A==700 && B==2,707,if(A==800 && B==2,808,if(A==900 && B==2,909,if(A==1000 && B==2,1010,if(A==1100 && B==2,1111,if(A==1200 && B==2,1212,if(A==1400 && B==2,1414,if(A==1500 && B==2,1515,0))))))))))))))

Output Raster Layer:
Select and define the output of the interim change detection layer representing no changes within the derived MMU filter mask.
(e.g. 06_03_[NAME].tif)

FURTHER INFORMATION:

This step is conscious left in the workflow as the formula has to be adjusted according to the derived land cover classes of previous steps.

The statement in the formula can be interpreted as followed, e.g. A==100 && B==2,101, if the past land cover class (A) was labelled with the value 1 (100 as it was multiplied by 100) and the MMU filter mask is 2 (represent an MMU to be considered), the final change value is set to 101, defining no changes for past as well as recent land cover.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "\"if(B==2,C,if(B==1,A,0))\"", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:Within this step, the final land cover change is derived while neglecting changes identified by MMU filter mask.

SETTINGS

Raster Layer A:
Select and define here the output of step 1.
(06_01_intermediate_LCC_[NAME].tif)

Raster Layer B:
Select and define here the output of step 2 representing the MMU filter mask.
(06_02_MMU_filter_mask_[NAME].tif)

Raster Layer C:
Select and define here the output of step 3 representing no change values for areas having been identified by the MMU filter mask.
(06_03_[NAME].tif)

Expression (Formula):
if(B==2,C,if(B==1,A,0))

Output Raster Layer:
Select and define here the output of the change detection representing defining changes from past to recent.
(e.g. 06_04_[NAME].tif)
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "\"if(A==101,1,if(A==202,1,if(A==303,1,if(A==404,1,if(A==505,1,if(A==606,1,if(A==707,1,if(A==808,1,if(A==909,1,if(A==1010,1,if(A==1111,1,if(A==1212,1,if(A==1313,1,if(A==1414,1,if(A==1515,1,if(A>0,2,0))))))))))))))))\"", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:This step is optional and provides you a final change mask, coded with the value 2 if changes occurred and 1 for areas, where no changes took place

SETTINGS

Raster Layer A:
Select and define the change detection layer having been derived in step 4.
(06_04_[NAME].tif)

Expression (Formula):
if(A==101,1,if(A==202,1,if(A==303,1,if(A==404,1,if(A==505,1,if(A==606,1,if(A==707,1,if(A==808,1,if(A==909,1,if(A==1010,1,if(A==1111,1,if(A==1212,1,if(A==1313,1,if(A==1414,1,if(A==1515,1,if(A>0,2,0))))))))))))))))

Output Raster Layer:
Select and define the output of your final change mask.
(e.g. 06_05_[NAME].tif)

FURTHER INFORMATION:

As in step 3, the formula has to be adapted according to the considered land cover classes. It can be interpreted as followed, if Raster value A is coded by 101 (meaning that no change occurred from past to recent) the output is coded as 1. if not, it is coded as 2. The final derived mask is therefore code with 1 and 2 values, representing no changes and changes respectively.
!INSTRUCTIONS
