-- Run against a disposable course demonstration database.
-- This transaction demonstrates DDL and DML without deleting operational history.
BEGIN;
CREATE TABLE demo_capacity_review(id integer PRIMARY KEY, zone_name text NOT NULL, proposed_capacity integer CHECK(proposed_capacity>0));
ALTER TABLE demo_capacity_review ADD COLUMN reviewed boolean NOT NULL DEFAULT false;
INSERT INTO demo_capacity_review(id,zone_name,proposed_capacity) VALUES(1,'Main Stage',8000),(2,'Food Court',1500);
UPDATE demo_capacity_review SET reviewed=true WHERE id=1;
SELECT * FROM demo_capacity_review WHERE reviewed=true ORDER BY proposed_capacity DESC;
DELETE FROM demo_capacity_review WHERE id=2;
DROP TABLE demo_capacity_review;
COMMIT;
-- Operational joins/aggregations/window functions are in advanced-queries.sql.
