-- creating the cbbr_submissions table

DROP TABLE IF EXISTS cbbr_submissions;

CREATE TABLE cbbr_submissions AS (
WITH unioned AS (
SELECT
	regid,
	regdate,
	progress,
	parentregid,
	parentfieldid,
	need,
	request,
	description,
	supporters1,
	supporters2,
	agency,
	budgetcategory,
	priority,
	conornew,
	trackingnum,
	firstyrsubmitted,
	site1,
	sitename,
	addressnum,
	streetname,
	blocknum,
	lotnum,
	streetsegment,
	streetcross1,
	streetcross2,
	refname,
	kill
FROM cbbr_requests_main
UNION ALL 
SELECT 
	regid,
	regdate,
	progress,
	parentregid,
	parentfieldid,
	need,
	request,
	description,
	supporters1,
	supporters2,
	agency,
	budgetcategory,
	priority,
	conornew,
	trackingnum,
	firstyrsubmitted,
	site1,
	sitename,
	addressnum,
	streetname,
	blocknum,
	lotnum,
	streetsegment,
	streetcross1,
	streetcross2,
	refname,
	kill
FROM cbbr_requests_other)

SELECT b.name, b.borough, b.commdist, a.*
FROM unioned a
LEFT JOIN 
cbbr_commboard_regid b
ON b.regid = a.parentregid
);

ALTER TABLE cbbr_submissions ADD geomsource text;
ALTER TABLE cbbr_submissions ADD dataname text;
ALTER TABLE cbbr_submissions ADD datasource text;

SELECT AddGeometryColumn ('public','cbbr_submissions','geom',4326,'Geometry',2);
