.NAME:07 - Water demand evaluation
.GROUP:PG #05: High resolution basin characterization
.ALGORITHM:modeler:hrl_water_demand
.PARAMETERS:{"STRING_FIELDNAMEAREA": "ha_6_05", "STRING_FORMULACALCULATEAREA": "\"_count\"  *  ( 20 * 20 )  * 0.0001", "STRING_FORMULA": "if(A == 6, 1, 0)", "STRING_WATERDEMANDFIELDNAMEEGWATERDEMANDLANDCOVERTIME": "wd_05_6_a", "STRING_FORMULACALCULATEWATERDEMAND": "\"ha_6_05\"  *  6950"}
.MODE:Normal
.INSTRUCTIONS: Within this step, water demand for defined area of interest (e.g. catchments) is quantified while relating it to land cover classes of the previously derived land cover classification.

SETTINGS

Input: HR classification:
Select and define your classification result as raster file.
(e.g. TN_Product5-1_LC-2005_DC06-v2-Mokolo.img)

Formula - extract land cover class of interest:
Leave this formula as it is and define only the value of you land cover class for which you want to evaluate the water demand. In this case it is 6, representing "irrigated cultivated" areas.

INPUT: AOI
Select and define here your area of interest (AOI) for which the analyses shall take place. This input has to be a vector file, where polygons defines your aoi(s).
(e.g. chatchments.shp)

Area field name - e.g. area_unit_landcover_year:
This will be the name of the fieldname/column, within which the area of interest land cover class while be calculated. Try to choose a short and self-explaing name as character are limited to 10. As example here is stated "ha_6_05", meaning area in hectares (ha), for land cover class "irrigated cultivated" (6) out of the year 2005 (05).

Formula - calculate area:
Here the values have to be adjusted according to your resolution (INPUT: HR classification) and the units, on which basis water demand statistics are available. Do not change "_count". As example here is stated ""_count" * (20 * 20) * 0.0001", where 20 represents the resolution (cell size) of you image classification and 0.0001 the factor in order to convert from square meter to hectares.

Water demand field name - e.g. waterdemand_year_landcover_time:
Define here the name of the fieldname/column, within which the water demand values will be calculated. Also here, try to choose a short and self-explaing name as character are limited to 10. As example here is stated "wd_05_6_a", meaning water demand (wd) for the year 2005 (05), relating the land cover class "irrigated cultivated" (6) to yearly demand (a).

Formula - calculate water demand:
Here the field name and values have to be adjusted according to your defined fieldname/column (see "Area field name") and related know water demand values. In this case, the previously calculated area (ha_6_05) is multiplied by the water demand within one year per hectare in cubic meters (6950).

Output: Water demand:
Select and define here the path and name of your vector file, to which calculated water demand statistics are associated.
(07_01_[NAME].shp)

FURTHER INFORMATION

You can iteratively redo this water demand workflow by considering the previously calculated output (OUTPUT: Water demand) as new input (INPUT: AOI) adjusting for example the water demand to one month (e.g. January) and changing therefore the "Water demand field name - e.g. waterdemand_year_landcover_time" to "wd_05_6_jan", and correcting it in "Formula - calculate water demand:". In this case: "wd_05_6_jan" * 986, where 986 represents the water demand within January per hectare in cubic meters.
!INSTRUCTIONS
