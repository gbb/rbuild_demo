# Name of this build (used for working directory, outputs)
# It's best to override this at the command line or set in your own build file.
BUILD_NAME='rbuild_demo_output'

# Build description (this is output to JSON along with other information)
BUILD_DESCRIPTION='Demonstration of rbuild'. 

. $BUILDFILE_DIR/rbuild_demo/output_rbd_default.bf
. $BUILDFILE_DIR/standard/actions_result_poly_to_db.bf
. $BUILDFILE_DIR/standard/performance_fastest.bf
. $BUILDFILE_DIR/rbuild_demo/map_norway_rbd_20x20.bf
. $BUILDFILE_DIR/standard/overviews_standard.bf
. $BUILDFILE_DIR/rbuild_demo/polygonize_rbd.bf
. $BUILDFILE_DIR/rbuild_demo/calc_new.bf

# Various alternative buildfiles are provided:

# Grouped settings:  default.bf, test.bf
# Special groups of settings: see e.g. standard/performance_fast.bf
# Compression/parallelism: performance_{fast, fastest, polite, medium, smallfile}.bf
# Outputs/actions:  actions_{do_everything, do_nothing, source_and_result_rasters, result_raster,
#                            result_raster_and_poly, result_raster_to_db, result_raster_and_poly_to_db}.bf
# Overviews: standard/overviews_standard.bf, standard/overviews_all.bf

# If you want custom settings, copy this file and modify it. 
# default.bf settings are always included automatically. 
