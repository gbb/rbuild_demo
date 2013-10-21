-- Automatically generated. To run, type:   psql (DATABASE) < add_values.sql
-- Generated on: 2013-10-17T20:05:34.323177 from the file: rbuild_demo_4_rules.csv
-- This code assumes you have a geometry table: 'rbuild_demo_output_4' from gdal/rbuild.

create index rbuild_demo_output_4_value_index on rbuild_demo_output_4 (value);
alter table rbuild_demo_output_4 add column present_in_both_shapes integer;
update rbuild_demo_output_4 set(present_in_both_shapes) = (0) where value=5;
update rbuild_demo_output_4 set(present_in_both_shapes) = (1) where value=7;

