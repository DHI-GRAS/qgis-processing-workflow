.NAME:02 - Main Processing 01, water_masking
.GROUP:PG #11: Long-term and seasonal variation of wetland areas
.ALGORITHM:modeler:wetlands_07_water_masking_part1
.PARAMETERS:{}
.MODE:Batch
.INSTRUCTIONS:In this step a model will be executed. It will be needed for masking water areas.

SETTINGS

Input (Combined Indices):
Select and define output of step 01_03.
(01_03_[NAME]_CI.tif)

Output (1rst Iteration):
Select and define the path for output.
(e.g. 02_01_01_[NAME].tif)

FURTHER INFORMATION

This first step will execute a model which will mask water areas using a threshold. Additionally it includes a clump and sieve to remove small patches (pixel) of water area which have a high probability of misclassification.
!INSTRUCTIONS
.ALGORITHM:grass:r.mfilter.fp
.PARAMETERS:{"repeat": 1, "GRASS_REGION_CELLSIZE_PARAMETER": 0, "-z": false}
.MODE:Batch
.INSTRUCTIONS:In this step a boundary will be generated around all water areas.

SETTINGS

Input Layer:
Select and define output of step 02_01_01.
(02_01_01_[NAME].tif)

Filter File:
Select and define the map_matrix.txt file provided within the training_data folder.
(map_matrix.txt)

See user manual for further explanations regarding filter files.

Output Layer:
Select and define the path for output.
(e.g. 02_01_02_[NAME].tif)

FURTHER INFORMATION

This step is used to generate a boundary around all water areas. This boundary will be used to apply a higher threshold for water classification within these areas. This method will be used to classify the border of water areas. The border of water areas is mostly characterized by a transition of land cover, which would require a higher threshold to be classified as water. To reduce the overestimation of water areas this threshold is only applied to these boundary areas.
This process is done in a separate processing step as it cannot be included in a sextant model.
!INSTRUCTIONS
.ALGORITHM:modeler:wetlands_07_water_masking_part2
.PARAMETERS:{}
.MODE:Batch
.INSTRUCTIONS:In this step a higher threshold will be applied to all boarder areas.

SETTINGS

Input: Output Step 1
Select and define output from step 02_01_01.
(02_01_01_[NAME].tif)

Input: Output Step 2
Select and define output from step 02_01_02.
(02_01_02_[NAME].tif)

Input: Combined Indices:
Select and define output of step 01_03.
(01_03_[NAME]_CI.tif)

Output: Water Mask Image:
Select and define the path for output.
(e.g. 02_01_03_[NAME].tif)

FURTHER INFORMATION

As described in the previous step, a higher threshold will be applied to all boarder areas. Then the newly classified areas will be merged with the previously classified water areas and finally a clump and sieve will remove small water pixels which are below the MMU.
!INSTRUCTIONS
