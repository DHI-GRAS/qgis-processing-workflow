.NAME:00 - HR mapping (preprocessing)
.GROUP:PG #05: High resolution basin characterization
.ALGORITHM:gdalogr:warpreproject
.PARAMETERS:{"TR": 0, "METHOD": 0, "EXTRA": ""}
.MODE:Normal
.INSTRUCTIONS:Within this step you can reproject your image by transforming it from one projection to another 
  
SETTINGS 
  
Input Layer: 
Define the Input Image (e.g. Satellite Image, Classification) to be used for the reprojection. 
  
Source SRS (EPSG Code): 
Define a suitable reference system. 
  
Destination SRS (EPSG Code): 
Define a suitable reference system. 
  
Resampling Method: 
near: nearest neighbour resampling (default, fastest algorithm, worst interpolation quality). 
bilinear: bilinear resampling. 
cubic: cubic resampling. 
cubic spline: cubic spline resampling. 
lanczos: Lanczos windowed sinc resampling. 
  
Output Layer: 
Select and define the path of output. 
(e.g. 00_01_[NAME].tif) 
  
FURTHER INFORMATION 
  
The step is optional but can be used if the required classification output projection is different from the input image projection. 
!INSTRUCTIONS
.ALGORITHM:beam:subset
.PARAMETERS:{"tiePointGridNames": "", "subSamplingY": 1, "bandNames": "", "subSamplingX": 1, "copyMetadata": false, "fullSwath": false}
.MODE:Normal
.INSTRUCTIONS:Within this step you can spatially and spectrally sub setting your input image. 
  
SETTINGS 
  
Input (The product which will be subset): 
Select and define your Input Image. 
  
For spectral sub setting use the following format to create a band list: band_1, band_2, band_x 
  
Output Image: 
Select and define the path for output. 
(e.g. 00_02_[NAME].tif) 
  
FURTHER INFORMATION 
  
This step is optional but can be used to leave out certain spectral bands from the classification (e.g. due to quality issues) and/or perform classification only on a spatial subset of the image. 
!INSTRUCTIONS
