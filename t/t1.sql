--
-- This test script needs pgTap to perform.
--
BEGIN;
SELECT plan(6);

SELECT results_eq (
        $$ SELECT pgpart._get_index_column_name ('CREATE INDEX t1_uname_idx ON t1 USING btree (uname)') $$,
	ARRAY[ 'uname' ]
);

SELECT results_eq (
        $$ SELECT pgpart._get_index_column_name ('CREATE INDEX contacts_updated_at_created_at_ix ON contacts USING btree (updated_at DESC, created_at DESC)') $$,
	ARRAY[ 'updated_at_DESC_created_at_DESC' ]
);

SELECT results_eq (
        $$ SELECT pgpart._get_index_column_name ('CREATE INDEX t1_uname_idx ON t1 USING btree (uname::text)') $$,
	ARRAY[ 'uname' ]
);

SELECT results_eq (
        $$ SELECT pgpart._get_index_column_name ('CREATE INDEX t1_lower_uname_idx ON t1 USING btree (lower(((uname)::name)::text))') $$,
	ARRAY[ 'lower_uname' ]
);

SELECT results_eq (
        $$ SELECT pgpart._get_index_column_name ('CREATE INDEX foo ON t1 USING btree (split_part(email::text, ''@''::text, 2))') $$,
	ARRAY[ 'split_part_email_2' ]
);

SELECT results_eq (
        $$ SELECT pgpart._get_index_column_name ('CREATE INDEX t1_lower_uname_idx ON t1 USING btree (lower(email::text))') $$,
	ARRAY[ 'lower_email' ]
);

SELECT * FROM finish();
ROLLBACK;
