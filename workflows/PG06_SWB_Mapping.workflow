.NAME:Water body mapping - optical based
.GROUP:PG #06: Water body mapping
.ALGORITHM:gdalogr:warpreproject
.PARAMETERS:{"ZLEVEL": 6, "RTYPE": 5, "BIGTIFF": 0, "TR": 0, "EXTRA": "", "COMPRESS": 0, "NO_DATA": "-9999", "TILED": false, "JPEGCOMPRESSION": 75, "TFW": false, "METHOD": 0, "PREDICTOR": 1}
.MODE:Normal
.INSTRUCTIONS:In this step you will make a copy of the input image.

SETTINGS

Input Layer:
Select and define the satellite image.

Set Source SRS (EPSG Code):
Select and define the reference system.

Set Destination SRS (EPSG Code):
Select and define an appropriate reference system.

Output Layer:
Select and define the path for output.
(e.g. 01_[NAME].tif)

FURTHER INFORMATION

In this step a copy of the satellite image will be created in order to assure correct workflow within QGIS. QGIS uses a defined structure of metadata including e.g. the coordinate reference system or extend. In order to avoid problems with data, having been processed in other software, this step has been implemented, however is optional.
!INSTRUCTIONS
.ALGORITHM:otb:bandmath
.PARAMETERS:{"-ram": 128, "-exp": "(((im1b1-im1b2)/(im1b1+im1b2+0.00001)+1)*500)"}
.MODE:Normal
.INSTRUCTIONS:In this step the Normalized Difference Vegetation Index (NDVI) will be calculated.

SETTINGS

Input Image List:
Select and define the output of step 1. (01_[NAME].tif)

Expression:
(((im1b1-im1b2)/(im1b1+im1b2+0.00001)+1)*500)

In this case:
NIR=b1; Red=b2
(Adjust if necessary)

Output Image:
Select and define the path for output.
(e.g. 02_NDVI_[NAME].tif)

FURTHER INFORMATION

In this step the NDVI (Normalized Difference Vegetation Index) is being calculated. Calculating NDVI (Step 2) and NDWI (Step 3) results in floating values between -1 and 1. In order to gain positive values, the value 1 is being added resulting in "positive" floating values, so ranging between 0-2 (1 is then the originally "NDVI = 0"). In addition by multiplying those values with 500, a stretch of the initial values is being achieved, resulting in values ranging from 0 to 1000 (where 500 is then the originally "NDVI = 0"). This stretch is being applied in order to better define afterwards thresholds instead of considering floating values between -1 and 1.
!INSTRUCTIONS
.ALGORITHM:otb:bandmath
.PARAMETERS:{"-ram": 128, "-exp": "(((im1b1-im1b4)/(im1b1+im1b4+0.00001)+1)*500)"}
.MODE:Normal
.INSTRUCTIONS:In this step the Normalized Difference Water Index (NDWI) will be calculated.

SETTINGS

Input Image List:
Select and define the output of step 1. (01_[NAME].tif)

Expression:
(((im1b1-im1b4)/(im1b1+im1b4+0.00001)+1)*500)

In this case:
NIR=b1; SWIR=b4
(Adjust if necessary)

Output Image:
Select and define the path for output.
(e.g. 03_NDWI_[NAME].tif)

FURTHER INFORMATION

In this step the NDWI (Normalized Difference Water Index) is being calculated.
!INSTRUCTIONS
.ALGORITHM:otb:bandmath
.PARAMETERS:{"-ram": 128, "-exp": "im1b1+80"}
.MODE:Normal
.INSTRUCTIONS:In this step the Normalized Difference Water Index (NDWI) has been scaled to the Normalized Difference Vegetation Index (NDVI). Otherwise the NDWI would have a higher influence.

SETTINGS

Input Image List:
Select and define the output of step 3. (03_NDWI_[NAME].tif)

Expression:
im1b1+80
(factor adjustment by e.g. value "80")

Output Image:
Select and define the path for output.
(e.g. 04_NDWI_NORM_[NAME].tif)

FRUTHER INFORMATION

In order to harmonize the two Indexes for the upcoming combination (step 5), the NDWI has to be scaled to the NDVI by a factor (e.g. 80), derived from the maximum values given in the NDVI with respect to the NDWI. This is done in order to equalize the two Indices (NDVI, NDWI), resulting in an equal weight. If you would not do this, the NDVI would have higher influence when combining the two indices (Step 5).
!INSTRUCTIONS
.ALGORITHM:modeler:swb_01_intermediate_result_with_enhanced_water_bodies
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:In this step the difference between the normalized NDWI and the NDVI is calculated to get a better result of the water bodies.

SETTINGS

NDVI Index:
Select and define the output of step 2.
(02_NDVI_[NAME].tif)

Input Image:
Select and define the output of step 1.
(01_[NAME].tif)

Normalized NDWI Index:
Select and define the output of step 4. (04_NDWI_NORM_[NAME].tif)

Output: Combined Indices:
Select and define the path for output.
(e.g. 05_COMBINED_INDICES_[NAME].tif)

FURTHER INFORMATION

In this step, the difference is calculated between the normalized NDWI and the NDVI in order to enhance water bodies.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if((A>=100),1,0)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the first intermediate water bodies (v1) are derived by considering a threshold greater or equal 100 of the values, gained from the combination of indices.

SETTINGS

Raster Layer A:
Select and define the output of step 5.
(05_COMBINED_INDICES_[NAME].tif)

Expression (Formula):
if((A>=100),1,0)

Output Raster Layer:
Select and define the path for output.
(e.g. 06_IWB_V1_[NAME].tif)

FURTHER INFORMATION

Within step 6, the first intermediate water bodies (v1) are derived by considering a threshold greater or equal 100 of the values, gained from the combination of indices. The given value is not static and should always be compared with the results of Step 5 (05_COMBINED_INDICES_[NAME].tif) in order to select and define the best possible threshold.
!INSTRUCTIONS
.ALGORITHM:modeler:swb_02_clump_and_sieve_iteration_1
.PARAMETERS:{"NUMBER_MMUPIXEL": 5}
.MODE:Normal
.INSTRUCTIONS:In this step intermediate water bodies will be filtered by considering a MMU (Minimum Mapping Unit).

SETTINGS

Input: (1rst water bodies):
Select and define the output of step 6.
(06_IWB_V1_[NAME].tif)

Define MMU (Pixel)

Output: Intermediate water v2:
Select and define the path for output.
(e.g. 07_IWB_V2_[NAME].tif)

FURTHER INFORMATION

In step 7, derived intermediate water bodies v1 are filtered by considering a minimum mapping unit (MMU) and resulting in intermediate water bodies v2.
!INSTRUCTIONS
.ALGORITHM:grass:r.mfilter.fp
.PARAMETERS:{"repeat": 1, "GRASS_REGION_CELLSIZE_PARAMETER": 0, "-z": false}
.MODE:Normal
.INSTRUCTIONS:In this step the intermediate water bodies v2, which are cleaned by the MMU, will be buffered. The aim is to get a buffered intermediate water bodies v2 mask.

SETTINGS

Input Layer:
Select and define the output of step 7.
(07_IWB_V2_[NAME].tif)

Filter File:
Select and define the buffer_1 text file provided within the Input_data folder.
(SWB_buffer1.txt)

Output Layer:
Select and define the path for output. (e.g. 08_IWB_V2_BUFFER_[NAME].tif)

FURTHER INFORMATION

In step 8, the cleaned (MMU) intermediate water bodies v2 are buffered in order to apply a higher threshold of the combined indices values within this buffer. The output is a buffered intermediate water bodies v2 mask.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if((A>=50 && B>0 && C!=1),1,C)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the threshold is extended within the spatial buffer of the remaining intermediate water bodies (step 8) in order to also include edge pixels with partial water cover and consequently a lower water signal.

SETTINGS

Raster Layer A:
Select and define the output of step 5. (05_COMBINED_INDICES_[NAME].tif)

Raster Layer B:
Select and define the output of step 8. (08_IWB_V2_BUFFER_[NAME].tif)

Raster Layer C:
Select and define the output of step 7.
(07_IWB_V2_[NAME].tif)

Expression (Formula):
if((A>=50 && B>0 && C!=1),1,C)

Output Raster Layer:
Select and define the path for output.
(e.g. 09_IWB_V3_[NAME].tif)

FURTHER INFORMATION

In this step, the threshold is extended within the spatial buffer of the remaining intermediate water bodies (step 8) in order to also include edge pixels with partial water cover and consequently a lower water signal. This threshold is a little bit lower than the threshold having been considered in Step 6 of the initial water bodies extraction (Intermediate water bodies v1). Considering this lower threshold for the whole satellite image would result in commission errors, however, as it is only applied in the generated buffer, the intermediate water bodies v1 are only expanded. Also here the threshold is not fixed and should be compared with values from "05_COMBINED_INDICES_[NAME].tif" overlaid with the satellite image.
!INSTRUCTIONS
.ALGORITHM:grass:r.mfilter.fp
.PARAMETERS:{"repeat": 1, "GRASS_REGION_CELLSIZE_PARAMETER": 0, "-z": false}
.MODE:Normal
.INSTRUCTIONS:In this step the intermediate water bodies will be buffered a second time.

SETTINGS

Input Layer:
Select and define the output of step 9.
(09_IWB_V3_[NAME].tif)

Filter File:
Select and define the buffer_1 text file provided within the Input_data folder.
(SWB_buffer1.txt)

Output Layer:
Select and define the path for output.
(e.g. 10_IWB_V3_BUFFER_[NAME].tif)

FURTHER INFORMATION

In step 10, a second buffering iteration is applied to the intermediate water bodies (v3) in order to apply a higher threshold of the combined indices values within this buffer. The output is a buffered intermediate water bodies v3 mask.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if((A>=75 && B>0 && C!=1),1,C)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the threshold is extended within the spatial buffer of the remaining intermediate water bodies (step 10) in order to include additional edge pixels with partial water cover and consequently a lower water signal.

SETTINGS

Raster Layer A:
Select and define the output of step 5. (05_COMBINED_INDICES_[NAME].tif)

Raster Layer B:
Select and define the output of step 10. (10_IWB_V3_BUFFER_[NAME].tif)

Raster Layer C:
Select and define the output of step 9. (09_IWB_V3_[NAME].tif)

Expression (Formula):
if((A>=75 && B>0 && C!=1),1,C)

Output Raster Layer:
Select and define the path for output.
(e.g. 11_IWB_V4_[NAME].tif)

FURTHER INFORMATION

In step 11, the threshold is extended within the spatial buffer of the remaining intermediate water bodies (step 10) in order to include additional edge pixels with partial water cover and consequently a lower water signal. The principle of this step is comparable to the step 9. Also here the threshold is not fixed and should be compared with values from "05_COMBINED_INDICES_[NAME].tif" overlaid with the satellite image in order to adjust and define a more suitable threshold.
!INSTRUCTIONS
.ALGORITHM:modeler:swb_03_clump_and_sieve_iteration_2
.PARAMETERS:{"NUMBER_MMUPIXELS": 25}
.MODE:Normal
.INSTRUCTIONS:In this step the derived water bodies will finally filtered by considering a MMU (Minimum Mapping Unit).

SETTINGS

Input: (1rst water bodies):
Select and define the output of step 11.
(11_IWB_V4_[NAME].tif)

Define MMU (Pixel)

Output: Intermediate water v5:
Select and define the path for output.
(e.g. 12_IWB_V5_[NAME].tif)

FURTHER INFORMATION

In this step, the derived water bodies, having been expanded by two iterations of extended thresholds within buffered areas, are finally filtered by considering a minimum mapping unit (MMU) and resulting in intermediate water bodies v5.
!INSTRUCTIONS
.ALGORITHM:modeler:swb_04_sobel_filter
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:In this step a sobel filter will be introduced for reducing the commission errors.

SETTINGS

Input Image:
Select and define the output of step 5. (05_COMBINED_INDICES_[NAME].tif)

Sobel Filter1:
Select and define the sobel_1 text file provided within the Input_data folder.
(SWB_Sobel1.txt)

Sobel Filter2:
Select and define the sobel_2 text file provided within the Input_data folder.
(SWB_Sobel2.txt)

Output: Sobel distance values:
Select and define the path for output.
(e.g. 13_SD_[NAME].tif)

FURTHER INFORMATION

As commission error still can occur, e.g. bare soil or urban areas, a sobel edge detection filter is applied to derive sobel distance values and to consider those values as threshold for the final water bodies.
Commission errors have the property of not having such a distinct spectral gradient to their surroundings as true water bodies. The derived values of the sobel edge detection filter highlight those spectral gradients if they were incorporated into the water bodies. Consequently they can be used to eliminate errors by using a threshold. In this step, sobel distance values are derived.
!INSTRUCTIONS
.ALGORITHM:modeler:swb_05_sobel_filter_values_to_water_bodies
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:In this step the sobel distance value is associated to the isolated water body. This is done for all water bodies, associating so to each of them the derived mean sobel distance value.

SETTINGS

Input Image: Intermediate water bodies v5:
Select and define the output of step 12. (12_IWB_V5_[NAME].tif)

Buffer_File2:
Select and define the buffer_2 text file provided within the Input_data folder. (SWB_buffer2.txt)

Input Image: Sobel Filter Values:
Select and define the output of step 13. (13_SD_[NAME].tif)

Output: Averaged sobel distance values within isolated water bodies:
Select and define the path for output.
(e.g. 14_ZS_SD_WITHIN_IWB_V5_[NAME].tif)

FURTHER INFORMATION

In order to assess, if water bodies have a high spectral gradient to their surroundings, the mean sobel distance values (step 13) are associated to isolated water bodies. To consider only relevant values, the mean of sobel distance values is considered for the border of each water body. This is derived by considering a buffer inside a water body and deriving the mean sobel distance value within this. Finally this mean sobel distance value is associated to the isolated water body.
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(A>=80,1,0)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:This step will be needed for reducing commission errors and preparing the final water bodies.

SETTINGS

Raster Layer A:
Select and define the output of step 14. (14_ZS_SD_WITHIN_IWB_V5_[NAME].tif)

Expression (Formula):
if(A>=80,1,0)

Output Raster Layer:
Select and define the path for output.
(e.g. 15_Preliminary_WB_[NAME].tif)

FURTHER INFORMATION

In this step, the threshold of the sobel edge detection values is set in order to reduce commission errors and preparing the final water bodies. This threshold is not fixed and should be adapted according to the values gained from step 14. (14_ZS_SD_WITHIN_IWB_V5_[NAME].tif)
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if(isnull(A) && B>0,0,A)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step no data values will be set to 0.

SETTINGS

Raster Layer A:
Select and define the output of step 15.
15_Preliminary_WB_[NAME].tif

Raster layer B:
Select and define the output of step 1.
(01_[NAME].tif)

Expression (Formula):
if(isnull(A) && B>0,0,A)

Output Raster Layer:
Select and define the path for output.
(e.g. 16_Final_WB_[NAME].tif)

FURTHER INFORMATION

In step 16, the final adjustment of water bodies is done by setting no data values to 0 and considering the final water bodies from step 15.
!INSTRUCTIONS
.ALGORITHM:grass:r.kappa
.PARAMETERS:{"-w": false, "-h": false, "title": "ACCURACY ASSESSMENT"}
.MODE:Normal
.INSTRUCTIONS:At the end of each classification, accuracy should be derived in order to assess objective statistic information describing the quality of your classification. This is usually done by comparing a classification result with a reference image. Within this step, a confusion matrix is calculated, reporting overall accuracy, kappa coefficient as well as errors of commission and omission.

Note that you can only derive accuracy statistics of your classification if you have a reference image. If not, you have to skip this step.

SETTINGS

Raster layer containing classification result:
Select and define the input classification image.
(16_Final_WB_[NAME].tif)

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
(e.g. 17_Final_WB_Accuracy_[NAME].txt)

FURTHER INFORMATION

Note that in the error matrix, MAP1 represents the reference and MAP2 the classification result.
!INSTRUCTIONS
