ALTER TABLE cbbr_submissions
DROP COLUMN IF EXISTS commdist;
ALTER TABLE cbbr_submissions
ADD COLUMN commdist text;

UPDATE cbbr_submissions a
SET commdist = '1'||lpad(cd, 2, '0')
WHERE a.borough='Manhattan'
AND commdist IS NULL;

UPDATE cbbr_submissions a
SET commdist = '2'||lpad(cd, 2, '0')
WHERE a.borough='Bronx'
AND commdist IS NULL;

UPDATE cbbr_submissions a
SET commdist = '3'||lpad(cd, 2, '0')
WHERE a.borough='Brooklyn'
AND commdist IS NULL;

UPDATE cbbr_submissions a
SET commdist = '4'||lpad(cd, 2, '0')
WHERE a.borough='Queens'
AND commdist IS NULL;

UPDATE cbbr_submissions a
SET commdist = '5'||lpad(cd, 2, '0')
WHERE a.borough='Staten Island'
AND commdist IS NULL;