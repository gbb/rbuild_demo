# Details for filesystem storage

# Raster/geometry storage directory (optional; generated data can be placed anywhere)
STORAGE_DIR=$RBUILD_HOME/output

# Directory containing buildfiles.
  # Configured in rbuild_settings.sh

	
# Details for database storage of output. Make sure db exists and has permissions set correctly.

OPTIONAL_OUTPUT_DB_HOST=''
OUTPUT_DB_DBNAME='rbuild_demo'
OUTPUT_DB_USERNAME=$USER

#OUTPUT_DB_PASSWORD=''
#Use direct connection, type by hand, or use a ~/.pgpass file for password.

# Schema for geometry output. Build name will be appended. Check schema exists and has correct permissions!
OUTPUT_GEOMETRY_SCHEMA="public"

# Schema for raster output. Build name will be appended. Check schema exists and has correct permissions!
OUTPUT_RASTER_SCHEMA="public"

# You may wish to run this on the schema.
# GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA xyz TO username;  (change existing table)
# ALTER DEFAULT PRIVILEGES IN SCHEMA xyz GRANT ALL ON TABLES TO username; (change future tables)
