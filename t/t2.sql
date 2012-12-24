BEGIN;
SELECT plan(21);

CREATE TABLE orders (
  orderkey INTEGER PRIMARY KEY,
  orderdate DATE NOT NULL
);

INSERT INTO orders VALUES ( 1001, '2009-10-01' );
INSERT INTO orders VALUES ( 1002, '2010-10-01' );
INSERT INTO orders VALUES ( 1003, '2011-10-01' );

--
-- partition to be attached.
--
CREATE TABLE orders_2012 (
  orderkey INTEGER PRIMARY KEY,
  orderdate DATE NOT NULL
);

INSERT INTO orders_2012 VALUES ( 1004, '2012-10-01' );

\d+

--
-- start tests here.
--
SELECT tables_are (
        'public',
        ARRAY[
        'orders',
        'orders_2012'
        ]
);

SELECT results_eq (
        'SELECT * FROM orders',
	$$ VALUES (1001, '2009-10-01'::date), (1002, '2010-10-01'), (1003, '2011-10-01') $$
);

SELECT results_eq (
        'SELECT * FROM orders_2012',
	$$ VALUES (1004, '2012-10-01'::date) $$
);

--
-- Add a partition
--
SELECT results_eq (
	$$ SELECT pgpart.add_partition ('public','orders','orders_2011',' ''2011-01-01'' <= orderdate AND orderdate < ''2012-01-01'' ','/tmp/orders_2011.data')::text $$,
	ARRAY [ 'true' ]
);

SELECT tables_are (
        'public',
        ARRAY[
        'orders',
        'orders_2011',
        'orders_2012'
        ]
);

SELECT results_eq (
        'SELECT pgpart.show_partition(''public'', ''orders'')',
	ARRAY [ 'orders_2011'::name ]
);

SELECT results_eq (
        'SELECT * FROM orders',
	$$ VALUES (1001, '2009-10-01'::date), (1002, '2010-10-01'), (1003, '2011-10-01') $$
);

SELECT results_eq (
        'SELECT * FROM orders_2011',
	$$ VALUES (1003, '2011-10-01'::date) $$
);

--
-- Attach partition
--
SELECT results_eq (
	$$ SELECT pgpart.attach_partition ('public', 'orders', 'orders_2012', ' ''2012-01-01'' <= orderdate AND orderdate < ''2013-01-01'' ')::text $$,
	ARRAY [ 'true' ]
);

SELECT tables_are (
        'public',
        ARRAY[
        'orders',
        'orders_2011',
        'orders_2012'
        ]
);

SELECT results_eq (
        'SELECT pgpart.show_partition(''public'', ''orders'')',
	ARRAY [ 'orders_2011'::name, 'orders_2012' ]
);

SELECT results_eq (
        'SELECT * FROM orders ORDER BY orderdate',
	$$ VALUES (1001, '2009-10-01'::date), (1002, '2010-10-01'), (1003, '2011-10-01'), (1004, '2012-10-01'::date) $$
);

SELECT results_eq (
        'SELECT * FROM orders_2012',
	$$ VALUES (1004, '2012-10-01'::date) $$
);

--
-- Detach partition
--
\d+ orders_2011

SELECT results_eq (
	$$ SELECT pgpart.detach_partition('public', 'orders', 'orders_2011')::text $$,
	ARRAY [ 'true' ]
);

SELECT tables_are (
        'public',
        ARRAY[
        'orders',
        'orders_2011',
        'orders_2012'
        ]
);

SELECT results_eq (
        'SELECT pgpart.show_partition(''public'', ''orders'')',
	ARRAY [ 'orders_2012'::name ]
);

SELECT results_eq (
        'SELECT * FROM orders ORDER BY orderdate',
	$$ VALUES (1001, '2009-10-01'::date), (1002, '2010-10-01'), (1004, '2012-10-01') $$
);

SELECT results_eq (
        'SELECT * FROM orders_2011',
	$$ VALUES (1003, '2011-10-01'::date) $$
);

\d+ orders

--
-- Merge partition
--
SELECT results_eq (
	$$ SELECT pgpart.merge_partition('public', 'orders', 'orders_2012', null, '/tmp/orders_2012.data')::text $$,
	ARRAY [ 'true' ]
);

SELECT tables_are (
        'public',
        ARRAY[
        'orders',
        'orders_2011'
        ]
);

SELECT results_eq (
        'SELECT * FROM orders ORDER BY orderdate',
	$$ VALUES (1001, '2009-10-01'::date), (1002, '2010-10-01'), (1004, '2012-10-01') $$
);

-- SELECT * FROM orders;


SELECT * FROM finish();
ROLLBACK;
