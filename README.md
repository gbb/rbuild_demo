Rbuild_demo
===========

This demonstration should work in Linux and MacOS, possibly Windows if 
you have bash. Rbuild is most useful with large geometry datasets e.g. 
more than 100x bigger than this demo, but for practical purposes it's 
easier to offer a small dataset for download. I've given instructions 
below on how you can amplify this dataset to try out some 'big data/big 
map' work with rbuild.


To try out this demo, follow these instructions:

Overview
---

- Install dependencies
- Install rbuild + rbuild demo
- Create GIS database
- Add shapefiles to the database
- Setup buildfiles for rbuild
- Run rbuild
- Look at the result in the DB

Instructions
----

- Make sure you have installed Python, PostGIS and GDAL (with Python bindings/SWIG) 
  Gnu Parallel, Dan's gdal scripts, numpy, and pyparsing (if it didn't come with Python)

    $ yum install postgis gdal parallel numpy python 
    (or as appropriate for your linux version)
    (ideally postgis >2.1, gdal >1.10, parallel >20130222)

    $ compile dan's scripts by hand from github: https://github.com/gina-alaska/dans-gdal-scripts

- Make sure you have installed rbuild in your home directory (or another choice of directory)

    $ cd ~ ; git clone https://github.com/gbb/rbuild.git 

- You should check you installed all the dependencies correctly.

    $ ./rbuild/checksetup.sh

- Now you can set up a database for the geometry data, in postgres.

    $ createdb rbuild_demo

- Then install the postgis GIS extensions into that database.

    $ psql rbuild_demo

    > CREATE EXTENSION postgis; 
    > CREATE EXTENSION postgis_topology;
    > grant all privileges on all tables in schema public to public;
    > \q

- Download the demo, unzip the shapefiles, and copy the rbuild_demo/rbd_bf folder into rbuild.

    $ git clone https://github.com/gbb/rbuild_demo.git
    $ cd rbuild_demo 
    $ unzip shp.zip
    $ cp -a rbuild_demo_bfs  ~/rbuild/bf/rbuild_demo 

- Now we'll add some OpenStreetMap maps into the postgis db.

    $ shp2pgsql -d -S -I -D -i -s 25833 shp/nat1.shp nat1 | psql rbuild_demo
    $ shp2pgsql -d -S -I -D -i -s 25833 shp/land1.shp land1  | psql rbuild_demo

-- (The dataset came from here: http://download.geofabrik.de/europe.html)
-- (I have added some numerical fields to the .shp for this demonstration and reprojected to UTM33)
-- (You can take a look at the data in e.g. QGIS. Notice that some land features in both datasets.)
-- (You can also take a look at the buildfiles. The main file we'll be calling is rbd_bf/main.bf. It calls the other files.)
-- Disregard any error message about 'land1' does not exist. This comes from the use of '-d' in case you have tried the demo previously and forgot to remove the DB afterwards.

Demo 1: 

- Let's rasterize two sets of geometry into compressed GeoTIFF files.

    $ cd ~/rbuild
    $ ./rbuild -f bf/rbuild_demo/demo1.bf

-- The resulting files are placed in ~/rbuild/output/rbuild_demo_output_1, named A.tif and B.tif.
-- See the map file: 'bf/rbuild_demo/common/map_norway_rbd_20x20.bf'  to see why they're called A.tif and B.tif 
-- They automatically have overviews added at appropriate zoom levels.
-- If you want to see what rbuild is doing, add ' -v' in the command line.

    $ ./rbuild -f bf/rbuild_demo/demo1.bf -v

Demo 2: 

- Let's apply a GIS calculation across the two source rasters, using numpy, and make a GeoTIFF raster output.
- This calculation picks out all the cells that have value 2 in raster "A", and gives them value 100 in the result. 

    $ cd ~/rbuild
    $ ./rbuild -f bf/rbuild_demo/demo2.bf

-- The resulting files are placed in ~/rbuild/output/rbuild_demo_output_2. 
-- There is a style file in the rbuild_demo/qgis_styles folder to help you view demo2 easily.
-- Zoom in around 315000, 6800000 (UTM33), for example.

Demo 3: 

- As before, but now making: a GeoTIFF, Shapefile, PostGIS table, PostGIS raster, a JSON description, and DB comment.

    $ cd ~/rbuild
    $ echo "create schema public_raster;" | psql rbuild_demo
    $ echo "grant all privileges on all tables in schema public_raster to public;" | psql rbuild_demo
    $ ./rbuild -f bf/rbuild_demo/demo3.bf

-- If you like you can specify the extra build commands at the command line. Type ./rbuild -h for help.
-- Notice that there is only one line different in the build file (demo3.bf) compared to demo2.
-- You can use the 'passthrough' calculator to transfer source geometry directly to e.g. PostGIS Raster.

Demo 4: 

- Now, we're going to use ruleparser with rbuild to enable spreadsheet-based GIS processing.

-- If you like, build your own transform using ruleparser (github). 
-- Here I've given a simple transform that picks out the areas where both datasets have a data value.
-- You don't need to do anything here if you only want to try rbuild by itself.
-- You can see an example transform in rbuild_demo_rules.csv, which produced the files: new_calc.bf and add_values.sql
-- These are already included in the files within bf/rbuild_demo
-- To rebuild those rules, install ruleparser and type:  ./ruleparser.py rbuild_demo_output rbuild_demo_rules.csv

- Run rbuild as shown:

    $ cd ~/rbuild
    $ ./rbuild -f bf/rbuild_demo/main.bf
    $ cat bf/rbuild_demo/demo4/add_values.sql | psql rbuild_demo

-- Don't forget the last step!
-- TIF/shape files describing the rules matched is placed into .shp and .tif files in the folder output/final/rbuild_demo
-- A geometry table called "rbuild_demo_output_4" is created with the output values added for each rule. 
-- Try overlaying land1, nat1, and rbuild_demo_output_4 with the qgis style files in rbuild_demo/qgis_styles

-- Practice with the other command line options.
-- Try changing the transform spreadsheet or the source datasets. 

- Afterwards delete the demo DB.

    $ dropdb rbuild_demo

Making it more interesting
-----

Rbuild scales quite well with large amounts of geometry or large rasters.

The following SQL commands simulate a 10x larger dataset by reinserting the data 9 times.

    > insert into nat1 (osm_id, name, type, typenumber, geom) select osm_id, name, type, typenumber, geom from nat1 cross join generate_series(1,9);
    > reindex table nat1; 
    > insert into land1 (osm_id, name, type, typenumber, geom) select osm_id, name, type, typenumber, geom from land1 cross join generate_series(1,9);
    > reindex table land1; 

You can then run rbuild again and compare the time it takes (see the JSON file or the comment field in the DB).

If ten times isn't enough, run the commands again for a total of 100x increase in the geometry data to be processed.

Benchmarks
----

On this machine (4-core xeon v2 1270, similar to a desktop PC chip), 32GB ram, the total buildtimes on demo4 are:

Basic dataset (~100MB total geometry): 54 seconds.
10x dataset (~1GB total geometry): 61 seconds.
100x dataset (~10GB total geometry): 119 seconds.

(These time measurements did not include the 'add_values' script)

Other notes: How to turn OpenStreetMap text fields into numerical data for a raster for yourself.
---

    > select type into type1 from nat1 group by type order by type; -- pick out unique types
    > alter table type1 add column typenumber serial; -- assign a number to each type

then either modify the original data

    > alter table nat1 add column typenumber integer;
    > update nat1 set typenumber=type1.typenumber from type1 where nat1.type=type1.type;

or join into a new table:

    > select nat1.*,type1.typenumber into nat2 from nat1,type1 where nat1.type=type1.type; -- join them

Remember to check that you have set a primary key and registered the correct SRID (4326 for original OSM data).


Map licenses
---

Slightly modified from original OSM data.

© OpenStreetMap contributors
The data is available under the Open Database License.
http://www.openstreetmap.org/copyright
