.NAME:Land cover mapping (unsupervised)
.GROUP:PG #04: Medium resolution full basin characterization
.ALGORITHM:beam:reproject
.PARAMETERS:{"orthorectify": false, "includeTiePointGrids": false, "easting": 99999.9, "elevationModelName": "", "orientation": 0, "pixelSizeY": 99999.9, "pixelSizeX": 99999.9, "noDataValue": 99999.9, "width": 99999, "resampling": 1, "referencePixelX": 99999.9, "referencePixelY": 99999.9, "addDeltaBands": false, "height": 99999, "tileSizeX": 99999, "northing": 99999.9}
.MODE:Normal
.INSTRUCTIONS:This step  transforms the input image from one projection to another, and convert the file to GeoTIFF.

SETTINGS

Select the image product to be reprojected.

Select the Coordinate Reference System (CRS) for the output file. The TIGER-NET default projection is Geographic Coordinate System, WGS84 (i.e. EPSG 4326).

Choose prefered method for resampling (default is "Bilinear")

Select "No" to add delta longitude and latitude bands, the tie-point grids can also be omitted to save disk space.

Specify the output image: 01_Reproject_[NAME].tif

FURTHER INFORMATION

The step is optional but can be used if the required classification output projection is different from the input image projection.






!INSTRUCTIONS
.ALGORITHM:otb:unsupervisedkmeansimageclassification
.PARAMETERS:{"-maxit": 1000, "-ts": 100000, "-ram": 128, "-nc": 50, "-ct": 1e-05}
.MODE:Normal
.INSTRUCTIONS:This step performs K-Means Clustering to partition the data set into spectrally similar subsets.

SETTINGS

Input image: 01_Reproject_[NAME].tif

An optional "Validity Mask" can be specified, and in which case only input image pixels whose corresponding mask value is greater than 0 will be classified. The remaining of pixels will be given the label 0 in the output image.

Set the "Training set size" i.e. number of pixels used to estimate k-means modes (default is 100000)

Set "Number of classes" and define the "Maximum number of iterations". It is recommended to start with a large number of classes (e.g. 50) and subsequently group them into the desired land cover classes. The maximum number of iterations should equally be high (e.g. 1000) to prevent the algorithm from stopping too early.

Specify the convergence threshold for the learning step to limit the K-Means runtime. The algorithm stops when there is no further change in the centroids i.e. difference is less than the convergence threshold.

Finally, specify the location and name of the output classification image (02_KMeans_[NAME].tif).

Optional: Define the Centroid filename to save an output text file containing centroid positions.

FURTHER INFORMATION

The algorithm works by first selecting k locations at random to be the initial centroids for the clusters. Each pixel is then assigned to the cluster which has the nearest centroid, and the centroids are recalculated using the mean value of assigned pixels. The algorithm then repeats this process until the maximum number of iterations is reached or changes between iterations are less than the convergence threshold.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "(A+1)*B", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:This step applies a mask to the k-means classification result generated in the previous step. The step is optional and should only be used in case a Validity Mask was used in the previous step. The step will return an image where valid spectral clusters have the value >=1 while masked areas will have the value 0.

SETTINGS

For "Raster layer A" select the classification produced in the previous step.

For "Raster layer B" select the used Validity Mask.

Insert (A+1)*B as "Formula".

Specify a name and location for the "Output raster layer".
!INSTRUCTIONS
.ALGORITHM:grass:r.reclass
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:This step creates a new map layer whose category values are based upon a reclassification of the categories in an existing raster map layer.

SETTINGS

Select the K-Means classification as input raster map.

Select the text file with the reclassification rules.

Specify a path and filename for the output file (03_Reclass_KMean_[Name].tif)

FURTHER INFORMATION

Before running the reclass algorithm, a text file for reclassifying the clusters into the desired classes must be manually created. The file containing reclass rules is a plain text file with the following format: input_categories=output_category e.g.:
1 2 3   = 1 Land
4 5      = 2 Water
(avoid using 0 as output category)
!INSTRUCTIONS
.ALGORITHM:grass:r.neighbors
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0, "-a": false, "method": 2, "-c": false, "size": 3}
.MODE:Normal
.INSTRUCTIONS:This step applies a modal filter to remove salt and pepper noise to clean up classification results.

SETTINGS

Input raster layer:  03_Kmean_[NAME].tif

Neighborhood operation: "Mode"

Neighborhood size: "3"

Output layer: 04_Filter_Reclass_KMean_[Name].tif

FURTHER INFORMATION

The neighborhood operation "mode"  returns the most frequently occurring value in the neighborhood. the larger the neighborhood the more "cleaning" will be performed.
!INSTRUCTIONS
.ALGORITHM:grass:r.kappa
.PARAMETERS:{"-w": false, "-h": false, "title": "ACCURACY ASSESSMENT"}
.MODE:Normal
.INSTRUCTIONS:If a reference image is available this step can be used to  compute accuracy statistics of your classification. Otherwise click close to finish the Supervised Classification Workflow.

SETTINGS

First, select the input classification results "03_Kmean_Filter_[Name].tif"
and then the associated raster layer with reference classes.

Title for error matrix:
"ACCURACY ASSESSMENT"

Header in the report: "No"

Wide report: "Yes"

Output file: 05_KMeans_Accuracy.txt

FURTHER INFORMATION

This step computes the accuracy of a classification map by comparing a classification result with a reference image.

The step returns a confusion matrix and reports overall accuracy, kappa coefficient as well as errors of commission and omission.

Note that in the error matrix, MAP1 represents the reference and MAP2 the classification result.

!INSTRUCTIONS
