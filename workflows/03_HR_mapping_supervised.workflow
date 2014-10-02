.NAME:03 - HR mapping (supervised classification)
.GROUP:PG #05: High resolution basin characterization
.ALGORITHM:otb:computeimagessecondorderstatistics
.PARAMETERS:{"-bv": 0}
.MODE:Normal
.INSTRUCTIONS:In this step, a global mean and standard deviation for each band of the input images is being computed and saved as results in an XML file. The output XML file is intended to be used as an input for the training of the SVM classifier to normalize samples before learning.

SETTINGS

Input Images:
Select and define your satellite image.

Output XML file:
Select and define the path for output.
(e.g. 03_01_[NAME].xml)
!INSTRUCTIONS
.ALGORITHM:otb:trainimagesclassifiersvm
.PARAMETERS:{"-classifier.svm.m": 0, "-sample.edg": true, "-classifier": 0, "-classifier.svm.coef0": 0, "-sample.mv": 1000, "-classifier.svm.degree": 1, "-sample.mt": 1000, "-classifier.svm.c": 1, "-classifier.svm.opt": true, "-classifier.svm.gamma": 1, "-classifier.svm.nu": 0, "-classifier.svm.k": 0, "-sample.vtr": 0.5, "-elev.default": 0, "-sample.vfn": "value", "-rand": 0}
.MODE:Normal
.INSTRUCTIONS:In this step, SVM classifier training is being derived from an input image and associated training polygon vector data. Training pixel values in each band are scaled using the XML statistics file produced in the previous step.

SETTINGS

Input Image List:
Select the image to be used for SVM training.
(Satellite image for which statistics were computed in the previous step)

Input Vector Data List:
Select the polygon vector file with the training areas.

Input XML image statistics file:
Select the statistics file having been created in the previous step.
(03_01_[NAME].xml)

Training and validation sample ratio:
Keep "training and validation sample ratio" as "0.5"

Name of the discrimination field:
Use "value" as the "name of the discrimination field".

(Note: this field refers to the column in the training vector attribute table that defines the land cover class associated with each training vector. It has to be defined accordingly in case of changes within the attribute field).

Classifier to use for the training:
Select and define "svm".

SVM kernel type:
SVM is generally performed using one of four basic kernels:
-Linear
-Polynomial (poly)
-Radial Basis Function (rbf)
-Sigmoid

In general, the RBF kernel is a reasonable first choice. This kernel nonlinearly maps the training samples into a higher dimensional space so it, unlike the linear kernel, can handle the case when the relation between class labels and attributes is nonlinear.

Cost parameter C:
To allow some flexibility in separating the classes, SVM models have a cost parameter, C, that controls the trade-off between allowing training errors and forcing rigid margins. There is no general correct range for C why it is suggested to try and run specific kernels with different settings for C (e.g. 1, 10, 100, 1000) to test for the optimal range of C values.

Parameter optimization:
Yes

Output Model:
Select and define the path for output.
(e.g. 03_02_[NAME].svm)
!INSTRUCTIONS
.ALGORITHM:otb:imageclassification
.PARAMETERS:{"-ram": 128}
.MODE:Normal
.INSTRUCTIONS:In this step, a SVM classification of the input image is derived by using the SVM model file. Pixels of the output image will contain the class label conducted by the SVM classifier.

SETTINGS

Input Image:
Select the satellite image based on which the classification shall be derived. (Input image of step 1)

Model File:
Select the SVM model file (*.svm) having been derived in step 2.
(03_02_[NAME].svm)

Statistic File:
Select the statistics file having been calculated in step 1.
(03_01_[NAME].xml)

Output Image:
Select and define the path for output.
(e.g. 03_03_[NAME].tif)

FURTHER INFORMATION

An optional input mask can be considered, in which case only input image pixels whose corresponding mask value is greater than 0 are classified. The remaining pixels are labelled by the value 0 in the classification output image.
!INSTRUCTIONS
