-- create the agency field
ALTER TABLE cbbr_submissions
DROP COLUMN IF EXISTS agency;
ALTER TABLE cbbr_submissions
ADD COLUMN agency text;

-- setting the agency name
UPDATE cbbr_submissions 
SET agency = (CASE 
		WHEN agency_acronym = 'ACS' THEN upper('Administration for Childrens Services')
		WHEN agency_acronym = 'BPL' THEN upper('Brooklyn Public Library')
		WHEN agency_acronym = 'DCAS' THEN upper('Department of Citywide Administrative Services')
		WHEN agency_acronym = 'DCLA' THEN upper('Department of Cultural Affairs')
		WHEN agency_acronym = 'DCP' THEN upper('Department of City Planning')
		WHEN agency_acronym = 'DEP' THEN upper('Department of Environmental Protection')
		WHEN agency_acronym = 'DFTA' THEN upper('Department for the Aging')
		WHEN agency_acronym = 'DHS' THEN upper('Department of Homeless Services')
		WHEN agency_acronym = 'DHS, HRA' THEN upper('Department of Homeless Services / Human Resources Administration')
		WHEN agency_acronym = 'DOB' THEN upper('Department of Buildings')
		WHEN agency_acronym = 'DOE' THEN upper('Department of Education')
		WHEN agency_acronym = 'DOHMH' THEN upper('Department of Health and Mental Hygiene')
		WHEN agency_acronym = 'DOITT' THEN upper('Department of Information Technology and Telecommunications')
		WHEN agency_acronym = 'DOT' THEN upper('Department of Transportation')
		WHEN agency_acronym = 'DPR' THEN upper('Department of Parks and Recreation')
		WHEN agency_acronym = 'DSNY' THEN upper('Department of Sanitation')
		WHEN agency_acronym = 'DYCD' THEN upper('Department of Youth and Community Development')
		WHEN agency_acronym = 'EDC' THEN upper('Economic Development Corporation')
		WHEN agency_acronym = 'FDNY' THEN upper('NYC FIRE DEPARTMENT')
		WHEN agency_acronym = 'HHC' THEN upper('Health and Hospitals Corporation')
		WHEN agency_acronym = 'HPD' THEN upper('DEPARTMENT OF HOUSING PRESERVATION AND DEVELOPMENT')
		WHEN agency_acronym = 'HRA' THEN upper('HUMAN RESOURCES ADMINISTRATION')
		WHEN agency_acronym = 'LPC' THEN upper('Landmarks Preservation Commission')
		WHEN agency_acronym = 'NYCHA' THEN upper('New York City Housing Authority')
		WHEN agency_acronym = 'NYCTA' THEN upper('NYC TRANSIT AUTHORITY')
		WHEN agency_acronym = 'NYPD' THEN upper('NYC POLICE DEPARTMENT')
		WHEN agency_acronym = 'NYPL' THEN upper('New York Public Library')
		WHEN agency_acronym = 'OMB' THEN upper('Office of Management and Budget')
		WHEN agency_acronym = 'QL' THEN upper('Queens Public Library')
		WHEN agency_acronym = 'SBS' THEN upper('Department of Small Business Services')
		WHEN agency_acronym = 'SCA' THEN upper('School Construction Authority')
		WHEN agency_acronym = 'TLC' THEN upper('Taxi and Limousine Commission')
		ELSE NULL
	END);