UPDATE cbbr_submissions a
SET commdist = '1'||lpad(commdist, 2, '0')
WHERE a.borough='Manhattan'
AND length(commdist)>3;

UPDATE cbbr_submissions a
SET commdist = '2'||lpad(commdist, 2, '0')
WHERE a.borough='Bronx'
AND length(commdist)>3;

UPDATE cbbr_submissions a
SET commdist = '3'||lpad(commdist, 2, '0')
WHERE a.borough='Brooklyn'
AND length(commdist)>3;

UPDATE cbbr_submissions a
SET commdist = '4'||lpad(commdist, 2, '0')
WHERE a.borough='Queens'
AND length(commdist)>3;

UPDATE cbbr_submissions a
SET commdist = '5'||lpad(commdist, 2, '0')
WHERE a.borough='Staten Island'
AND length(commdist)>3;