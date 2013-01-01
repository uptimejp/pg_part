
pg_part extension


About pg_part
=============

pg_part is a PostgreSQL extension, which provides SQL utility functions, to allow users manipulating partitioned-tables without executing PostgreSQL DDL commands directly.


SQL Functions
=============

pg_part extension provies five SQL functions in `pgpart` schema, and these functions are *NOT* relocatable so far.


pgpart.add_partition
--------------------

pgpart.add_partition() function creates new partition, which has specified check condition, from the parent table, and moves records from the parent table to the partition.

    pgpart.add_partition(schema_name, table_name, partition_name, check_condition, temp_file)

Parameters:

- schema_name : a schema name which has the table to be parted.
- table_name : a table name to be parted.
- partition_name : a partition name to be created.
- check_condition : a check condition which the partition should have.
- temp_file : a temp file name to be used for migrating records (exporting/importing) between the table and the partition.

When pgpart.add_partition() function is called, it processes followings:

1. Create a child table, as a partition, inherited from the parent table with a check constraint.
2. Export records to be moved from the parent table to the partition.
3. Delete those (live) records from the parent table.
4. Import (exported) records into the partition.
5. Add a primary key to the partition (copied from the parent table).
6. Add indexes to the partition (copied from the parent table).

Example:

    dbt3=# SELECT pgpart.add_partition(
    dbt3(#   'public',
    dbt3(#   'orders',
    dbt3(#   'orders_1998',
    dbt3(#   ' ''1998-01-01'' <= o_orderdate AND o_orderdate < ''1999-01-01'' ',
    dbt3(#   '/tmp/orders.tmp');
     add_partition
    ---------------
     t
    (1 row)
    
    dbt3=#


pgpart.merge_partition
----------------------

pgpart.merge_partition() function merges a partition to the parent table with moving records in the partition.

    pgpart.merge_partition(schema_name, table_name, partition_name, check_constraint, temp_file)

Parameters:

- schema_name : a schema name which has the table to be merged.
- table_name : a table name to be merged.
- partition_name : a partition name to be merged.
- check_condition : a check condition which the partition has. (unused)
- temp_file : a temp file name to be used for migrating records (exporting/importing) between the table and the partition.

Example:

    dbt3=# SELECT pgpart.merge_partition('public', 'orders', 'orders_1998', null, '/tmp/orders.tmp');
     merge_partition
    -----------------
     t
    (1 row)
    
    dbt3=# 


pgpart.attach_partition
-----------------------

pgpart.attach_partition() function allows to attach a child table to the parent table as a partition when both have the same table definition.

    pgpart.attach_partition(schema_name, table_name, partition_name, check_condition)

Parameters:

- schema_name : a schema name which contains the table.
- table_name : a table name which the partition would be attached to.
- partition_name : a partition name to be attached.
- check_condition : a check condition which the partition should have.

Example:

    dbt3=# SELECT pgpart.attach_partition(
    dbt3(#   'public',
    dbt3(#   'orders',
    dbt3(#   'orders_1998',
    dbt3(#   ' ''1998-01-01'' <= o_orderdate AND o_orderdate < ''1999-01-01'' ');
     attach_partition
    ------------------
     t
    (1 row)
    
    dbt3=# 


pgpart.detach_partition
-----------------------

pgpart.detach_partition() function allows to detach a partition from the specified user table.

    pgpart.detach_partition(schema_name, table_name, partition_name)

Parameters:

- schema_name : a schema name which contains the table.
- table_name : a table name which has a partition to be detached.
- partition_name : a partition name to be detached.

Example:

    dbt3=# SELECT pgpart.detach_partition('public', 'orders', 'orders_1998');
     detach_partition
    ------------------
     t
    (1 row)
    
    dbt3=# 


pgpart.show_partition
---------------------

pgpart.show_partition() function lists partition name(s) which the specified table has.

    pgpart.show_partition(schema_name, table_name)

Parameters:

- schema_name : a schema name which contains the table.
- table_name : a table name which has its partition(s).

Example:

    dbt3=# SELECT pgpart.show_partition('public', 'orders');
     show_partition
    ----------------
     orders_1995
     orders_1996
     orders_1997
     orders_1998
    (4 rows)
    
    dbt3=# 


Author
======

    Satoshi Nagayasu <snaga@uptime.jp>

