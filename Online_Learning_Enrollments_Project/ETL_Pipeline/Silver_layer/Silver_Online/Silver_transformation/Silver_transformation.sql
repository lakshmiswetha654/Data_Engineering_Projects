CREATE OR REFRESH MATERIALIZED VIEW silver_enrollments_clean (
  CONSTRAINT valid_progress EXPECT (progress_pct BETWEEN 0 AND 100) ON VIOLATION DROP ROW,
  CONSTRAINT valid_price    EXPECT (price_paid >= 0)                ON VIOLATION DROP ROW
) AS
WITH cleaned AS (
  SELECT DISTINCT
    enrollment_id, course_name, enrollment_date, progress_pct, discount_amount,
    LOWER(TRIM(learner_email))                          AS learner_email,
    COALESCE(INITCAP(TRIM(category)), 'Unknown')        AS category,
    INITCAP(TRIM(course_level))                         AS course_level,
    COALESCE(price_paid, list_price - discount_amount)  AS price_paid,
    COALESCE(INITCAP(TRIM(learner_city)),'Unknown')     AS learner_city,
    COALESCE(INITCAP(TRIM(enrollment_channel)),'Unknown')     AS enrollment_channel,
    COALESCE(TRY_CAST(hours_watched AS INT),0)           AS hours_watched,
    COALESCE(TRY_CAST(course_rating AS INT),0)           AS course_rating,
    COALESCE (INITCAP(TRIM(instructor_name)),'Unknown')  AS instructor_name
FROM bronze_online_enrollments
)
SELECT *,
  CASE WHEN progress_pct = 100 THEN 'Completed'
       WHEN progress_pct > 0   THEN 'In Progress'
       ELSE 'Not Started' END AS learner_status
FROM cleaned;
 
CREATE OR REFRESH MATERIALIZED VIEW silver_enrollments_rejected AS
SELECT *,
  CASE WHEN progress_pct < 0 OR progress_pct > 100 THEN 'Progress is outside 0 to 100'
       ELSE 'Price paid is negative' END AS reject_reason
FROM bronze_online_enrollments
WHERE progress_pct < 0 OR progress_pct > 100 OR price_paid < 0;

