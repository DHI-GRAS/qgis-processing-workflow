.NAME:02 - Threshold classification
.GROUP:PG #07: Flood mapping system
.ALGORITHM:script:backscatternormalization
.PARAMETERS:{"sigma0_nodata ": 0.0, "lia_nodata ": 0.0}
.MODE:Normal
.INSTRUCTIONS:This algorithm will use the slope parameter to normalize the backscatter to a reference incidence angle.

SETTINGS

sigma0:
sigma0 nodata:
The backscatter image and its nodata value.

local incidence angle:
lia nodata:
The local incidence angle image and its nodata value.

reference incidence angle:
The reference incidence angle.

parameter database:
It is a tile based parameter database provided by TUWien.

output raster:
Specify the output file name.
!INSTRUCTIONS
.ALGORITHM:r:automaticsplitbasedotsuthreshold
.PARAMETERS:{"Tile_size ": 200, "Nodata_value ": 0, "Lower_than ": true}
.MODE:Normal
.INSTRUCTIONS:The automatic thresholding algorithm splits the geocoded image produced during pre-processing into tiles and tries to derive a threshold from these tiles.

SETTINGS

Layer:
Nodata value:
Select the preprocessed RADARSAT image file and enter the Nodata value of the input image. The Nodata value in NEST output is 0.

Lower than:
"Lower than" means that all values lower than the computed threshold will be set to 1, all values higher will be set to 0; set this to "Yes".

Tile size:
The default tile size is 200x200 pixels. 

Classified_raster:
Specify the file path and name of the classified image.

FURTHER INFORMATION

If no threshold can be found, a raster containing only nodata is returned. In this case, it is worth trying a smaller tile size. 

!INSTRUCTIONS
.ALGORITHM:r:advancedrasterhistogram
.PARAMETERS:{"no_data_value ": 0}
.MODE:Normal
.INSTRUCTIONS:Water pixels often have low backscatter values while non-water pixels often have medium to high backscatter, resulting in to a bi-modal distribution in the image histogram. The classification threshold can be manually identified as the local minimum between the two peaks.

SETTINGS

Layer:
Select the preprocessed RADARSAT image file.

R Plots:
Specify the output name(eg. histogram.html) if you want to save the histogram. Otherwise, you can leave it empty.

Other settings:
Leave the default values.

!INSTRUCTIONS
.ALGORITHM:script:manualthreshold
.PARAMETERS:{"Threshold ": -14, "Nodata_value ": 0, "Lower_than ": true}
.MODE:Normal
.INSTRUCTIONS:The manual thresholding is meant as a alternative approach to the automatic thresholding procedure. You can here enter a threshold value in [dB] for the classification of flooded areas. In general, flooded areas have low backscatter.

SETTINGS

Layer:
Nodata value:
Select the preprocessed RADARSAT image file and enter the Nodata value of the input image.

Lower than:
"Lower than" means that all values lower than the computed threshold will be set to 1, all values higher will be set to 0; set this to "Yes".

Threshold:
Enter the threshold value for the classification.

Classified_raster:
Specify the file path and name of the classified image.

!INSTRUCTIONS
