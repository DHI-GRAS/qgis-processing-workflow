.NAME:Water demand attribution
.GROUP:PG #10: Urban sanitation planning support
.ALGORITHM:qgis:joinattributestable
.PARAMETERS:{}
.MODE:Normal
.INSTRUCTIONS:The WOIS urban sanitation planning support tool has two components:
1. Model environment for estimating current and future demand for urban water use.
2. Urban land cover map with classes relevant for urban water and sanitation demand.
This workflows is used to attribute the urban land cover map with modelled water demand values.

SETTINGS:

Input layer:
Here you select the urban land cover map.

Input layer 2:
here you select the link table as prepared in the model environment.

Table field:
Specify the Input layer filed of the urban land cover map  on which the join will be based.

Table field 2:
Specify the Input layer field in the link table on which the join will be based.

Output layer:
Specify name and location of the output shapefile.
!INSTRUCTIONS
