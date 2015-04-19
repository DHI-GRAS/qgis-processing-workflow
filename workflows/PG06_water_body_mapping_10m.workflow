.NAME:Water body mapping - radar based
.GROUP:PG #06: Water body mapping
.ALGORITHM:s1tbx:applyorbitfile
.PARAMETERS:{"orbitType": 0}
.MODE:Normal
.INSTRUCTIONS:The first step of radar processing consists of retrieving precise orbit information on the exact position of the satellite during the acquisition of the image.

SETTINGS

Input image:
Select an image to process.

Orbit type:
Select and define the Orbit type of your considered Input Image. In case of a Sentinel-1 scene select and define:
Sentinel Precise (Auto Download)

Output Image:
The output file must be in *.dim format. Uncheck the "Open output file" option as QGIS cannot read DIM files. (e.g. 01_OrbitFile_[NAME].dim)

FURTHER INFORMATION

Note that the image format of a Sentinel-1 scene refers to "*.safe" and that the processing of a whole scene is quite time demanding.
!INSTRUCTIONS
.ALGORITHM:s1tbx:calibration
.PARAMETERS:{"!sourceBands>band": "", "createBetaBand": false, "outputImageScaleInDb": false, "createGammaBand": false, "auxFile": 0}
.MODE:Normal
.INSTRUCTIONS:Level 1 radar data have to be calibrated to convert digital pixel values to radiometrically calibrated backscatter.

SETTINGS

Input image:
Select an define the previously processed (Step1: Apply Orbit File) image (*.dim) as "Input image" and choose the "Amplitude_XX" band for processing. (e.g. 01_OrbitFile_[NAME].dim)

The list of source bands:
Copy and paste the chosen band name here "Amplitude_XX".

The auxiliary file:
This is only useful for ASAR.

Output Image:
The output file has to be in *.dim format. Switch "Open output file" off as QGIS cannot read DIM files. (e.g. 02_Calibration_[NAME].dim)

FURTHER INFORMATION

Note that when referring to advance parameters you can also define and produce Beta or Gamma band information as well rescaling the image to Db. The rescaling to Db doesn’t work so far with Sentinel-1 data, however with e.g. ASAR. In case of using ASAR, thick the "Output image scale in Db" and skip step 3 (Linear to dB).
!INSTRUCTIONS
.ALGORITHM:s1tbx:lineartodb
.PARAMETERS:{"!sourceBands>band": ""}
.MODE:Normal
.INSTRUCTIONS:In this step, a calibration takes place in order to convert calibrated backscatter values to logarithmic dB scale.

SETTINGS

Input image:
Select an define the previously processed (Step2: Calibration) image (*.dim) as "Input image" and choose the "Sigma0_XX" band for processing. (e.g. 02_Calibration_[NAME].dim)

The list of source bands:
Copy and paste the chosen band name here "Sigma0_XX".

Output Image:
The output file has to be in *.dim format. Switch "Open output file" off as QGIS cannot read DIM files. (e.g. 03_Lin2dB_[NAME].dim)

FURTHER INFORMATION

This step is only relevant if considering Sentinel-1 data. In case of having used e.g. ASAR and defined in the previously step (step 2: calibration) within "Advance parameters" the "Output image scale in Db", you should skip this step.
!INSTRUCTIONS
.ALGORITHM:s1tbx:terraincorrection
.PARAMETERS:{"nodataValueAtSea": true, "saveDEM": false, "pixelSpacingInDegree": 8.9e-05, "demName": 2, "saveSigmaNought": false, "applyRadiometricNormalization": false, "saveProjectedLocalIncidenceAngle": true, "demResamplingMethod": 1, "incidenceAngleForGamma0": 1, "saveLocalIncidenceAngle": false, "saveGammaNought": false, "incidenceAngleForSigma0": 1, "externalDEMNoDataValue": 0, "saveBetaNought": false, "!sourceBands>band": "", "imgResamplingMethod": 1, "auxFile": 0, "pixelSpacingInMeter": 10, "saveSelectedSourceBand": true}
.MODE:Normal
.INSTRUCTIONS:In this step, a terrain correction takes place in order to transform the image to ground geometry

SETTINGS

Input image:
Select an define the previously processed image (*.dim) as "Input image" and choose the "Sigma0_XX_db" band for processing. (e.g. 03_Lin2dB_[NAME].dim)

The list of source bands:
Copy and paste the chosen band name here "Sigma0_XX_db".

The digital elevation model:
For DEM you can either choose one of the options (like SRTM) in which case the DEM will be downloaded via Internet connection.

External DEM file:
If you want to use another DEM (e.g. ASTER GDEM) you have to specify it as an external DEM.

External DEM no-data value:
Specify the no-data value (default is given with 0)

DEM resampling method:
Choose BILINEAR_INTERPOLATION

Image resampling method:
Choose BILINEAR_INTERPOLATION

The pixel spacing in degrees:
For Sentinel-1: Pixel spacing in degrees: 8.983152841195215E-5 for high resolution and 3.594159451762205E-4 for medium resolution

The pixel spacing in meters:
For Sentinel-1: Pixel spacing in meters: 10 for high resolution and 40 for medium resolution.

Other settings:
Leave the default values.

Advanced parameters:
- Map projection: Select and define WGS84 (EPSG:4326)
- Save selected Source Band: Activate
- Save projected local incidence angle: Activate optionally in order to normalize the backscatter values later or to retrieve soil moisture values out of them.

Output Image:
The output file has to be in *.dim format. Switch "Open output file" off as QGIS cannot read DIM files. (e.g. 04_TC_[NAME].dim)


FURTHER INFORMATION

In order to normalize the backscatter values later or to retrieve soil moisture values afterwards, an activation of "Save projected local incidence angle" in the advanced parameters should be selected.
Note that the processing of a whole Sentinel-1 scene is quite time demanding.
!INSTRUCTIONS
.ALGORITHM:s1tbx:subset
.PARAMETERS:{"copyMetadata": false, "bandNames": "", "subSamplingY": 1, "subSamplingX": 1}
.MODE:Normal
.INSTRUCTIONS:Within this step you can spatially subset your input image. In addition you can define the bands to be subseted.

SETTINGS

Input (The product which will be subset):
Select and define your previously processed image (*.dim). (e.g. 04_TC_[NAME].dim)

Spatial extend (xmin, xmax, ymin, ymax):
Select and define your spatial subset

For band sub setting select and copy the band names to be considered and paste these band names into "The comma-separated list of names of bands to be copied"

Output Image:
The output file has to be in *.dim format. Switch "Open output file" off as QGIS cannot read DIM files. (e.g. 05_Subset_[NAME].dim)

FURTHER INFORMATION

This step is optional but can be used to perform a classification only on a spatial subset of the image (e.g. to decrease image size) or to leave out certain bands from the classification.
!INSTRUCTIONS
.ALGORITHM:s1tbx:specklefilter
.PARAMETERS:{"estimateENL": false, "enl": 1, "filter": 0, "filterSizeX": 3, "edgeThreshold": 5000, "dampingFactor": 2, "!sourceBands>band": "", "filterSizeY": 3}
.MODE:Normal
.INSTRUCTIONS:Within this step you can smooth your pre-processed radar image in order to remove noise effects (despeckling).

SETTINGS

Input (The product which will be despeckled):
Select and define your processed image (*.dim). (e.g. 05_Subset_[NAME].dim)

The list of source bands
Copy and paste the chosen band name here "Sigma0_XX_db".

Filter type:
Define a suitable filter type. (Typical filter types are "Frost" or "Lee" for radar despeckling

The kernel X/Y dimension:
Define the dimension to be considered for the despeckling (e.g. 3x3, 5x5, 7x7)

Other settings:
Leave the default values.

Output Image:
As output file, you can now specify the format: *.tif. (e.g. 06_Despeckled_[NAME].tif)

FURTHER INFORMATION

This step is optional but can be used to reduce noise effects and identifying small water bodies as commission errors. With increased resolution of a radar scene, a despeckling should be considered in order to reduce noise. Beside the choice of a filter type, the higher the kernel dimension is set, the smoother the output will result.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if((A<=-18),1,0)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:After having identified a suitable threshold you can now enter here a threshold value in [dB] for the classification of water areas. In general, flooded areas have low backscatter.

SETTINGS

Raster layer A:
Select the pre-processed radar image file. (e.g. 06_Despeckled_[NAME].tif)

Formula (Define here the threshold value within the expression):
if((A<=-18),1,0)

Output raster:
Specify the file path and name of the classified image. (e.g. 07_SWB1_[NAME].tif)

FURTHER INFORMATION

This first tresholding is intended to identify pure water areas while defining a lower threshold. Within the upcoming steps a cleaning procedure will be applied while expanding your water areas in a buffer zone with an increased threshold. You should therefore choose a threshold within pure water areas rather than at the border of these.
!INSTRUCTIONS
.ALGORITHM:gdalogr:sieve
.PARAMETERS:{"THRESHOLD": 50, "CONNECTIONS": 0}
.MODE:Normal
.INSTRUCTIONS:In this step your identified water areas are cleaned by considering a MMU (Minimum Mapping Unit).

SETTINGS

Input layer:
Select and define the previously processed image file. (e.g. 07_SWB1_[NAME].tif)

Threshold:
Define the area of MMU to be considered.
(The area is defined by referring to the amount of pixel, e.g. 50 representing 0.5ha, when referring to a 10m input resolution (50*10*10[m2]))

Pixel connection:
Define the pixel connectivity to be considered (e.g. 4 or 8)

Output layer:
Specify the file path and name of the image. (e.g. 08_SWB1_MMU_[NAME].tif)
!INSTRUCTIONS
.ALGORITHM:grass:r.mfilter.fp
.PARAMETERS:{"repeat": 1, "GRASS_REGION_CELLSIZE_PARAMETER": 0, "-z": false}
.MODE:Normal
.INSTRUCTIONS:In this step the previously cleaned (MMU) water areas are expanded by a buffer zone which will be considered in the next step to expand the water areas with an increased threshold.

SETTINGS

Input Layer:
Select and define the output of step 8. (e.g. 08_SWB1_MMU_[NAME].tif)

Filter File:
Select and define the buffer_3 text file provided within the Input_data folder.
(SWB_buffer3.txt)

Output Layer:
Select and define the path for output. (e.g. 09_SWB1_MMU_Buffer_[NAME].tif)

FURTHER INFORMATION

In this step, the cleaned (MMU) water areas are buffered in order to apply a higher threshold value in [dB] within this buffered area.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if((A<=-17 && B>0 && C!=1),1,C)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the threshold is extended within the derived buffer zone in order to expand the water areas with an identified increased threshold.

SETTINGS

Raster Layer A:
Select and define the output of step 6. (e.g. 06_Despeckled_[NAME].tif)

Raster Layer B:
Select and define the output of step 9. (e.g. 09_SWB1_MMU_Buffer_[NAME].tif)

Raster Layer C:
Select and define the output of step 8. (e.g. 08_SWB1_MMU_[NAME].tif)


Expression (Formula):
if((A<=-15 && B>0 && C!=1),1,C)

Output Raster Layer:
Select and define the path for output. (e.g. 10_SWB2_[NAME].tif)

FURTHER INFORMATION

In this step, an increased threshold is applied within the derived buffer zone. This threshold is a little bit lower than the threshold having been considered in order to be considered only within these identified buffered areas. Considering this lower threshold for the whole satellite image would result in a lot of commission errors. As it is only applied in the generated buffer, the water areas are only expanded in these defined areas.
!INSTRUCTIONS
.ALGORITHM:gdalogr:sieve
.PARAMETERS:{"THRESHOLD": 100, "CONNECTIONS": 0}
.MODE:Normal
.INSTRUCTIONS:In this step your identified water bodies are adapted to a finally considering MMU (Minimum Mapping Unit).

SETTINGS

Input layer:
Select and define the previously processed image file. (e.g. 10_SWB2_[NAME].tif)

Threshold:
Define the MMU to be considered.
(The area is defined by referring to the amount of pixel, e.g. 100 representing 1ha, when referring to a 10m input resolution (100*10*10[m2]))

Pixel connection:
Define the pixel connectivity to be considered (e.g. 4 or 8)

Output layer:
Specify the file path and name of the image. (e.g. 11_SWB2_MMU_[NAME].tif)
!INSTRUCTIONS
.ALGORITHM:modeler:polygonize_swb
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:This step converts your classified small water bodies as raster file into a vector file.

SETTINGS

Raster file:
Define your final classification of water bodies. (e.g. 11_SWB2_MMU_[NAME].tif)

Vector file:
Specify the file path and name for your water body polygons. (e.g. 12_SWB2_MMU_[NAME].shp)

FURTHER INFORMATION

The output result in a vector file with attributed codes from the raster classification. It can be considered to manually refine or adapt your classification result or to append additional information to the water bodies (e.g. area statistics)
!INSTRUCTIONS
.ALGORITHM:grass:r.kappa
.PARAMETERS:{"-w": false, "-h": false, "title": "ACCURACY ASSESSMENT"}
.MODE:Normal
.INSTRUCTIONS:At the end of each classification, accuracy should be derived in order to assess objective statistic information describing the quality of your classification. This is usually done by comparing a classification result with a reference image. Within this step, a confusion matrix is calculated, reporting overall accuracy, kappa coefficient as well as errors of commission and omission.

Note that you can only derive accuracy statistics of your classification if you have a reference image. If not, you have to skip this step.

SETTINGS

Raster layer containing classification result:
Select and define the classified image. (e.g. 11_SWB2_MMU_[NAME].tif)

Raster layer containing reference classes:
Select and define the raster layer containing the reference image information. (Note that this raster layer must reflect the same class codes as your input classification image)

Title for error matrix and kappa:
Choose a title for the error Matrix (default is "ACCURACY ASSESSMENT")

No header in the report:
Select "No" in order to consider header information in the report.

Wide report (132 columns):
Choose "yes" to generate a "Wide report".

Output file containing error matrix and kappa:
Finally, specify the location and name of the error matrix and kappa file. (e.g. 13_SWB2_MMU_Accuracy_[NAME].txt)

FURTHER INFORMATION

Note that in the error matrix, MAP1 represents the reference and MAP2 the classification result.
!INSTRUCTIONS
