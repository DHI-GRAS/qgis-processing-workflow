.NAME:Water Quality (MERIS)
.GROUP:PG #01: Large lakes water quality and temperature
.ALGORITHM:beam:meris.correctradiometry
.PARAMETERS:{"reproVersion": 0, "doCalibration": true, "doEqualization": true, "doSmile": true, "doRadToRefl": false}
.MODE:Normal
.INSTRUCTIONS:Basic pre-processing to secure best possible quality of the MERIS input data.

SETTINGS

MERIS L1b source product:
Load a MERIS image for which you want to derive water quality data.

Use the default settings with both radiometric correction auxiliary file frames empty.

Set Smile-effect correction and equalization to yes.

Output image:
Define the output path and name, e.g.,
01_[NAME].dim
In this step, the output image must be saved as a BEAM DIMAP file (.dim) to allow processing in the following step. Untick "Open output file after running algorithm" to avoid a QGIS error message.

Other settings:
Leave the default values.
!INSTRUCTIONS
.ALGORITHM:beam:icol.meris
.PARAMETERS:{"cloudMaskExpression": "toa_reflec_14 > 0.2", "aeArea": 0, "exportRhoToaRayleigh": true, "icolAerosolCase2": false, "exportAlphaAot": true, "exportRhoToaAerosol": true, "userAerosolReferenceWavelength": 550, "icolAerosolForWater": true, "useAdvancedLandWaterMask": true, "productType": 0, "userAot": 0.2, "exportSeparateDebugBands": false, "userCtp": 1013, "exportAeAerosol": true, "useUserCtp": false, "userAlpha": -1, "exportAeRayleigh": true}
.MODE:Normal
.INSTRUCTIONS:Correction for the adjacency effect between land/water.

SETTINGS

MERIS L1b source product:
Use the MERIS file processed in step 1 as input source file (01_[NAME].dim).

Other settings:
Leave the default values.

Output image:
Define the output path and name, e.g.,
02_[NAME].dim
In this step, the output image must be saved as a BEAM DIMAP file (.dim) to allow processing in the following step. Untick "Open output file after running algorithm" to avoid a QGIS error message.
!INSTRUCTIONS
.ALGORITHM:beam:meris.lakes
.PARAMETERS:{"tsmConversionExponent": 1, "invalidPixelExpression": "agc_flags.INVALID", "doAtmosphericCorrection": true, "outputTosa": false, "landExpression": "toa_reflec_10 > toa_reflec_6 AND toa_reflec_13 > 0.0475", "doSmileCorrection": true, "outputTransmittance": false, "outputPath": false, "outputNormReflec": false, "spectrumOutOfScopeThreshold": 4, "outputReflecAs": 0, "chlConversionFactor": 0.0318, "cloudIceExpression": "toa_reflec_14 > 0.2", "algorithm": 1, "outputReflec": false, "tsmConversionFactor": 1.73, "chlConversionExponent": 1}
.MODE:Normal
.INSTRUCTIONS:Glint correction and derivation of the water quality parameters based on a neural network approach.

SETTINGS

MERIS L1b source product:
Use the MERIS file processed in step 2 as input source file (02_[NAME].dim).

Other settings:
Leave the default values.

Output image:
Define the output path and name, e.g.,
03_[NAME].dim
In this step, the output image must be saved as a BEAM DIMAP file (.dim) to allow processing in the following step. Untick "Open output file after running algorithm" to avoid a QGIS error message.

FURTHER INFORMATION

If using over eutrophic lakes the default parameters can be kept. Otherwise change the conversion parameters.
!INSTRUCTIONS
.ALGORITHM:beam:subset
.PARAMETERS:{"tiePointGridNames": "", "subSamplingY": 1, "bandNames": "tsm,chl_conc,Kd_490", "subSamplingX": 1, "copyMetadata": false, "fullSwath": false}
.MODE:Normal
.INSTRUCTIONS:Subsetting of the image by extent or bands.

SETTINGS

The product to subset:
The output file processed in step 3 (03_[NAME].dim).

Spatial extent:
Specify the spatial extent if you wish to subset your image.

Other settings:
Leave the default values.

Output image:
Define the output path and name, e.g.,
04_[NAME].tif
(Now the files can be saved in tif format and displayed in QGIS)

FURTHER INFORMATION

The following bands will be subset:
total suspended matter (tsm)
chlorophyll-a concentration (chl_conc)
attenuation coefficient (Kd_490)

Change or delete band names if you want to subset other bands.
!INSTRUCTIONS
.ALGORITHM:beam:reproject
.PARAMETERS:{"orthorectify": false, "includeTiePointGrids": false, "easting": 99999.9, "elevationModelName": "", "orientation": 0, "pixelSizeY": 99999.9, "pixelSizeX": 99999.9, "noDataValue": 99999.9, "width": 99999, "resampling": 0, "referencePixelX": 99999.9, "referencePixelY": 99999.9, "addDeltaBands": false, "height": 99999, "tileSizeX": 99999, "northing": 99999.9}
.MODE:Normal
.INSTRUCTIONS:Reproject the image

SETTINGS

The product which will be reprojected:
The output of step 4 (04_[NAME].tif)

CRS of the required projection:
EPSG:4326 (=WGS84) or another projection.

Output image:
Define the output path and name, e.g.,
05_[NAME].tif

Other settings:
Leave the default values.

FURTHER INFORMATION

The tie-point grids can be omitted to save disk space.
!INSTRUCTIONS
.ALGORITHM:otb:bandmath
.PARAMETERS:{"-ram": 256, "-exp": "if(im1b2>0,10^im1b2,-1)"}
.MODE:Normal
.INSTRUCTIONS:BEAM saves chlorophyll-a concentration with log10 scaling. Run band math if you wish a linear scaling.

SETTINGS

Input image list:
Add the reprojected image of step 5
(05_[NAME].tif)

The Expression - if(im1b2>0,10^im1b2,-1) - assumes that chlorophyll-a is the second band in the image. If you performed a different band subset in step 4 to the suggested one, the expression need to be adjusted.

Output image:
Define the output path and name, e.g.,
06_Chloro_[NAME].tif

FURTHER INFORMATION

Band math only works with .tif files and not with .dim files.
!INSTRUCTIONS
.ALGORITHM:otb:bandmath
.PARAMETERS:{"-ram": 256, "-exp": "if(im1b1>0,10^im1b1,-1)"}
.MODE:Normal
.INSTRUCTIONS:BEAM saves total suspended matter (tsm) with log10 scaling. Run band math if you wish a linear scaling.

Input image list:
Add the reprojected image of step 5
(05_[NAME].tif)

The Expression - if(im1b1>0,10^im1b1,-1) - assumes that tsm is the first band (b1) in the image. If you performed a different band subset in step 4 to the suggested one, the expression need to be adjusted.


Output image:
Define the output path and name, e.g.,
07_tsm_[NAME].tif

FURTHER INFORMATION

Band math only works with .tif files and not with .dim files.
!INSTRUCTIONS
