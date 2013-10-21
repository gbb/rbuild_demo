# map_norway_rbd_20x20.bf
# 20x20 all norway in SSB recommended extents and UTM zone.
# GBB 10/2013   <grb@skogoglandskap.no>

# N.b. when setting values, don't put a space before '='. e.g. "This=good". "This = bad".
# Otherwise, you will get errors about 'command not found'

# List of geometry tables to burn.
# Hostname can be left empty ('') (in fact, performance will improve up to 50% if it is; unix sockets >> TCP/IP)
# Source raster ID    hostname    database name     table name      SQL field to burn      username      password.

#BURN_TABLES=(
#A '' dbname1 table1 burnField1 username1 password1 
#B '' dbname2 table2 burnField2 username2 password2
#C '' dbname3 table3 burnField3 username3 password3
#)

# By default, pick up the current username from the unix environment (e.g. geoadm).
# Please ensure that source tables are pre-transformed to the target SRID! 
# e.g. see README, appendix 1.

BURN_TABLES=(
A '' rbuild_demo land1 typenumber $USER '' 
B '' rbuild_demo nat1 typenumber   $USER '' 
)

# Geometry column in PostGIS
GEOMETRY_COLUMN="geom"

# Input map settings
# SRID below is the target SRID for the raster. Please make sure your source maps are in the coordinate system.
# e.g. see README, appendix 1.

SRID=25833
NODATA=255

# NODATA value for output files
RESULT_NODATA=255   

# SSBGrid coverages / projection
# Norway
XMIN=-80000
XMAX=1120000
YMIN=6440000
YMAX=7940000

# Scale of raster: meters per pixel, in x and y axis.
XM=20
YM=20

# How should the map be split into tiles for parallelising? 
# Quadratic effect: too many = slow (overhead); too few = slow (GDAL rasterize/calc problems). 
# Also, the numbers of tiles need to divide exactly into the map width/height to avoid artefacts.
# 100 or 400 tiles are good numbers, depending on scale. Below, 400 tiles = 20x20. 
# Generally, multiples of 2,4,5,10 are OK.
MAP_X_TILES=10
MAP_Y_TILES=10 





