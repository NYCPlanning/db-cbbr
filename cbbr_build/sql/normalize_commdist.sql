UPDATE cbbr_submissions a
SET commdist = '1'||lpad(commdist, 2, '0')
WHERE a.borough='Manhattan';

UPDATE cbbr_submissions a
SET commdist = '2'||lpad(commdist, 2, '0')
WHERE a.borough='Bronx';

UPDATE cbbr_submissions a
SET commdist = '3'||lpad(commdist, 2, '0')
WHERE a.borough='Brooklyn';

UPDATE cbbr_submissions a
SET commdist = '4'||lpad(commdist, 2, '0')
WHERE a.borough='Queens';

UPDATE cbbr_submissions a
SET commdist = '5'||lpad(commdist, 2, '0')
WHERE a.borough='Staten Island';