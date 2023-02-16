-- create the agency field
ALTER TABLE _cbbr_submissions
    DROP COLUMN IF EXISTS agency_normalized;

ALTER TABLE _cbbr_submissions
    ADD COLUMN agency_normalized text;

-- setting the agency name
UPDATE
    _cbbr_submissions
SET
    agency_normalized = (
        CASE WHEN agency_name = 'ACS' THEN
            upper('Administration for Children''s Services')
        WHEN agency_name = 'BPL' THEN
            upper('Brooklyn Public Library')
        WHEN agency_name = 'CEOM' THEN
            upper('Citywide Event Coordination and Management')
        WHEN agency_name = 'DCA' THEN
            upper('Department of Consumer Affairs')
        WHEN agency_name = 'DCAS' THEN
            upper('Department of Citywide Administrative Services')
        WHEN agency_name = 'DCLA' THEN
            upper('Department of Cultural Affairs')
        WHEN agency_name = 'DCP' THEN
            upper('Department of City Planning')
        WHEN agency_name = 'DEP' THEN
            upper('Department of Environmental Protection')
        WHEN agency_name = 'DFTA' THEN
            upper('Department for the Aging')
        WHEN agency_name = 'DHS' THEN
            upper('Department of Homeless Services')
        WHEN agency_name = 'DHS, HRA' THEN
            upper('Department of Homeless Services / Human Resources Administration')
        WHEN agency_name = 'DOB' THEN
            upper('Department of Buildings')
        WHEN agency_name = 'DOE' THEN
            upper('Department of Education')
        WHEN agency_name = 'DOHMH' THEN
            upper('Department of Health and Mental Hygiene')
        WHEN agency_name = 'DOITT' THEN
            upper('Dept of Information Technology & Telecommunications')
        WHEN agency_name = 'DOT' THEN
            upper('Department of Transportation')
        WHEN agency_name = 'DPR' THEN
            upper('Department of Parks and Recreation')
        WHEN agency_name = 'DSNY' THEN
            upper('Department of Sanitation')
        WHEN agency_name = 'DYCD' THEN
            upper('Department of Youth & Community Development')
        WHEN agency_name = 'EDC' THEN
            upper('Economic Development Corporation')
        WHEN agency_name = 'FDNY' THEN
            upper('Fire Department')
        WHEN agency_name = 'HHC' THEN
            upper('Health and Hospitals Corporation')
        WHEN agency_name = 'HPD' THEN
            upper('Department of Housing Preservation & Development')
        WHEN agency_name = 'HRA' THEN
            upper('Human Resources Administration')
        WHEN agency_name = 'LPC' THEN
            upper('Landmarks Preservation Commission')
        WHEN agency_name = 'MOCJ' THEN
            upper('Mayor''s Office of Criminal Justice')
        WHEN agency_name = 'MOME' THEN
            upper('Mayor''s Office of Media and Entertainment')
        WHEN agency_name = 'NYCHA' THEN
            upper('Housing Authority')
        WHEN agency_name = 'NYCTA' THEN
            upper('Transit Authority')
        WHEN agency_name = 'NYPD' THEN
            upper('Police Department')
        WHEN agency_name = 'NYPL' THEN
            upper('New York Public Library')
        WHEN agency_name = 'OEM' THEN
            upper('Office of Emergency Management')
        WHEN agency_name = 'OMB' THEN
            upper('Mayor''s Office of Management and Budget')
        WHEN agency_name = 'QPL' THEN
            upper('Queens Borough Public Library')
        WHEN agency_name = 'SBS' THEN
            upper('Department of Small Business Services')
        WHEN agency_name = 'SCA' THEN
            upper('School Construction Authority')
        WHEN agency_name = 'TLC' THEN
            upper('Taxi and Limousine Commission')
        ELSE
            NULL
        END);

