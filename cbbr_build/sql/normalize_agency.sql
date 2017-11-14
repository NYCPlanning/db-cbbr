-- setting the agency name
UPDATE cbbr_submissions 
SET agency = 'Administration for Childrens Services'
WHERE lower(agency) LIKE '%children%';

UPDATE cbbr_submissions 
SET agency = 'Brooklyn Public Library'
WHERE lower(agency) LIKE 'if%bpl%' AND borough = 'Brooklyn';

UPDATE cbbr_submissions 
SET agency = 'City University of New York'
WHERE lower(agency) LIKE '%city%university%';

UPDATE cbbr_submissions 
SET agency = 'Department for the Aging'
WHERE lower(agency) LIKE '%aging%';

UPDATE cbbr_submissions
SET agency = 'Department of Buildings'
WHERE lower(agency) LIKE '%buildings%';

UPDATE cbbr_submissions 
SET agency = 'Department of City Planning'
WHERE lower(agency) LIKE '%planning%';

UPDATE cbbr_submissions 
SET agency = 'Department of Citywide Administrative Services'
WHERE lower(agency) LIKE '%administrative%';

UPDATE cbbr_submissions
SET agency = 'Department of Consumer Affairs'
WHERE lower(agency) LIKE '%consumer%';

UPDATE cbbr_submissions
SET agency = 'Department of Correction'
WHERE lower(agency) LIKE '%correction%';

UPDATE cbbr_submissions
SET agency = 'Department of Cultural Affairs'
WHERE lower(agency) LIKE '%cultural%';

UPDATE cbbr_submissions
SET agency = 'Department of Design and Construction'
WHERE lower(agency) LIKE '%design%';

UPDATE cbbr_submissions
SET agency = 'Department of Education'
WHERE lower(agency) LIKE '%education%';

UPDATE cbbr_submissions
SET agency = 'Department of Environmental Protection'
WHERE lower(agency) LIKE '%environmental%';

UPDATE cbbr_submissions
SET agency = 'Department of Health and Mental Hygiene'
WHERE lower(agency) LIKE '%mental%';

UPDATE cbbr_submissions
SET agency = 'Department of Homeless Services'
WHERE lower(agency) LIKE '%homeless%';

UPDATE cbbr_submissions
SET agency = 'Department of Housing Preservation and Development'
WHERE lower(agency) LIKE '%preservation%';

UPDATE cbbr_submissions
SET agency = 'Department of Information Technology and Telecommunications'
WHERE lower(agency) LIKE '%technology%';

UPDATE cbbr_submissions
SET agency = 'Department of Parks and Recreation'
WHERE lower(agency) LIKE '%parks%';

UPDATE cbbr_submissions
SET agency = 'Department of Probation'
WHERE lower(agency) LIKE '%probation%';

UPDATE cbbr_submissions
SET agency = 'Department of Sanitation'
WHERE lower(agency) LIKE '%sanitation%';

UPDATE cbbr_submissions
SET agency = 'Department of Small Business Services'
WHERE lower(agency) LIKE '%small%';

UPDATE cbbr_submissions
SET agency = 'Department of Transportation'
WHERE lower(agency) LIKE '%transportation%';

UPDATE cbbr_submissions
SET agency = 'Department of Youth and Community Development'
WHERE lower(agency) LIKE '%youth%';

UPDATE cbbr_submissions
SET agency = 'Economic Development Corporation'
WHERE lower(agency) LIKE '%economic%';

UPDATE cbbr_submissions
SET agency = 'Fire Department'
WHERE lower(agency) LIKE '%fire%';

UPDATE cbbr_submissions
SET agency = 'Health and Hospitals Corporation'
WHERE lower(agency) LIKE '%hospitals%';

UPDATE cbbr_submissions
SET agency = 'Human Resources Administration'
WHERE lower(agency) LIKE '%social services%' OR lower(agency) LIKE '%human resources%';

UPDATE cbbr_submissions
SET agency = 'Landmarks Preservation Commission'
WHERE lower(agency) LIKE '%landmarks%';

UPDATE cbbr_submissions
SET agency = 'New York City Housing Authority'
WHERE lower(agency) LIKE '%nycha%';

UPDATE cbbr_submissions
SET agency = 'New York City Transit Authority'
WHERE lower(agency) LIKE '%transit%';

UPDATE cbbr_submissions
SET agency = 'New York Public Library'
WHERE lower(agency) LIKE 'if%nypl%' OR lower(agency) LIKE '%(nypl)%' AND borough <> 'Queens' AND borough <> 'Brooklyn';

UPDATE cbbr_submissions
SET agency = 'New York Research Libraries'
WHERE lower(agency) LIKE '%research libraries%';

UPDATE cbbr_submissions
SET agency = 'Office of Management and Budget'
WHERE lower(agency) LIKE '%budget%';

UPDATE cbbr_submissions
SET agency = 'Other'
WHERE lower(agency) LIKE '%other%';

UPDATE cbbr_submissions
SET agency = 'Police Department'
WHERE lower(agency) LIKE '%police%';

UPDATE cbbr_submissions
SET agency = 'Queens Public Library'
WHERE lower(agency) LIKE 'if%qpl%' AND borough = 'Queens';

UPDATE cbbr_submissions
SET agency = 'School Construction Authority'
WHERE lower(agency) LIKE '%school construction authority%';

UPDATE cbbr_submissions
SET agency = 'Taxi and Limousine Commission'
WHERE lower(agency) LIKE '%taxi%';
