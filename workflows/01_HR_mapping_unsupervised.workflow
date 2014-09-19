.NAME:01 - HR mapping (unsupervised classification)
.GROUP:PG #05: High resolution basin characterization
.ALGORITHM:otb:unsupervisedkmeansimageclassification
.PARAMETERS:{"-maxit": 1000, "-ts": 100, "-ram": 128, "-nc": 5, "-ct": 0.0001}
.MODE:Normal
.INSTRUCTIONS:Perform an unsupervised KMeans image classification

SETTINGS

Input Image - Required:
Define the Satellite Image to be used for unsupervised KMeans image classification.

Validity Mask - Optional:
An optional "Validity Mask" can be specified, and in which case only input image pixels whose corresponding mask value is greater than 0 will be classified. The remaining of pixels will be given the label 0 in the output image.

Training set size - Optional:
Define the number of pixels used to estimate k-means modes.

Number of classes - Required:
Define the number of classes (e.g. 40) and adjust them, if necessary to higher classes, in order to associate them afterwards to desired land cover classes.

Maximum number of iterations - Optional:
Define the number of iterations. The maximum number of iterations should equally be high (e.g. 1000) to prevent the algorithm from stopping too early.

Convergence threshold - Optional:
Specify the convergence threshold for the learning step to limit the K-Means runtime. The algorithm stops when there is no further change in the centroids (difference is less than the convergence threshold).

Output Image - Required.
Select and define the path for output. (e.g. 01_01_[NAME].tif)

Centroid filename - Optional:
Define the Centroid filename to save an output text file containing centroid positions.
(e.g. 01_01_[NAME].txt)
!INSTRUCTIONS
.ALGORITHM:grass:r.reclass
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:Reclassify the unsupervised KMeans classification to a new map layer whose categories (values) represent existing land cover types.

In order to run this reclass algorithm, a text file for reclassifying the KMeans clusters into the desired land cover classes must be manually created. The file containing reclass rules is a plain text file with the following format: input_categories=output_category e.g.:
1 2 3 = 1 Land
4 5 = 2 Water
(avoid using 0 as output category)

SETTINGS

Input Raster Layer:
Select the Unsupervised KMeans classification derived in step 1.
(01_02_[NAME].tif)

File containing reclass rules:
Select the text file with the reclassification rules, KMeans cluster and associated land cover categories.

Output Raster Layer:
Specify a path and filename of the unsupervised land cover classification. (e.g. 01_02_[NAME].tif)
!INSTRUCTIONS
