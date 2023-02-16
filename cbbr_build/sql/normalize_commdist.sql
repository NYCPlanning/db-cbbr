ALTER TABLE cbbr_submissions
    DROP COLUMN IF EXISTS commdist;

ALTER TABLE cbbr_submissions
    ADD COLUMN commdist text;

-- OPTION A: Use provided FY2024 values
-- UPDATE
--     cbbr_submissions
-- SET
--     commdist = boro_and_board;
-- OPTION B: Construct values to align with previous CBBR versions
UPDATE
    cbbr_submissions a
SET
    commdist = '1' || board
WHERE
    a.boro_name = 'Manhattan'
    AND commdist IS NULL;

UPDATE
    cbbr_submissions a
SET
    commdist = '2' || board
WHERE
    a.boro_name = 'Bronx'
    AND commdist IS NULL;

UPDATE
    cbbr_submissions a
SET
    commdist = '3' || board
WHERE
    a.boro_name = 'Brooklyn'
    AND commdist IS NULL;

UPDATE
    cbbr_submissions a
SET
    commdist = '4' || board
WHERE
    a.boro_name = 'Queens'
    AND commdist IS NULL;

UPDATE
    cbbr_submissions a
SET
    commdist = '5' || board
WHERE
    a.boro_name = 'Staten Island'
    AND commdist IS NULL;

