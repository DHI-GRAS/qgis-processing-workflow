.NAME:Land cover statistics
.GROUP:Tools
.ALGORITHM:grass:r.report
.PARAMETERS:{"-e": true, "-f": true, "-n": true, "-h": true, "-N": true, "units": 2, "null": "*", "nsteps": 255}
.MODE:Normal
.INSTRUCTIONS:This tool calculates the area present in each of the categories of a user-selected land cover map.

Use subbasin land cover (cf. next step) to constrain the area calculations to a specific region of interest (e.g. a subbasin)

SETTINGS:

Select the input land cove classification under "Raster layer(s) to report on.

Specify the desired output units
mi: miles
me: meters
k: kilometers
a: acres
h: hectares
c: cell counts
p: percent cover

Optional: Spatial subsetting of the image can be done by using Region extent.

Specify name and output location for the output report file (*.html).
!INSTRUCTIONS
.ALGORITHM:modeler:subbasin_lc
.PARAMETERS:{"NUMBER_RASTERRES": 0}
.MODE:Normal
.INSTRUCTIONS:This tool calculates the land cover areas (km2) found within a region specified by the input zone layer.

SETTINGS:

Select the input Zone layer. If the zone layer includes several regions (e.g. sub-catcements) make sure to select the zone of interest from the QGIS canvas.

Under input classification select the input land cover classification to report on.

Specify the raster resolution. This value should be the same as the input classification file.

Specify name and output location for the output report file (*.html).
!INSTRUCTIONS
