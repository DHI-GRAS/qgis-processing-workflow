.NAME:05 - HR mapping (postprocessing)
.GROUP:PG #05: High resolution basin characterization
.ALGORITHM:grass:r.neighbors
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0, "-a": false, "method": 2, "-c": false, "size": 3}
.MODE:Normal
.INSTRUCTIONS:Within this step, salt and pepper effects/noise from the pixel based classification is removed by cleaning the initial classification with a moving window approach.

SETTINGS

Input Raster Layer:
Select and define the input classification image to be post-processed.
(04_02_[NAME].tif)

Neighbourhood Operation:
Choose "mode" in order to consider the most frequently occurring value in the neighbourhood.

Neighbourhood Size:
Select and define the size of the moving window. As example 3, defining a window of 3 by 3 pixels.

Use circular neighbourhood:
Select and define if to consider circular neighbourhood or not.

Output Layer:
Finally, specify the location and name of the output classification image.
(e.g. 05_01_[NAME].tif)

FURTHER INFORMATION:

This steps refers usually to a kind of post-processing operation, where you adjust and optimize your classification result at the end by referring to a filter, elimination salt and pepper effects of your classification. Note that this is no more necessary if you’re previously considered the "hybrid" classification approach. Here you already smoothed the classification by considering the mode operation related to the derived segments.
!INSTRUCTIONS
.ALGORITHM:grass:r.kappa
.PARAMETERS:{"-w": true, "-h": false, "title": "ACCURACY ASSESSMENT"}
.MODE:Normal
.INSTRUCTIONS:At the end of each classification, accuracy should be derived in order to assess objective statistic information describing the quality of your classification. This is usually done by comparing a classification result with a reference image. Within this step, a confusion matrix is calculated, reporting overall accuracy, kappa coefficient as well as errors of commission and omission.

Note that you can only derive accuracy statistics of your classification if you have a reference image. If not, you have to skip this step.

SETTINGS

Raster layer containing classification result:
Select and define the input classification image.
(05_01_[NAME].tif)

Raster layer containing reference classes:
Select and define the raster layer containing the reference image information. (Note that this raster layer must reflect the same class codes as your input classification image) 

Title for error matrix and kappa:
Choose a title for the error Matrix (default is "ACCURACY ASSESSMENT")

No header in the report:
Select "No" in order to consider header information in the report.

Wide report (132 columns):
Choose "yes" to generate a "Wide report".

Output file containing error matrix and kappa:
Finally, specify the location and name of the error matrix and kappa file.
(e.g. 05_02_Accuracy_[NAME].txt)

FURTHER INFORMATION

Note that in the error matrix, MAP1 represents the reference and MAP2 the classification result.
!INSTRUCTIONS
