.NAME:04 - Post-processing
.GROUP:PG #07: Flood mapping system
.ALGORITHM:r:masknonfloodproneareas
.PARAMETERS:{"HAND_threshold ": 10}
.MODE:Normal
.INSTRUCTIONS:Mask areas not prone to flooding using a thresholded Height Above Nearest Drainage (HAND) index raster.

SETTINGS

Input HAND raster:
Input thresholded raster:
Select the HAND index image and classified image.

HAND threshold:
Specify a HAND threshold in [m]. Pixels lower than this HAND value will be classified as flood-prone. All others will be masked.

Output_flood_map:
Specify an output filename for the result.

!INSTRUCTIONS
.ALGORITHM:modeler:pg7_applymmu
.PARAMETERS:{"NUMBER_MMU": 3}
.MODE:Normal
.INSTRUCTIONS:Due to remaining speckle (even after filtering) isolated pixels and clusters falsely classified as water can remain.
A Minimum Mapping Unit (MMU) can be applied to remove isolated water pixels which were probably falsely classified.

SETTINGS

classified_Layer:
Enter the filename of the flood mask file. And the no-data value which is used here should be 255

MMU:
Enter the size of the MMU in pixels.For high-resolution SAR data a value of 15-20 is appropriate. All clusters of pixels smaller than this will be reclassified to "not flooded".

Output_raster:
Specify an output filename for the result.

!INSTRUCTIONS
.ALGORITHM:modeler:kml_output
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:The Binary flood maps produced in the last post-processing step can additionally be written as vector KML files. As an input the produced GeoTIFF layer is used.

SETTINGS

Binary_flood_map:
Specify the file name of the produced flood map. 

FURTHER INFORMATION

A KML file will be produced at the same location where the GeoTIFF flood layer is stored.

!INSTRUCTIONS
