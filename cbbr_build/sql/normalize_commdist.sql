ALTER TABLE _cbbr_submissions
    DROP COLUMN IF EXISTS commdist;

ALTER TABLE _cbbr_submissions
    ADD COLUMN commdist text;

-- OPTION A: Use provided FY2024 values
-- UPDATE
--     _cbbr_submissions
-- SET
--     commdist = boro_and_board;
-- OPTION B: Construct values to align with previous CBBR versions
UPDATE
    _cbbr_submissions a
SET
    commdist = '1' || lpad(cd, 2, '0')
WHERE
    a.boro_name = 'Manhattan'
    AND commdist IS NULL;

UPDATE
    _cbbr_submissions a
SET
    commdist = '2' || lpad(cd, 2, '0')
WHERE
    a.boro_name = 'Bronx'
    AND commdist IS NULL;

UPDATE
    _cbbr_submissions a
SET
    commdist = '3' || lpad(cd, 2, '0')
WHERE
    a.boro_name = 'Brooklyn'
    AND commdist IS NULL;

UPDATE
    _cbbr_submissions a
SET
    commdist = '4' || lpad(cd, 2, '0')
WHERE
    a.boro_name = 'Queens'
    AND commdist IS NULL;

UPDATE
    _cbbr_submissions a
SET
    commdist = '5' || lpad(cd, 2, '0')
WHERE
    a.boro_name = 'SI'
    AND commdist IS NULL;

