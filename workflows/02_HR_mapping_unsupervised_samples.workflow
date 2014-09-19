.NAME:02 - HR mapping (unsupervised samples generation)
.GROUP:PG #05: High resolution basin characterization
.ALGORITHM:otb:unsupervisedkmeansimageclassification
.PARAMETERS:{"-maxit": 1000, "-ts": 100, "-ram": 128, "-nc": 5, "-ct": 0.0001}
.MODE:Normal
.INSTRUCTIONS:Perform an unsupervised KMeans image classification. After a cleaning and interpretation procedure, this output will provide samples to be used for supervised classification.

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

Output Image - Required
Select and define the path for output.
(e.g. 02_01_[NAME].tif)

Centroid filename - Optional:
Define the Centroid filename to save an output text file containing centroid positions.
(e.g. 02_01_[NAME].txt)
!INSTRUCTIONS
.ALGORITHM:grass:r.reclass.area.greater
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0, "greater": 1}
.MODE:Normal
.INSTRUCTIONS:In this step, only KMeans cluster above a define "Area threshold [hectares]" will be used to associate them afterwards to given land cover types. 
The step helps to reduce the considered samples to meaningful and representative land cover types.

SETTINGS

Input Raster Layer:
Select and define the unsupervised KMeans image classification derived in step 1.
(02_01_[NAME].tif)

Area threshold (ha):
Define the area treshold to be considered. The output will be KMeans cluster above the defined treshold. Try and test with higher values in order to compare the results with the Satellite Image and assuring "representative" coverage of land cover types (e.g. build-up, water, etc.).

Output Raster Layer:
Select and define the path for output.
(e.g. 02_02_[NAME].tif)
!INSTRUCTIONS
.ALGORITHM:grass:r.reclass
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:Reclassify the cleaned unsupervised KMeans classification to a new map layer whose categories (values) represent existing land cover types. The categories will represent your samples, to be considered for the upcoming supervised classification.

In order to run this reclass algorithm, a text file for reclassifying the KMeans clusters into the desired land cover classes must be manually created. The file containing reclass rules is a plain text file with the following format: input_categories=output_category e.g.:
1 2 3 = 1 Land
4 5 = 2 Water

Note: Only representative samples should be used and therefore clearly associable land cover types. However for the SVM classification, training with pixels that lie close to where the hyperplane is to be fitted should be considered, hence in the region in which mixtures of the classes occurs. Avoid to associate "input_categories" to "output_category" if too much conflict with other land cover types is given (e.g. conflict with build-up, agricultural and bare soil). If this persist, associate the "output_category" code 0 to this "input_categories" in order to neglect this in the samples generation.

SETTINGS

Input Raster Layer:
Select the reduced KMeans cluster derived in step 2.
(02_02_[NAME].tif)

File containing reclass rules:
Select the text file with the reclassification rules. KMeans cluster and associated land cover categories. Label unclear association with the code 0.

Output Raster Layer:
Select and define the path for output.
(e.g. 02_03_[NAME].tif)
!INSTRUCTIONS
.ALGORITHM:modeler:hrl_samples_extraction
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:Convert the reclassified cleaned KMeans cluster (step 3) into vector file (samples) to be used for the supervised classification.

SETTINGS

Input:
Define here the output of step 3, the reclassified, cleaned unsupervised KMeans classification.
(02_03_[NAME].tif)

Output: Samples:
Select and define the path for output.
(e.g. 02_04_[NAME].shp)


FURTHER INFORMATION

The here extracted samples from the unsupervised KMeans classification represent samples to be derived in an automatic way. However they do not always cover all desired land cover types and have therefore to be complemented by manually defined samples. In this case you can add to this outcome manually digitized samples in order to enrich this outcome. The SVM classificer also rather prefers training samples with pixels that lie close to where the hyperplane is to be fitted, hence in the region in which mixtures of the classes occurs and which is somehow difficlut to derive by this way of automatic sample generation. 
The considered workflow (02 - HR mapping (unsupervised samples generation) represents an automatic way to derive samples for a supervised classification. This doesn’t however mean that these can be also defined completely manually, or that the outcome of this workflow can be adapted by deleting or adding additional samples.
The finally considered samples represents an important key parameter for the upcoming supervised classification. In the ideal case they should cover as much as possible spectral deviation of the land cover types and be homogeneous distributed over the area.
!INSTRUCTIONS
