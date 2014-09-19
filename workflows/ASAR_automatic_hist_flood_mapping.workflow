.NAME:Historical flood mapping (multiple images)
.GROUP:PG #07: Flood mapping system
.ALGORITHM:modeler:asar_historical_flood_mapping
.PARAMETERS:{"NUMBER_NODATAVALUE": 0, "NUMBER_SPLITTILESIZE": 200, "NUMBER_HANDTHRESHOLD": 6, "NUMBER_MANUALTHRESHOLD": -14, "NUMBER_MMU": 3}
.MODE:Batch
.INSTRUCTIONS:The historical flood mapping algorithm performs automatic thresholding by both automatically selecting a threshold value and by applying a user-specified threshold value. 

SETTINGS

Input file:
Specify the geocoded input files.

SplitTileSize:
This specifies the size of the tiles which are analysed for automatically deriving a threshold value.

Nodatavalue: 
The nodata value specifies missing data. In the case of NEST output this should be 0.

Manual threshold:
A threshold value for classifying flooded pixels which will be applied to each image.

HAND image:
It specifies the file containing the Height Above Nearest Drainage index which will be classified in flood-prone areas using the HAND threshold.

HAND threshold:
Specify a HAND threshold in [m]. Pixels lower than this HAND value will be classified as flood-prone. All others will be masked.

MMU:
The MMU specifies the size of the Minimum mapping unit.

Automatic Flood Map:
Specify the filename of the automatic classified flood map.

Manual Flood Map:
Specify the filename of the manual classified flood map.

FURTHER INFORMATION

For more detail, you can refer to Threshold classification and Post-processing.

!INSTRUCTIONS
.ALGORITHM:r:countfloodoccurrence
.PARAMETERS:{"Input_file_mask ": "*_gr_geo_fld_manual.tif", "HAND_threshold ": 6, "Input_folder ": "Path to the folder holding the classified layers"}
.MODE:Normal
.INSTRUCTIONS:This algorithm counts the number of occurrences of flooding in the layers that were classified in the previous step. 

SETTING

Input folder:
As input folder, specify the output folder where the classified rasters were saved and the filename mask. Here you can use wildcards like *. 

HAND image:
It specifies the file containing the Height Above Nearest Drainage index which will be classified in flood-prone areas using the HAND threshold.

HAND_threshold:
Specify a HAND threshold in [m]. Pixels lower than this HAND value will be classified as flood-prone. All others will be masked.

Flood count:
Flood count as percent of acquisitions:
Two output files are produced: A map showing the number of times a pixel was classified as flooded and a second map showing the number as percentage of the number of acquisitions. The latter should be more robust to the inhomogeneous sampling of ASAR WS imagery.

!INSTRUCTIONS
