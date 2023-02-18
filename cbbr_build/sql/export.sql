-- Create tables to export and reorder and rename columns
-- cbbr_submissions_needgeoms
DROP TABLE IF EXISTS cbbr_submissions_needgeoms;

SELECT
    * INTO cbbr_submissions_needgeoms
FROM
    _cbbr_submissions
WHERE
    geom IS NULL;

-- cbbr_export
DROP TABLE IF EXISTS cbbr_export;

SELECT
    tracking_code AS trackingnum,
    borough,
    cd,
    commdist,
    type_br,
    priority,
    agency_acronym AS agencyacro,
    agency,
    need,
    request,
    explanation,
    facility_or_park_name AS sitename,
    address,
    street_name AS streetsegment,
    between_cross_street_1 AS streetcross1,
    and_cross_street_2 AS streetcross2,
    (
        CASE WHEN supporters_1 IS NULL
            OR supporters_1 IN ('', ' ', 'n/a') THEN
            NULL
        ELSE
            supporters_1
        END) AS supporters1,
    (
        CASE WHEN supporters_2 IS NULL
            OR supporters_2 IN ('', ' ', 'n/a') THEN
            NULL
        ELSE
            supporters_2
        END) AS supporters2,
    parent_tracking_code,
    agency_category_response AS agyresponsecat,
    agency_response AS agyresponse,
    unique_id,
    geo_function,
    geom INTO cbbr_export
FROM
    _cbbr_submissions;

-- cbbr_export_poly
DROP TABLE IF EXISTS cbbr_export_poly;

SELECT
    * INTO cbbr_export_poly
FROM
    cbbr_export
WHERE
    ST_GeometryType (geom) = 'ST_MultiPolygon';

-- cbbr_export_pts
DROP TABLE IF EXISTS cbbr_export_pts;

SELECT
    * INTO cbbr_export_pts
FROM
    cbbr_export
WHERE
    ST_GeometryType (geom) = 'ST_MultiPoint';

-- drop geom column from cbbr_export
ALTER TABLE cbbr_export
    DROP COLUMN IF EXISTS geom;

