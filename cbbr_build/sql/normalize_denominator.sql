ALTER TABLE _cbbr_submissions
    DROP COLUMN IF EXISTS denominator;

ALTER TABLE _cbbr_submissions
    ADD COLUMN denominator text;

WITH denominatorcount AS (
    SELECT
        commdist,
        "type",
        COUNT(*) AS count
    FROM
        _cbbr_submissions
    GROUP BY
        commdist,
        "type")
UPDATE
    _cbbr_submissions a
SET
    denominator = b.count
FROM
    denominatorcount b
WHERE
    a.commdist = b.commdist
    AND a.type = b.type;

