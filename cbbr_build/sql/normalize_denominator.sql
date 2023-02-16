ALTER TABLE cbbr_submissions
    DROP COLUMN IF EXISTS denominator;

ALTER TABLE cbbr_submissions
    ADD COLUMN denominator text;

WITH denominatorcount AS (
    SELECT
        commdist,
        type_br,
        COUNT(*) AS count
    FROM
        cbbr_submissions
    GROUP BY
        commdist,
        type_br)
UPDATE
    cbbr_submissions a
SET
    denominator = b.count
FROM
    denominatorcount b
WHERE
    a.commdist = b.commdist
    AND a.type_br = b.type_br;

