.NAME:Wetland mapping - radar based
.GROUP:PG #11: Long-term and seasonal variation of wetland areas
.ALGORITHM:s1tbx:applyorbitfile
.PARAMETERS:{"orbitType": 0}
.MODE:Normal
.INSTRUCTIONS:The first step of radar processing consists of retrieving precise orbit information on the exact position of the satellite during the acquisition of the image.

SETTINGS

Input image:
Select an image to process.

Orbit type:
Select and define the Orbit type of your considered Input Image. In case of a Sentinel-1 scene delect and define:
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
- Save projected local incidence angle: Activate

Output Image:
The output file has to be in *.dim format. Switch "Open output file" off as QGIS cannot read DIM files. (e.g. 04_TC_[NAME].dim)


FURTHER INFORMATION

In order to normalize the backscatter values later or to retrieve soil moisture values afterwards, an activation of "Save projected local incidence angle" in the advanced parameters has to be selected.
Note that the processing of a whole Sentinel-1 scene is quite time demanding.
!INSTRUCTIONS
.ALGORITHM:s1tbx:subset
.PARAMETERS:{"copyMetadata": false, "bandNames": "", "subSamplingY": 1, "subSamplingX": 1}
.MODE:Normal
.INSTRUCTIONS:Within this step you can spatially subset your input image. In addition you can define the bands to be neglected.

SETTINGS

Input (The product which will be subset):
Select and define your previously processed image (*.dim). (e.g. 04_TC_[NAME].dim)

Spatial extend (xmin, xmax, ymin, ymax):
Select and define your spatial subset

The comma-separated list of names of bands to be copied:
leave blank (For the upcoming soil moisture retrieval, the "Sigma0_XX_db" as well as the "Projected local incidence angle" have to be considered.)

Output Image:
The output file has to be in *.dim format. Switch "Open output file" off as QGIS cannot read DIM files. (e.g. 05_Subset_[NAME].dim)

FURTHER INFORMATION

This step is optional but can be used to perform a classification only on a spatial subset of the image (e.g. to decrease image size) or to leave out certain bands from the classification.
!INSTRUCTIONS
.ALGORITHM:script:soilmoistureretrieval
.PARAMETERS:{"Sigma0_Nodata_value": 0, "Sensor": 1, "Lia_Nodata_value": 0}
.MODE:Normal
.INSTRUCTIONS:Within this step, an algorithm retrieves the surface soil moisture based on a defined parameter database. 
  
SETTINGS 
  
Sensor type: 
Select and define the Sensor type (e.g. Sentinel-1). 
  
sigma0: 
Select and define your previously processed backscatter image (Sigma0_XX_db.img) which you will find within the folder of "05_Subset_[NAME].data" 
  
sigma0 no data: 
if know, define the backscatter nodata value (default: 0) 
  
local incidence angle: 
Select and define your previously processed local incidence angle image (projectedLocalIncidenceAngle.img) which you will find within the folder of "05_Subset_[NAME].data" 
  
sigma0 nodata: 
if know, define the local incidence angle nodata value (default: 0) 
  
parameter database: 
Select and define the path to the tile based parameter database 
  
output raster: 
As output file, you can now specify the format: *.tif for your soil moisture output file (e.g. 06_soil_moisture_[NAME].tif) 
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if((A>=40),1,0)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the wetlands are derived by considering a threshold higher than e.g. 40. In general, wetlands are characterized by high soil moisture values. 
  
SETTINGS 
  
Raster Layer A: 
Select the derived soil moisture image file (e.g. 06_soil_moisture_[NAME].tif) 
  
Define your identified threshold within the 
Expression (Formula): 
if((A>=40),1,0) 
  
  
Output Raster Layer: 
Specify the path and name of the classified image. 
(e.g. 07_wetland1_[NAME].tif) 
!INSTRUCTIONS
.ALGORITHM:modeler:wetlands_mmu_filter
.PARAMETERS:{"NUMBER_MMU": 2}
.MODE:Normal
.INSTRUCTIONS:Within this step, your identified wetland areas are cleaned by considering a MMU (Minimum Mapping Unit). 
  
SETTINGS 
  
INPUT: 
Select and define the previously processed image file. (e.g. 07_wetland1_[NAME].tif) 
  
MMU: 
Define the area of MMU to be considered. 
(The area is defined by referring to the amount of pixel. 2 is the minimum that can be set applying a MMU filter of 1 pixel. With 500m resolution and a final MMU of 25ha (1*500*500[m2]), define 2) 
  
OUTPUT: 
Specify the file path and name of the image. (e.g. 08_wetland1_MMU_[NAME].tif) 
!INSTRUCTIONS
.ALGORITHM:grass:r.mfilter.fp
.PARAMETERS:{"repeat": 1, "GRASS_REGION_CELLSIZE_PARAMETER": 0, "-z": false}
.MODE:Normal
.INSTRUCTIONS:In this step the previously cleaned (MMU) wetland areas are expanded by a buffer zone which will be considered in the next step to expand the wetland areas with an adapted threshold. 
  
SETTINGS 
  
Input Layer: 
Select and define the output of step 8. (e.g. 08_wetland1_MMU_[NAME].tif) 
  
Filter File: 
Select and define the buffer_1 text file provided within the Input_data folder. 
(SWB_buffer1.txt) 
  
Output Layer: 
Select and define the path for output. (e.g. 09_wetland1_Buffer_[NAME].tif) 
  
FURTHER INFORMATION 
  
In this step, the cleaned (MMU) wetland areas are buffered in order to apply an adapted threshold within this buffered area. 
!INSTRUCTIONS
.ALGORITHM:grass:r.mapcalculator
.PARAMETERS:{"formula": "if((A>=35 && B>0 && C!=1),1,C)", "GRASS_REGION_CELLSIZE_PARAMETER": 0}
.MODE:Normal
.INSTRUCTIONS:In this step the wetlands are extended within the derived buffer zone with an adapted threshold. 
  
SETTINGS 
  
Raster Layer A: 
Select and define the output of step 6. (e.g. 06_soil_moisture_[NAME].tif) 
  
Raster Layer B: 
Select and define the output of step 9. (e.g. 09_wetland1_Buffer_[NAME].tif) 
  
Raster Layer C: 
Select and define the output of step 8. (e.g. 08_wetland1_MMU_[NAME].tif) 
  
  
Expression (Formula): 
if((A>=35 && B>0 && C!=1),1,C) 
  
Output Raster Layer: 
Select and define the path for output. (e.g. 10_wetland2_[NAME].tif) 
  
FURTHER INFORMATION 
  
In this step, an increased threshold is applied within the derived buffer zone. This threshold is a little bit lower than the threshold having been considered in order to be considered only within these identified buffered areas. Considering this lower threshold for the whole satellite image would result in a lot of commission errors. As it is only applied in the generated buffer, the water areas are only expanded in these defined areas. 
!INSTRUCTIONS
.ALGORITHM:modeler:wetlands_mmu_filter
.PARAMETERS:{"NUMBER_MMU": 2}
.MODE:Normal
.INSTRUCTIONS:Within this step, your identified wetland areas are finally adapted to the considered MMU (Minimum Mapping Unit). 
  
SETTINGS 
  
INPUT: 
Select and define the previously processed image file. (e.g. 10_wetland2_[NAME].tif) 
  
MMU: 
Define the area of MMU to be considered. 
(The area is defined by referring to the amount of pixel. 2 is the minimum that can be set applying a MMU filter of 1 pixel. With 500m resolution and a final MMU of 25ha (1*500*500[m2]), define 2) 
  
OUTPUT: 
Specify the file path and name of the image. (e.g. 11_wetland2_MMU_[NAME].tif) 
!INSTRUCTIONS
.ALGORITHM:modeler:polygonize_swb
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:This step converts your classified wetland areas as raster file into a vector file.

SETTINGS

Raster file:
Define your final classification of water bodies. (e.g. 11_wetland2_MMU_[NAME].tif)

Vector file:
Specify the file path and name for your water body polygons. (e.g. 12_wetland2_MMU_[NAME].shp)

FURTHER INFORMATION

The output result in a vector file with attributed codes from the raster classification. It can be considered to manually refine and adapt your classification result (especially for masked out areas) or to append additional information to the wetland areas (e.g. area statistics)

!INSTRUCTIONS
.ALGORITHM:grass:r.kappa
.PARAMETERS:{"-w": false, "-h": false, "title": "ACCURACY ASSESSMENT"}
.MODE:Normal
.INSTRUCTIONS:At the end of each classification, accuracy should be derived in order to assess objective statistic information describing the quality of your classification. This is usually done by comparing a classification result with a reference image. Within this step, a confusion matrix is calculated, reporting overall accuracy, kappa coefficient as well as errors of commission and omission.

Note that you can only derive accuracy statistics of your classification if you have a reference image. If not, you have to skip this step.

SETTINGS

Raster layer containing classification result:
Select and define the classified image. (e.g. 11_wetland2_MMU_[NAME].tif)

Raster layer containing reference classes:
Select and define the raster layer containing the reference image information. (Note that this raster layer must reflect the same class codes as your input classification image)

Title for error matrix and kappa:
Choose a title for the error Matrix (default is "ACCURACY ASSESSMENT")

No header in the report:
Select "No" in order to consider header information in the report.

Wide report (132 columns):
Choose "yes" to generate a "Wide report".

Output file containing error matrix and kappa:
Finally, specify the location and name of the error matrix and kappa file. (e.g. 13_wetland2_MMU_Accuracy_[NAME].txt)

FURTHER INFORMATION

Note that in the error matrix, MAP1 represents the reference and MAP2 the classification result.

!INSTRUCTIONS
