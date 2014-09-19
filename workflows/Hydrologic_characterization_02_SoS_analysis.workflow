.NAME:Start of season statistics
.GROUP:PG #08: Hydrological Characterisation
.ALGORITHM:grass:r.report
.PARAMETERS:{"-e": true, "-f": true, "-n": true, "-h": true, "-N": true, "units": 2, "null": "*", "nsteps": 255}
.MODE:Normal
.INSTRUCTIONS:This tool calculates the area of each category of a user selected start of season raster file (SoS).

SETTINGS

Raster layer(s) to report on:
Select the input SoS file

Units:
Specify the desired output units
mi: miles
me: meters
k: kilometers
a: acres
h: hectars
c: cell counts
p: percent cover

Regional extent:
Thisparameters are optional and allow to subset the region of interest based on a spatial extent selected on the map or based on the extent of another layer. If settings are left as is, the whole image will be processed.

Output report file:
Specify name and output location for the output report file (e.g. C:\Data\SoS\SoS_report.html).

Other settings:
Leave the default values.

FURTHER INFORMATION

The report will be saved as an HTML file.

!INSTRUCTIONS
.ALGORITHM:modeler:subbasin_sos
.PARAMETERS:{"NUMBER_RASTERRESOLUTION": 0.1}
.MODE:Normal
.INSTRUCTIONS:This tool calculates the area (sqkm) of each category of a user selected start of season raster file (SoS) found within a user defined zone layer.

SETTINGS

Zone layer:
Select the vector layer containing the outline of zones. If the zone layer includes several regions (e.g. subcatchments) make sure you select the zone of interest from the QGIS canvas using the select tool.

Input SoS:
Select the start of season raster file to report on.

Raster resolution:
This value should be the same as the SoS input raster resolution (if not reprojected it is 0.1).

Output report file:
Specify name and output location for the output report file (e.g. C:\Data\SoS\SoS_report_basin1.html).

FURTHER INFORMATION

The report will be saved as an HTML file.
!INSTRUCTIONS
