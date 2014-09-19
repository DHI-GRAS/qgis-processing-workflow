.NAME:Water quality and temperature (MODIS)
.GROUP:PG #01: Large lakes water quality and temperature
.ALGORITHM:script:downloadfromftp
.PARAMETERS:{"username": "", "timestamp": "20130701000000", "host": "", "remoteDir": "", "password": "", "overwrite": false}
.MODE:Normal
.INSTRUCTIONS:Downloads daily water information and temperature data via FTP.

Note: download of real time water quality and temperature products only for registered users upon request.

SETTINGS

FTP server address:
Username: Define
Password: Define
Remote Directory: Define

Local Directory:
Specify a local directory where the data will be downloaded to, e.g.:
C:\Data\Temperature

Download files modified since:
Only files which have been last modified on or downloaded after the specified date will be downloaded.

Overwrite existing files:
If set to yes, any files located in the Local Directory which have the same filename as the newly downloaded files will be overwritten.

Extent to subset (Avanced):
If this field is set, the images will be automatically subsetted to the given extent after downloading.

Other settings:
Leave the default values.

FURTHER INFORMATION

Data provided are from the MODIS AQUA sensor, and processed in-house by the TIGER-NET consortium before being made available to users via ftp. If interested in this product please contact the TIGER-NET consortium.
!INSTRUCTIONS
