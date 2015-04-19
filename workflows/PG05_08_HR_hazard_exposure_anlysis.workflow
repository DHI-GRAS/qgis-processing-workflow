.NAME:08 - Hazard exposure analysis
.GROUP:PG #05: High resolution basin characterization
.ALGORITHM:grass:v.to.rast.attribute
.PARAMETERS:{"use": 0, "GRASS_SNAP_TOLERANCE_PARAMETER": -1, "GRASS_REGION_CELLSIZE_PARAMETER": 0, "GRASS_MIN_AREA_PARAMETER": 0.0001}
.MODE:Normal
.INSTRUCTIONS:Within this step, affected areas through hazard are converted to raster images in order to be considered for the upcoming hazard exposure analysis. Note that if your hazard maps are already provided as raster files, this step can be neglected.

SETTTINGS

Input vector layer:
Select and define your vector file.
(e.g. flood.shp)

Source of raster values:
Default (attr).

Name of column for 'attr' parameter:
Select and define here the correct field name/column labelled with area affected or not. Note that in order to be considered correctly for the upcoming analyses, hazard affected areas should be labelled by 1 while non-affected should be labelled by 0.

Grass region extent (xmin, xmax, ymin, ymax):
Select and define here the classification result for which the upcoming exposure analysis will be done. (Use layer/canvas extend; Use extent from)

Grass region cell size:
Define here the cell size (resolution) of your classification.

Rasterized layer:
Select and define here the output of your rasterized hazard image.
(e.g. 08_01_[NAME].tif)
!INSTRUCTIONS
.ALGORITHM:modeler:hrl_exposure_anaylses
.PARAMETERS:{"STRING_FORMULACALCULATEAREA": "\"_sum\"  *  ( 20 * 20 )  * 0.0001", "STRING_PERCENTAFFECTEDAREAFIELDNAMEEGPERCENTAFFECTEDLANDCOVERYEAR": "paa_8_11", "STRING_FORMULA": "if(A == 8, 1, 0)", "STRING_FORMULACALCULATEPERCENTOFAFFECTEDLANDCOVER": "(\"aa_ha_8_11\" / \"ta_ha_8_11\") * 100", "STRING_FIELDNAMEAREA": "ta_ha_8_11", "STRING_AFFECTEDAREAFIELDNAMEEGAREAUNITLANDCOVERYEAR": "aa_ha_8_11", "STRING_PERCENTNONAFFECTEDAREAFIELDNAMEEGPERCENTNONAFFECTEDLANDCOVERYEAR": "pna_8_11", "STRING_FORMULACALCULATEPERCENTOFNONAFFECTEDLANDCOVER": "100 - \"paa_8_11\""}
.MODE:Normal
.INSTRUCTIONS:Within this step, an exposure analysis is derived while associating exposed area statistics to defined area of interest (e.g. administrative units). Affected areas (absolute and relative) are derived while analysing exposed areas of a land cover type of interest with the extend of a hazard (e.g. flood).

SETTINGS

INPUT: HR classification:
Select and define your classification result as raster file.
(classification.tif)

Formula - extract land cover class of interest:
Leave this formula as it is and define only the value of you land cover class for which you want to evaluate the water demand. In this case it is 8, representing "residential" areas.

INPUT: AOI
Select and define here your area of interest (AOI) for which the analyses shall take place. This input has to be a vector file, where polygons defines your aoi(s).
(e.g. Boundary_subsets.shp)

Total area field name - e.g. totalarea_unit_landocer_year:
This will be the name of the fieldname/column, within which the total area of your land cover class of interest while be calculated and associated to the AOI. Try to choose a short and self-explaing name as character are limited to 10. As example here is stated "ta_ha_8_11", meaning total area (ta) in hectares (ha), for land cover class "residential" (8) out of the year 2011 (11).

Formula - calculate area:
Here the values have to be adjusted according to your resolution (INPUT: HR classification) and the units, on which basis exposure analysis statistics should be derived. Do not change "_sum". As example here is stated ""_sum" * (20 * 20) * 0.0001", where 20 represents the resolution (cell size) of your image classification and 0.0001 the factor in order to convert from square meter to hectares.

Input: hazard map (step1)
Select and define here the hazard layer or output of step1. Note that in order to be considered correctly within the analyse, hazard affected areas have to be labelled by 1 while non-affected have to be labelled by 0.
(08_01_[NAME].tif)

Affected area field name - e.g. affectedarea_unit_landcover_year:
Define here the name of the fieldname/column, within the absolute affected (exposed) area will be calculated. Also here, try to choose a short and self-explaing name as character are limited to 10. As example here is stated "aa_ha_8_11", meaning affected area (aa) in hectares (ha) for the land cover class "residential" (8) in the year 2011 (11).

Percent affected area field name - e.g. percentaffected_ladncover_year:
Define here the name of the fieldname/column, within which the relative affected (exposed) area will be calculated. Choose a short and self-explaing name as character are limited to 10.

Percent no affected area field name - e.g. percentnonaffected_ladncover_year:
Define here the name of the fieldname/column, within which the relative non-affected (none exposed) area will be calculated. Choose a short and self-explaing name as character are limited to 10.

Formula - calculate percent of affected land cover:
Within this formula the field names (e.g. "aa_ha_8_11" or "ta_ha_8_11") have to be adjusted according to your defined fieldname/column (see "Affected area field name" and "Total area field name”) .

Formula - calculate percent of non-affected land cover:
Within this formula the field name (e.g. "paa-8_11") has to be adjusted according to your defined fieldname/column (see "Percent affected area field name”).


Output: Exposure analysis: Select and define here the path and name of your vector file, to which calculated exposure analyse statistics are associated.
(e.g. 08_02_[NAME].shp)
!INSTRUCTIONS
