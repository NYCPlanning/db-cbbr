-- Apply updates to agency and acronym
UPDATE cbbr_submissions 
SET agency = a.agency,
    agencyacro = a.agencyacro
FROM cbbr_agency_updates a 
WHERE cbbr_submissions.tracking_code = a.trkno