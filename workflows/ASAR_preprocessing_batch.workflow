.NAME:Pre-processing ASAR WS (multiple images)
.GROUP:PG #07: Flood mapping system
.ALGORITHM:nest:applyorbitfile
.PARAMETERS:{"orbitType": 0}
.MODE:Batch
.INSTRUCTIONS:The first step for ASAR WS processing consist of retrieving precise DORIS orbit information on the exact position of the ENVISAT satellite during the acquisition of the image.

SETTINGS

Input image:
Select an ASAR image to process

Orbit type:
Select DORIS Verified(ENVISAT)

Output Image:
The output file must be in *.dim format. Uncheck the "Open output file" option as QGIS cannot read DIM files.

FURTHER INFORMATION

IMPORTANT: make sure that the correct path to the downloaded DORIS files is set in the NEST GUI under Edit -> Settings -> Orbit Files -> dorisVorOrbitPath.
!INSTRUCTIONS
.ALGORITHM:nest:subset
.PARAMETERS:{"tiePointGridNames": "", "subSamplingY": 1, "bandNames": "Amplitude", "subSamplingX": 1, "copyMetadata": false, "fullSwath": false}
.MODE:Batch
.INSTRUCTIONS:Since the ASAR files are rather large it is important to subset them to the area of interest. This is done in this step. 

SETTINGS

The product which will be subseted:
Spatial extent:
Select the ASAR scene with the applied orbit file produced in step 1. Simply zoom in to the AOI in QGIS and click on the "..." Button next to Spatial Extent and choose "Use canvas extent".

Output Image:
The output file has to be in *.dim format. Switch "Open output file" off as QGIS cannot read DIM files.

Other settings:
Leave the default values.

FURTHER INFORMATION

Important: the zooming has to be done on a georeferenced layer since QGIS cannot read directly the geolocation from the N1 file.
!INSTRUCTIONS
.ALGORITHM:nest:calibration
.PARAMETERS:{"!sourceBands>band": "Amplitude", "createBetaBand": false, "outputImageScaleInDb": true, "createGammaBand": false, "auxFile": 0}
.MODE:Batch
.INSTRUCTIONS:ASAR Level 1 data have to be calibrated to obtain Sigma nought values.

SETTINGS

Input image: 
This list of source bands:
Select an ASAR subset image as "Input image" (Figure 1) and choose the "Amplitude_XX" band for processing.

The auxiliary file:
When calibrating ASAR WS data, set the auxiliary file to "product auxiliary file".

Output image scale in Db:
Output Image:
Make sure that "Output image scale in dB" is set to "Yes" to get values in logarithmic dB scale. The output file has to be in *.dim format. Switch "Open output file" off as QGIS cannot read DIM files.

Create Beta band(Advanced):
Create Gamma band(Advanced):
If you want to produce the Beta or Gamma band information, please enter the output file path here.

Other setting:
Leave the default values.
!INSTRUCTIONS
.ALGORITHM:nest:terraincorrection
.PARAMETERS:{"nodataValueAtSea": true, "saveDEM": false, "pixelSpacingInDegree": 0.00067373646309, "demName": 0, "saveSigmaNought": false, "applyRadiometricNormalization": false, "saveProjectedLocalIncidenceAngle": false, "demResamplingMethod": 0, "incidenceAngleForGamma0": 0, "saveLocalIncidenceAngle": false, "saveGammaNought": false, "incidenceAngleForSigma0": 0, "externalDEMNoDataValue": -32768, "saveBetaNought": false, "!sourceBands>band": "", "imgResamplingMethod": 0, "auxFile": 0, "pixelSpacingInMeter": 75, "saveSelectedSourceBand": true}
.MODE:Batch
.INSTRUCTIONS:Terrain Correction will transform the image to ground geometry 

SETTINGS

Input image:
The list of source bands:
The input image has to be a calibrated *.dim image. In The list of source bands select Sigma0_dB.

The digital elevation model:
External DEM file:
External DEM no-data value:
DEM resampling method:
Image resampling method:
The pixel spacing in degrees:
The pixle spacing in meters:
For DEM you can either choose one of the options (like SRTM) in which case the DEM will be downloaded. If you want to use another DEM (e.g. ASTER GDEM) you have to specify it as an external DEM. For ASAR-WS: Pixel spacing in degrees: 0.00067373646309; Pixel spacing in meters: 75.

Output Image:
As output, you can now specify *.tif.

Map projection(Advanced):
It is only tested for WGS84 (EPSG:4326). Set "Save selected Source Band" to Yes.

Other settings:
Leave the default values.

!INSTRUCTIONS
.ALGORITHM:gdalogr:translate
.PARAMETERS:{"EXTRA": "-co COMPRESS=LZW", "OUTSIZE": 100, "OUTSIZE_PERC": true, "SDS": false, "NO_DATA": "none", "EXPAND": 0}
.MODE:Batch
.INSTRUCTIONS:In order for QGIS to be able to use the NEST GeoTIFF output, the file has to be converted by GDAL.

SETTINGS

Input layer:
Set the layer to convert.

Additional creation parameters:
Use "-co COMPRESS=LZW" for compression of the GeoTIFF output.

Output Layer:
Enter a path and filename for the output layer name

Other settings:
Leave the default values.

!INSTRUCTIONS
