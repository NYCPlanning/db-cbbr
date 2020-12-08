-- Reorder and rename columns to export
DROP TABLE IF EXISTS cbbr_export;
CREATE TABLE cbbr_export (
    trackingnum text,
    borough text,
    cd text,
    commdist text,
    type_br text,
    priority text,
    agencyacro text,
    agency text,
    need text,
    request text,
    explanation text,
    sitename text, 
    address text,
    streetsegment text,
    streetcross1 text,
    streetcross2 text,
    supporters1 text,
    supporters2 text,
    parent_tracking_code text,
    agyresponsecat text,
    agyresponse text,
    unique_id text,
    geom geometry(Geometry,4326));

INSERT INTO cbbr_export(
    trackingnum,
    borough,
    cd,
    commdist,
    type_br,
    priority,
    agencyacro,
    agency,
    need,
    request,
    explanation,
    sitename,
    address,
    streetsegment,
    streetcross1,
    streetcross2,
    supporters1,
    supporters2,
    parent_tracking_code,
    agyresponsecat,
    agyresponse,
    unique_id,
    geom
)

SELECT  
    tracking_code,
    borough,	
    cd,
    commdist,	
    type_br,		
    priority,	
    agency_acronym,
    agency,
    need,	
    request,
    explanation,
    facility_or_park_name,
    address,
    street_name,	
    between_cross_street_1,	
    and_cross_street_2,
    (CASE WHEN supporters_1 IS NULL
			OR supporters_1 IN ('', ' ', 'n/a') THEN NULL
	  ELSE supporters_1 END) as supporters1,
    (CASE WHEN supporters_2 IS NULL
			OR supporters_2 IN ('', ' ', 'n/a') THEN NULL
	  ELSE supporters_2 END) as supporters2,
    parent_tracking_code,
    agency_category_response,
    agency_response,
    unique_id,
    geom
FROM cbbr_submissions;