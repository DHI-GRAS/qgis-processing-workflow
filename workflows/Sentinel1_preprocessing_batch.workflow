.NAME:Pre-processing Sentinel-1 (multiple images)
.GROUP:PG #07: Flood mapping system
.ALGORITHM:s1tbx:subset
.PARAMETERS:{"copyMetadata": true, "bandNames": "", "subSamplingY": 1, "subSamplingX": 1}
.MODE:Batch
.INSTRUCTIONS:This first preprocessing step is to subset the image into the Area of Interest to speed up the processing.

SETTINGS

Input image (the product which will be subsetted):
Select the Zip file containing the Sentinel-1 image to process.
E.g. "S1A_IW_GRDH_1SSV_20141130T233100_20141130T233136_003518_00422D_9C62.zip"

Bands:
Choose the "Amplitude_XX" band for processing.

Spatial extent:
Here you can select options;
- Use the extent of the map or a layer (e.g. AOI file)
- Select the extent on the canvas (draw a box on the map).
Make sure the coordinates are in lat/lon WGS 84 (EPSG:4326 similar to the input file)

Leave pixel sub-sampling steps equal to 1

Copy metadata: YES

Output Image:
As this is an intermediate result it is okay to save as temporary file (will be named out.tif and automatically deleted when you close QGIS).

But if you want to review the intermediate results save the file as GeoTiff.
Naming tips: prefix "subset_"
Outputname example: "subset_S1A_IW_GRDH_1SSV_20141130T233100.tif"

Open output file after running algorithm: YES
!INSTRUCTIONS
.ALGORITHM:s1tbx:applyorbitfile
.PARAMETERS:{"orbitType": 0}
.MODE:Batch
.INSTRUCTIONS:The next step for Sentinel-1 processing consist of retrieving precise orbit information on the exact position of the Sentinel-1 satellite during the acquisition of the image.

SETTINGS

Input image:
Select the Sentinel-1 image to process (output from previous step)

Orbit type:
Select Sentinel Precise (Auto Download). If there is no internet connection, then this step is skipped.

Output Image:
As this is an intermediate result it is okay to save as temporary file (will be named out.tif and automatically deleted when you close QGIS).

But if you want to review the intermediate results save the file as GeoTiff.
Naming tips: prefix "orb_"
Outputname example: "orb_subset_S1A_IW_GRDH_1SSV_20141130T233100.tif"


!INSTRUCTIONS
.ALGORITHM:s1tbx:calibration
.PARAMETERS:{"!sourceBands>band": "", "createBetaBand": false, "outputImageScaleInDb": true, "createGammaBand": false, "auxFile": 1}
.MODE:Batch
.INSTRUCTIONS:Sentinel-1 Level 1 data have to be calibrated to obtain Sigma nought values (measure of backscatter in dB).

SETTINGS

Input image:
This list of source bands:
Select an Sentinel-1 image as "Input image" (output from previous step) and choose the "Amplitude_XX" band for processing.

Output Image:
As this is an intermediate result it is okay to save as temporary file (will be named out.tif and automatically deleted when you close QGIS).

But if you want to review the intermediate results save the file as GeoTiff.
Naming tips: prefix "cal_"
Outputname example: "cal_orb_subset_S1A_IW_GRDH_1SSV_20141130T233100.tif"

Other settings:
Leave the default values.

Create Beta band(Advanced):
Create Gamma band(Advanced):
If you want to produce the Beta or Gamma band information, please enter the output file path here.

!INSTRUCTIONS
.ALGORITHM:s1tbx:lineartodb
.PARAMETERS:{"!sourceBands>band": ""}
.MODE:Batch
.INSTRUCTIONS:This step is to scale the backscatter into the dB domain (generally in the range from -25.5 to 0 dB).

SETTINGS

Input image:
Select an Sentinel-1 image (output from previous step) as "Input image" and choose the "Sigma0_XX" band for processing.

Output Image:
As this is an intermediate result it is okay to save as temporary file (will be named out.tif and automatically deleted when you close QGIS).

But if you want to review the intermediate results save the file as GeoTiff.
Naming tips: prefix "dB_"
Outputname example: "dB_cal_orb_subset_S1A_IW_GRDH_1SSV_20141130T233100.tif"

!INSTRUCTIONS
.ALGORITHM:s1tbx:terraincorrection
.PARAMETERS:{"nodataValueAtSea": false, "saveDEM": false, "pixelSpacingInDegree": 8.9e-05, "demName": 2, "saveSigmaNought": false, "applyRadiometricNormalization": false, "saveProjectedLocalIncidenceAngle": false, "demResamplingMethod": 1, "incidenceAngleForGamma0": 1, "saveLocalIncidenceAngle": false, "saveGammaNought": false, "incidenceAngleForSigma0": 1, "externalDEMNoDataValue": -32768, "saveBetaNought": false, "!sourceBands>band": "", "imgResamplingMethod": 1, "auxFile": 1, "pixelSpacingInMeter": 10, "saveSelectedSourceBand": true}
.MODE:Batch
.INSTRUCTIONS:Final step of the basic preprocessing;
Terrain Correction will transform the image to ground geometry, called orthorectification.

SETTINGS

Input image:
The input image has to be a calibrated Sentinel 1 image (output from previous step). In The list of source bands select Sigma0_dB.

Output Image:
This is the final step, thus give the output a meaningful name.
Naming tips: prefix "TC_"
Outputname example: "TC_dB_cal_orb_subset_S1A_IW_GRDH_1SSV_20141130T233100.tif" or the more simple "S1_20141130.tif"

Other settings:
Leave the default values.

FURTHER INFORMATION

Map projection(Advanced):
It is only tested for WGS84 (EPSG:4326). Set "Save selected Source Band" to Yes.

The digital elevation model:
If you want to mask out open water then tickmark no data value at sea.
External DEM file:
External DEM no-data value:
DEM resampling method:
Image resampling method:
The pixel spacing in degrees:
The pixle spacing in meters:
For DEM you can either choose one of the options (like SRTM) in which case the DEM will be downloaded. If you want to use another DEM (e.g. ASTER GDEM) you have to specify it as an external DEM. For Sentinel-1: Pixel spacing in degrees: 8.983152841195215E-5 for high resolution and 3.594159451762205E-4 for medium resolution; Pixel spacing in meters: 10 for high resolution and 40 for medium resolution.

If you want to save the projected local incidence angle for normalizing the backscatter later, please activate the "Save projected incidence angle" in the advanced parameters.


!INSTRUCTIONS
