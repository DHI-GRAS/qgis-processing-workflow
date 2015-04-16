.NAME:Multi-date composite image
.GROUP:Tools
.ALGORITHM:grass:r.series
.PARAMETERS:{"range": "-10000000000,10000000000", "-n": false, "GRASS_REGION_CELLSIZE_PARAMETER": 0, "method": 2}
.MODE:Normal
.INSTRUCTIONS:This step makes each pixel value a function of the values as-signed to the corresponding pixels in the input image time-series.

SETTINGS:

Select the input products under "Input raster layer(s)"

Make sure "Propogate NULLs" is deselected

Select the "Aggregation operation" (e.g. max, mean, median, P90)

Specify name and location of output composite image under "Output raster layer"

Optional:

Specify “Ignore values outside this range” (cf. Advanced parameters)

Specify region extent (optional)


!INSTRUCTIONS
.ALGORITHM:grass:r.neighbors
.PARAMETERS:{"GRASS_REGION_CELLSIZE_PARAMETER": 0, "-a": false, "method": 0, "-c": false, "size": 3}
.MODE:Normal
.INSTRUCTIONS:This step can be used to smooth out variability and enhance the overall spatial trends in the composite maps by using a low-pass smoothing filter.

SETTINGS:

Select the input composite image under "Input raster layer"

Select the smoothing (i.e. "Neighborhood operation") e.g. average or median

Chose "Neighborhood size" (default is 3x3 pixels)

Specify name and location of output  image under "Output layer"
!INSTRUCTIONS
