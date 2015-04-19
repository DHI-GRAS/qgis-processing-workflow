.NAME:04 - HR mapping (hybrid)
.GROUP:PG #05: High resolution basin characterization
.ALGORITHM:otb:segmentationedison
.PARAMETERS:{"-filter.edison.spatialr": 5, "-mode.vector.simplify": 0.1, "-mode.vector.outmode": 1, "-mode": 0, "-filter.edison.minsize": 100, "-filter.edison.ranger": 15, "-mode.vector.ogroptions": "None", "-mode.vector.startlabel": 1, "-mode.vector.fieldname": "DN", "-filter.edison.scale": 1, "-mode.vector.neighbor": true, "-mode.vector.minsize": 1, "-mode.vector.stitch": true, "-mode.vector.layername": "layer", "-filter": 0, "-mode.vector.tilesize": 1024}
.MODE:Normal
.INSTRUCTIONS:Segmentation. Within step 1, segments are derived from the input satellite image representing ideally real world objects (polygons).

SETTINGS

Input Image:
Select and define the satellite image.

Parameters:
Default (Try and error operation by defining and redefining the parameters have to be considered in order to achieve the best segmentation result and the corresponding delineation of objects within the image).

Writing mode:
ovw

Output vector file:
Select and define the path for output. (e.g. 04_01_[NAME].shp)

FURTHER INFORMATION

The hybrid classification approach considers the segments, derived from an object-based classification as objects features, ideally delineating real world objects and associate the previously derived classification results (pixel based unsupervised or supervised classification) to these derived segments. It represents therefore finally also a kind smoothing of the pixel based classification, as there values are aggregated by zonal statistics to the here derived segments .
!INSTRUCTIONS
.ALGORITHM:modeler:hrl_segments_association
.PARAMETERS:{"NUMBER_CELLSIZE": 0}
.MODE:Normal
.INSTRUCTIONS:Pixel based classification results association to previously derived segments. In this step, pixel based classification results (unsupervised or supervised) are associated to the segments by assessing statistics (mode)
of underlying pixel values and associating these to the segments (real world objects).

SETTINGS

Input: Pixel based classification:
Select and define your pixel based classification result.

Input: Segments (step 1):
Define the result from the segmentation. (Previously derived output of step 1)
(04_01_[NAME].shp)

Cell size:
Select and define the cell size (pixel resolution). This cell size should reflect the resolution of the INPUT: Pixel based classification.

Output:
Select and define path and name of the derived output from the hybrid classification.
(e.g. 04_02_[NAME].tif)
!INSTRUCTIONS
