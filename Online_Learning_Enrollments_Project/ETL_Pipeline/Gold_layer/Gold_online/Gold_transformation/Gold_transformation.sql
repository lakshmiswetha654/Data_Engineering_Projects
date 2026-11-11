CREATE OR REFRESH MATERIALIZED VIEW gold_data_quality AS
SELECT COUNT(*)                                                   AS bronze_rows,
       COUNT(*) - COUNT(DISTINCT enrollment_id)                   AS duplicate_rows,
       SUM(CASE WHEN progress_pct < 0 OR progress_pct > 100 THEN 1 ELSE 0 END) AS invalid_progress_rows,
       COUNT(DISTINCT learner_email)                              AS learners_before_email_fix,
       COUNT(DISTINCT LOWER(TRIM(learner_email)))                 AS learners_after_email_fix,
       SUM(CASE WHEN list_price <0 THEN 1 ELSE 0 END)             AS negative_price,
       SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END )         AS missing_category,
       SUM(CASE WHEN learner_city IS NULL THEN 1 ELSE 0 END)      AS missing_city,
       SUM(CASE WHEN list_price IS NULL THEN 1 ELSE 0 END)        AS missing_price_rows,
                      
       (SELECT COUNT(*) FROM silver_enrollments_clean)            AS clean_rows,
       (SELECT COUNT(*) FROM silver_enrollments_rejected)         AS rejected_rows
FROM bronze_online_enrollments;
CREATE OR REFRESH MATERIALIZED VIEW gold_monthly_enrollments AS
SELECT DATE_TRUNC('MONTH', enrollment_date)                     AS enrollment_month,
       COUNT(*)                                                 AS enrollments,
       COUNT(DISTINCT learner_email)                            AS unique_learners,
       SUM(price_paid)                                          AS revenue,
       SUM(CASE WHEN learner_status = 'Completed' THEN 1 ELSE 0 END) AS completions,
       SUM(hours_watched)                                       AS hours_watched
FROM silver_enrollments_clean
GROUP BY DATE_TRUNC('MONTH', enrollment_date);
Create or refresh materialized view gold_category_summary as 
          SELECT  category,
          COUNT(*)                                             AS enrollments,
          SUM(price_paid)                                             AS revenue,
          SUM(CASE WHEN learner_status ='Completed' THEN 1 ELSE 0 END) As completed,
          SUM(CASE WHEN learner_status='in_progress' THEN 1 ELSE 0 END) AS in_progress,
          SUM(CASE WHEN learner_status='not_started' THEN 1 ELSE 0 END) AS not_started,
          AVG(progress_pct)                                           AS avg_progress_pct,
          ROUND(
        SUM(CASE WHEN learner_status='Completed' THEN 1 ELSE 0 END) * 100 /NULLIF(COUNT(*),0),2
       )        AS completion_rate_pct 
FROM silver_enrollments_clean
GROUP BY category;  
CREATE OR REFRESH MATERIALIZED VIEW gold_course_suummary AS 
SELECT course_name,
COUNT(*)                                AS enrollments,
       SUM(price_paid)                                AS revenue,
       ROUND(
       SUM(CASE WHEN learner_status='Completed' THEN 1 ELSE 0 END)*100/NULLIF(COUNT(*)
       ,0),2
       )        AS completion_rate_pct,
       AVG(course_rating)                            AS avg_rating,
       SUM(hours_watched)                            AS hours_watches
 FROM silver_enrollments_clean
 GROUP BY category, course_name, course_level, instructor_name;
 CREATE OR REFRESH MATERIALIZED VIEW gold_channel_summary AS 
 SELECT enrollment_channel,
 count(*)                                   AS enrollments,
 SUM(price_paid)                                   AS revenue,
 ROUND(
    SUM(CASE WHEN learner_status='Completed' THEN 1 ELSE 0 END)*100/NULLIF (COUNT(*),0),2) AS completion_rate_pct
    FROM silver_enrollments_clean
    GROUP BY enrollment_channel;


 



      








