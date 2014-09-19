.NAME:Lake temperature (AATSR)
.GROUP:PG #01: Large lakes water quality and temperature
.ALGORITHM:beam:aatsr.sst
.PARAMETERS:{"nadirCoefficientsFile": 5, "dualCoefficientsFile": 5, "nadirMaskExpression": "!cloud_flags_nadir.LAND and !cloud_flags_nadir.CLOUDY and !cloud_flags_nadir.SUN_GLINT", "invalidSstValue": -999, "dual": true, "dualMaskExpression": "!cloud_flags_nadir.LAND and !cloud_flags_nadir.CLOUDY and !cloud_flags_nadir.SUN_GLINT and !cloud_flags_fward.LAND and !cloud_flags_fward.CLOUDY and !cloud_flags_fward.SUN_GLINT", "nadir": true}
.MODE:Normal
.INSTRUCTIONS:Derivation of lake surface temperature from AATSR L1b TOA data.

SETTINGS

AATSR source product:
Load an AATSR product for which you want to derive water surface temperature.

Enable both dual-view and single-view SST generation and choose a gridded coefficient file. Gridded means a full resolution product will be retrieved (1 km spatial resolution). The latitude of the pixel governs whether the coefficients for the tropical, temperature or polar regions are to be used.

The value used to fill invalid pixels is set to -999, but it can be adjusted. Due to cloud coverage or other atmospheric artefacts, often many pixels are flagged as invalid.

Output Image:
Define the output path and image name, e.g., 01_[NAME].tif

Other settings:
Leave the default values.

FURTHER INFORMATION

If the resulting image contains too little temperature information, you can try relaxing the masking conditions in advanced parameters.

For more details see
https://earth.esa.int/handbooks/aatsr/CNTR2-7-1.htm
!INSTRUCTIONS
.ALGORITHM:beam:subset
.PARAMETERS:{"tiePointGridNames": "", "subSamplingY": 1, "bandNames": "nadir_sst,dual_sst", "subSamplingX": 1, "copyMetadata": false, "fullSwath": false}
.MODE:Normal
.INSTRUCTIONS:Spatial and band subsetting.

SETTINGS

The product which will be subseted:
The output of step 1 (01_[NAME].tif)

Spatial extent:
Define here the spatial extent if you want to change the spatial extent of the image.

If you want to keep just the dual-angle (band name = dual_sst) or nadir SST (band name = nadir_sst) you can perform the band subsetting in this step.

Output Image:
Define the output path and image name, e.g., 02_[NAME].tif

Other settings:
Leave the default values.
!INSTRUCTIONS
.ALGORITHM:beam:reproject
.PARAMETERS:{"orthorectify": false, "includeTiePointGrids": false, "easting": 99999.9, "elevationModelName": "", "orientation": 0, "pixelSizeY": 99999.9, "pixelSizeX": 99999.9, "noDataValue": 99999.9, "width": 99999, "resampling": 0, "referencePixelX": 99999.9, "referencePixelY": 99999.9, "addDeltaBands": false, "height": 99999, "tileSizeX": 99999, "northing": 99999.9}
.MODE:Normal
.INSTRUCTIONS:Reprojection of the image

SETTINGS

The product which will be reprojected:
The output of step 2 (02_[NAME].tif)

CRS of the required projection:
EPSG:4326 (=WGS84) or another projection.

Output Image:
Define the output path and image name, e.g., 03_[NAME].tif

Other settings:
Leave the default values.

FURTHER INFORMATION

Tie-point grids can be omitted to save disc space.
!INSTRUCTIONS
