.NAME:01b - pre-processing - RADARSAT, no multilooking
.GROUP:PG #07: Flood mapping system
.ALGORITHM:s1tbx:calibration
.PARAMETERS:{"!sourceBands>band": "", "createBetaBand": false, "outputImageScaleInDb": true, "createGammaBand": false, "auxFile": 0}
.MODE:Normal
.INSTRUCTIONS:RADARSAT Level 1 data must be calibrated in order to obtain backscatter values.

SETTINGS

Input image:
List of source bands:
Select the RADARSAT product.xml file. As source band set the Amplitude_HH or Amplitude_VV band.

The Auxiliary file:
The antenna elevation pattern gain auxiliary data file:
This options are relevant for ENVISAT ASAR data only.

Output image scale in Db:
Output Image:
Make sure that "Output image scale in dB" is set to "Yes" to get values in logarithmic dB scale. The output file has to be in *.dim format. Switch "Open output file" off as QGIS cannot read DIM files.

Create Beta band(Advanced):
Create Gamma band(Advanced):
If you want to produce the Beta or Gamma band, please enter the output file path here.

!INSTRUCTIONS
.ALGORITHM:s1tbx:terraincorrection
.PARAMETERS:{"nodataValueAtSea": true, "saveDEM": false, "pixelSpacingInDegree": 0.000112289410515, "demName": 2, "saveSigmaNought": false, "applyRadiometricNormalization": false, "saveProjectedLocalIncidenceAngle": true, "demResamplingMethod": 1, "incidenceAngleForGamma0": 1, "saveLocalIncidenceAngle": false, "saveGammaNought": false, "incidenceAngleForSigma0": 1, "externalDEMNoDataValue": -32768, "saveBetaNought": false, "!sourceBands>band": "", "imgResamplingMethod": 1, "auxFile": 0, "pixelSpacingInMeter": 12.5, "saveSelectedSourceBand": true}
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
The pixel spacing in meters:
For DEM you can either choose one of the options (like SRTM) in which case the DEM will be downloaded. If you want to use another DEM (e.g. ASTER GDEM) you have to specify it as an external DEM. For RADARSAT-2 Standard beam:Pixel spacing in degrees: 1.1228941051494019E-4Pixel spacing in meters:12.5

Output Image:
As output, you can now specify *.tif.

Map projection(Advanced):
It is only tested for WGS84 (EPSG:4326). Set "Save selected Source Band" to Yes.

Other settings:
Leave the default values.

FURTHER INFORMATION

If you want to save the projected local incidence angle for normalizing the backscatter later, please activate the "Save projected incidence angle" in the advanced parameters.

!INSTRUCTIONS
.ALGORITHM:s1tbx:specklefilter
.PARAMETERS:{"estimateENL": true, "enl": 1, "filter": 3, "filterSizeX": 3, "edgeThreshold": 5000, "dampingFactor": 2, "!sourceBands>band": "", "filterSizeY": 3}
.MODE:Normal
.INSTRUCTIONS:RADARSAT imagery contains a high amount of speckle, so speckle filtering should be performed.

SETTINGS

The product which will be despeckled:
The list of source bands:
Select the geocoded *.dim or *.tif image as input image. For the *.dim image, select Sigma0_dB in The list of source bands.

Filter type:
The kernel X dimension:
The kernel Y dimension:
It is recommended to use a Gamma Map filter with a 3x3 kernel.

Estimate the number of looks:
Set this to Yes.

Ouput Image:
Enter a path and filename for the output image, you can specify *.tif

FURTHER INFORMATION

If preferring another filter, set the parameters accordingly.

!INSTRUCTIONS
.ALGORITHM:gdalogr:translate
.PARAMETERS:{"EXTRA": "-co COMPRESS=LZW", "OUTSIZE": 100, "OUTSIZE_PERC": true, "SDS": false, "NO_DATA": "none", "EXPAND": 0}
.MODE:Normal
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
