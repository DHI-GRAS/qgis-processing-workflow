.NAME:Land cover change (post-classification comparison)
.GROUP:PG #04: Medium resolution full basin characterization
.ALGORITHM:script:postclassificationcomparison
.PARAMETERS:{"w": true}
.MODE:Normal
.INSTRUCTIONS:This step can be used to compile a detailed tabulation of changes between two land cover classifications.

Note: skip this step and use sub-basin land cover change to constrain the land cover change analysis  to within a defined region.
 
SETTINGS

Select the "Initial State" and "Final State" land cover classifications respectively.

Select "Yes" under wide report and specify the name and location of the output change detection matrix (*.txt).

FURTHER INFORMATION

The analysis focuses primarily on the initial state classification changes; that is, for each initial state class, the analysis identifies the classes into which those pixels changed in the final state image.

Note that in the report the initial state is listed as MAP2 and the final state as MAP1.
!INSTRUCTIONS
.ALGORITHM:modeler:subbasin_lc_change
.PARAMETERS:{"NUMBER_RASTERRESOLUTION": 0}
.MODE:Normal
.INSTRUCTIONS:This tool calculates the change matrix bewteen two land cover classifications within a region defined by the input zone layer.

SETTINGS

Select the zone layer. If the zone layer includes several regions (e.g. sub-catchments) make sure to select the zone of interest from the QGIS canvas.

Specify the raster resolution. This value should be the same as the input land cover classification.

Select the "Initial State" and "Final State" land cover classifications, respectively.

Select "Yes" under wide report and specify the name and location of the output change detection matrix (*.txt)


FURTHER INFORMATION

The analysis focuses primarily on the initial state classification changes; that is, for each initial state class, the analysis identifies the classes into which those pixels changed in the final state image.

Note that in the matrix the initial state is listed as MAP2 and the final state as MAP1.
!INSTRUCTIONS
