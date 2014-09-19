.NAME:03 - Flood-prone areas
.GROUP:PG #07: Flood mapping system
.ALGORITHM:grass:r.watershed
.PARAMETERS:{"threshold": 1000, "max.slope.length": 0, "GRASS_REGION_CELLSIZE_PARAMETER": 0, "-4": true}
.MODE:Normal
.INSTRUCTIONS:In this step, the drainage directions for water flow is computed from a DEM. Also, the drainage network is needed as an input for the Height Above Nearest Drainage (HAND) index computation.

SETTINGS

Elevation:
Select the DEM file for the watershed basin analysis.

Drainage direction:
Specify the output name of drainage direction.

Stream segments:
Specify the output name of Stream segments

Other settings:
Leave the default values.

!INSTRUCTIONS
.ALGORITHM:r:hand
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:The Height Above Nearest Drainage (HAND) index is the height difference between a DEM cell and the corresponding nearest cell belonging to the drainage network. The distance between the two is measured along the flowpaths which is why a flow direction raster is also needed as an input.

SETTINGS

DEM:
Select the DEM file to produce HAND index.

Flow direction:
Select the drainage directions created in the previous step.

Drainage network:
select the drainage network that is created in the previous step as stream segments.

HAND raster:
Specify the path and filename of output HAND index image.

!INSTRUCTIONS
