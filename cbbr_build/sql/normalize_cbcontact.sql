-- Append agency contact info onto each record

-- create table of agency contact info
DROP TABLE IF EXISTS cbbr_cbcontacts;
CREATE TABLE cbbr_cbcontacts (
parentregid,
fullboardname,
first,
last,
title,
email,
phone
);

COPY cbbr_cbcontacts FROM '/prod/db-cbbr/cbbr_build/cbbr_cbcontacts.csv' DELIMITER ',' CSV;

-- append agency contact info
UPDATE cbbr_submissions
SET first = b.first,
	last = b.last,
	title = b.title,
	email = b.email,
	phone = b.phone
FROM cbbr_cbcontacts b
WHERE regid in (SELECT DISTINCT regid FROM cbbr_cdwide)
;