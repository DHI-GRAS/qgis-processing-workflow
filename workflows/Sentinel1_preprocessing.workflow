.NAME:01c - Pre-processing - Sentinel-1
.GROUP:PG #07: Flood mapping system
.ALGORITHM:s1tbx:applyorbitfile
.PARAMETERS:{"orbitType": 1}
.MODE:Normal
.INSTRUCTIONS:The first step for Sentinel-1 processing consist of retrieving precise orbit information on the exact position of the Sentinel-1 satellite during the acquisition of the image.

SETTINGS

Input image:
Select a Sentinel-1 image to process

Orbit type:
Select Sentinel Precise (Auto Download)

Output Image:
The output file must be in *.dim format. Uncheck the "Open output file" option as QGIS cannot read DIM files.

!INSTRUCTIONS
.ALGORITHM:s1tbx:calibration
.PARAMETERS:{"!sourceBands>band": "", "createBetaBand": false, "outputImageScaleInDb": true, "createGammaBand": false, "auxFile": 1}
.MODE:Normal
.INSTRUCTIONS:Sentinel-1 Level 1 data have to be calibrated to obtain Sigma nought values.

SETTINGS

Input image: 
This list of source bands:
Select an Sentinel-1 image as "Input image" (Figure 1) and choose the "Amplitude_XX" band for processing.

The auxiliary file:
This is only useful for ASAR.

Output image scale in Db:
Output Image:
Make sure that "Output image scale in dB" is set to "Yes" to get values in logarithmic dB scale. The output file has to be in *.dim format. Switch "Open output file" off as QGIS cannot read DIM files.

Create Beta band(Advanced):
Create Gamma band(Advanced):
If you want to produce the Beta or Gamma band information, please enter the output file path here.

Other setting:
Leave the default values.

!INSTRUCTIONS
.ALGORITHM:s1tbx:terraincorrection
.PARAMETERS:{"nodataValueAtSea": true, "saveDEM": false, "pixelSpacingInDegree": 0.00067373646309, "demName": 2, "saveSigmaNought": false, "applyRadiometricNormalization": false, "saveProjectedLocalIncidenceAngle": false, "demResamplingMethod": 1, "incidenceAngleForGamma0": 1, "saveLocalIncidenceAngle": false, "saveGammaNought": false, "incidenceAngleForSigma0": 1, "externalDEMNoDataValue": -32768, "saveBetaNought": false, "!sourceBands>band": "", "imgResamplingMethod": 1, "auxFile": 1, "pixelSpacingInMeter": 75, "saveSelectedSourceBand": true}
.MODE:Normal
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
For DEM you can either choose one of the options (like SRTM) in which case the DEM will be downloaded. If you want to use another DEM (e.g. ASTER GDEM) you have to specify it as an external DEM. For Sentinel-1: Pixel spacing in degrees: 8.983152841195215E-5 for high resolution and 3.594159451762205E-4 for medium resolution; Pixel spacing in meters: 10 for high resolution and 40 for medium resolution.

Output Image:
As output, you can now specify *.tif.

Map projection(Advanced):
It is only tested for WGS84 (EPSG:4326). Set "Save selected Source Band" to Yes.

Other settings:
Leave the default values.

FURTHER INFORMATION

If you want to save the projected local incidence angle for normalizing the backscatter later, please activate the "Save projected incidence angle" in the advanced parameters.


!INSTRUCTIONS
.ALGORITHM:gdalogr:translate
.PARAMETERS:{"EXTRA": "-co COMPRESS=LZW", "OUTSIZE": 100, "OUTSIZE_PERC": true, "SDS": false, "NO_DATA": "none", "EXPAND": 0}
.MODE:Normal
.INSTRUCTIONS:In order for QGIS to be able to use the S1TBX GeoTIFF output, the file has to be converted by GDAL.

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
