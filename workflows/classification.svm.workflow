.NAME:Land cover mapping (supervised)
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
.ALGORITHM:otb:computeimagessecondorderstatistics
.PARAMETERS:{"-bv": 0}
.MODE:Normal
.INSTRUCTIONS:This step computes a global mean and standard deviation for each band of the input images and saves the results in an XML file.

SETTINGS

Input image: 01_Reproject_[NAME].tif

Choose Background Value i.e. any value which needs to be ignored in the computation of the image statistics (default is "0")

Output XML file: 02_Stats.xml

FURTHER INFORMATION

The output XML file is intended to be used as an input for the training of the SVM classifier to normalize samples before learning.





!INSTRUCTIONS
.ALGORITHM:otb:trainimagesclassifiersvm
.PARAMETERS:{"-classifier.svm.m": 0, "-sample.edg": false, "-classifier": 0, "-classifier.svm.coef0": 0, "-sample.mv": -1, "-classifier.svm.degree": 1, "-sample.mt": -1, "-classifier.svm.c": 1, "-classifier.svm.opt": true, "-classifier.svm.gamma": 1, "-classifier.svm.nu": 0, "-classifier.svm.k": 0, "-sample.vtr": 0.5, "-elev.default": 0, "-sample.vfn": "Class", "-rand": 0}
.MODE:Normal
.INSTRUCTIONS:This step performs training of the SVM classifier by relating the input image to associated training polygon vector data. Training pixel values in each band are scaled using the XML statistics file produced in the previous step.

SETTINGS

Input image list: 01_Reproject_[NAME].tif

Input vector Data List: A polygon vector file with the training areas.

Input XML file: 02_stats.xml

Training and validation sample ratio: 0.5

Name of the discrimination field: "Class" (note this field refers to the coloumn in the training vector attribute table that defines the land cover class associated with each training vector).

SVM Kernel Type:
SVM is generally performed using one of for four basic kernels:
-Linear
-Polynomial (poly)
-Radial Basis Function (rbf)
-Sigmoid
In general, the RBF kernel is a reasonable first choice. This kernel nonlinearly maps the training samples into a higher dimensional space so it, unlike the linear kernel, can handle the case when the relation between class labels and attributes is nonlinear.

Cost parameter C:
To allow some flexibility in separating the classes, SVM models have a cost parameter, "C", that controls the trade off between allowing training errors and forcing rigid margins. There is no general correct range for C why it is suggested to try and run specific kernels with different settings for C (e.g. 1, 10, 100, 1000) to test for the optimal range of C values.

Parameter optimization: "Yes"

Output model: 03_model.svm

!INSTRUCTIONS
.ALGORITHM:otb:imageclassification
.PARAMETERS:{"-ram": 128}
.MODE:Normal
.INSTRUCTIONS:This step performs a SVM classification of the input image by using the SVM model file. Pixels of the output image will contain the class label decided by the SVM classifier.

SETTINGS

Input image: 01_Reproject_[NAME].tif

Input Mask: An optional input image mask can be provided, in which case only input image pixels whose corresponding mask value is greater than 0 will be classified. The remaining  pixels will be given the label 0 in the output image.

Model file: 03_model.svm

Statistics file: 02_stats.xml

Output Image: 04_SVM_[NAME].tif










!INSTRUCTIONS
.ALGORITHM:grass:r.neighbors
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0, "-a": false, "method": 2, "-c": false, "size": 3}
.MODE:Normal
.INSTRUCTIONS:This step applies a modal filter to remove salt and pepper noise to clean up classification results.

SETTINGS

Input raster layer:  04_SVM_[NAME].tif

Neighborhood operation: "Mode"

Neighborhood size: "3"

Output layer: 05_SVM_Filter_[Name].tif

FURTHER INFORMATION

The neighborhood operation "mode"  returns the most frequently occurring value in the neighborhood. the larger the neighborhood the more "cleaning" will be performed.
!INSTRUCTIONS
.ALGORITHM:grass:r.kappa
.PARAMETERS:{"-w": true, "-h": false, "title": "ACCURACY ASSESSMENT"}
.MODE:Normal
.INSTRUCTIONS:If a reference image is available this step can be used to  compute accuracy statistics of your classification. Otherwise click close to finish the Supervised Classification Workflow.

SETTINGS

First, select the input classification results "05_SVM_Filter_[Name].tif"
and then the associated raster layer with reference classes.

Title for error matrix:
"ACCURACY ASSESSMENT"

Header in the report: "No"

Wide report: "Yes"

Output file: 06_SVM_Accuracy.txt

FURTHER INFORMATION

This step computes the accuracy of a classification map by comparing a classification result with a reference image.

The step returns a confusion matrix and reports overall accuracy, kappa coefficient as well as errors of commission and omission.

Note that in the error matrix, MAP1 represents the reference and MAP2 the classification result.

!INSTRUCTIONS
