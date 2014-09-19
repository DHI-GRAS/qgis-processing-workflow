.NAME:01 - Preprocessing
.GROUP:PG #11: Long-term and seasonal variation of wetland areas
.ALGORITHM:beam:reproject
.PARAMETERS:{"orthorectify": false, "includeTiePointGrids": true, "easting": 99999.9, "elevationModelName": "", "orientation": 0, "pixelSizeY": 99999.9, "pixelSizeX": 99999.9, "noDataValue": 99999.9, "width": 99999, "resampling": 0, "referencePixelX": 99999.9, "referencePixelY": 99999.9, "addDeltaBands": false, "height": 99999, "tileSizeX": 99999, "northing": 99999.9}
.MODE:Batch
.INSTRUCTIONS:In this step the raw data will be reprojected and converted to a tif format.

SETTINGS

Input (The product which will be reprojected):
Select and define ALL your satellite images.
(Envisat MERIS FR data in .N1 format)

CRS of the required projection:
Select and define a proper reference system (EPSG:4326)

Output Image:
Select and define the path for output.
(e.g. 01_01_[Envisat MERIS FR NAME].tif)

It is recommended to USE THE ORIGINAL MERIS FILE NAME as NAME. [Envisat MERIS FR NAME]

FURTHER INFORMATION

Within this step, the raw data (N1 format) is reprojected and converted to tif format.
!INSTRUCTIONS
.ALGORITHM:modeler:wetlands_01_cloud_masking
.PARAMETERS:{}
.MODE:Batch
.INSTRUCTIONS:In this step you will create cloud mask images.

SETTINGS

Input (MERIS Image):
Select and define the output of step 01_01.
(01_01_[NAME].tif)

Output: Mask:
Select and define the path for output.
(e.g. 01_02_[NAME]_m.tif)

Output: Cloud Masked Image:
Select and define the path for output.
(e.g. 01_02_[NAME]_cm.tif)

FURTHER INFORMATION

This step will create cloud mask images and cloud masked MERIS FR scenes by using MERIS FR band 32 (cloud_type).
!INSTRUCTIONS
.ALGORITHM:modeler:wetlands_combined_indices
.PARAMETERS:{}
.MODE:Batch
.INSTRUCTIONS:In this step the combined indices image will be derived. It will be used for water masking in the next workflow.

SETTINGS

Input (Cloud masked MERIS image):
Select and define the output of step 01_02.
(01_02_[NAME]_cm.tif)

Input (Cloud Mask):
Select and define the output of step 01_02.
(01_02_]NAME]_m.tif)

Output: NDVI:
Select and define the path for output.
(e.g. 01_03_[NAME]_NDVI.tif)

Output: Combined Indices:
Select and define the path for output.
(e.g. 01_03_[NAME]_CI.tif)

FURTHER INFORMATION

Purpose of this step is to derive the combined indices image, which will be used for water masking in the following workflow. The used indices are described in the introduction.
!INSTRUCTIONS
