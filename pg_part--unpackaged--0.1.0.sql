/* contrib/pg_part/pg_part--unpackaged--1.0.sql */

-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION pgpart" to load this file. \quit

ALTER EXTENSION pgpart ADD schema pgpart;

ALTER EXTENSION pgpart ADD function pgpart._get_attname_by_attnum(NAME,NAME,SMALLINT);
ALTER EXTENSION pgpart ADD function pgpart._get_primary_key_def(NAME,NAME,NAME);
ALTER EXTENSION pgpart ADD function pgpart._get_index_def(NAME,NAME,NAME);
ALTER EXTENSION pgpart ADD function pgpart._get_partition_def(NAME,NAME,NAME,TEXT);
ALTER EXTENSION pgpart ADD function pgpart._get_export_query(NAME,NAME,TEXT,TEXT);
ALTER EXTENSION pgpart ADD function pgpart._get_import_query(NAME,NAME,TEXT);
ALTER EXTENSION pgpart ADD function pgpart.add_partition(NAME,NAME,NAME,TEXT,TEXT);
ALTER EXTENSION pgpart ADD function pgpart.merge_partition(NAME,NAME,NAME,TEXT,TEXT);
ALTER EXTENSION pgpart ADD function pgpart._get_constraint_name(NAME);
ALTER EXTENSION pgpart ADD function pgpart._get_constraint_def(NAME,TEXT);
ALTER EXTENSION pgpart ADD function pgpart._get_attach_partition_def(NAME,NAME,NAME,TEXT);
ALTER EXTENSION pgpart ADD function pgpart.attach_partition(NAME,NAME,NAME,TEXT);
ALTER EXTENSION pgpart ADD function pgpart._get_detach_partition_def(NAME,NAME,NAME);
ALTER EXTENSION pgpart ADD function pgpart.detach_partition(NAME,NAME,NAME);
ALTER EXTENSION pgpart ADD function pgpart.show_partition(NAME,NAME);
