-- Imported all CSV data into each table

-- Validate raw counts
SELECT 'daily_activity_features' AS table_name, COUNT(*) FROM daily_activity_features
UNION ALL
SELECT 'sleep_day_features', COUNT(*) FROM sleep_day_features
UNION ALL
SELECT 'user_engagement_summary', COUNT(*) FROM user_engagement_summary
UNION ALL
SELECT 'activity_by_day', COUNT(*) FROM activity_by_day
UNION ALL
SELECT 'sleep_by_day', COUNT(*) FROM sleep_by_day
UNION ALL
SELECT 'engagement_levels', COUNT(*) FROM engagement_levels
UNION ALL
SELECT 'engagement_vs_activity', COUNT(*) FROM engagement_vs_activity;

-- Date range and unique users

-- Daily activity coverage
SELECT
  MIN(activity_date) AS min_date,
  MAX(activity_date) AS max_date,
  COUNT(*) AS rows,
  COUNT(DISTINCT id) AS users
FROM daily_activity_features;

-- Sleep coverage
SELECT
  MIN(sleep_date) AS min_date,
  MAX(sleep_date) AS max_date,
  COUNT(*) AS rows,
  COUNT(DISTINCT id) AS users
FROM sleep_day_features;

-- Duplicate checks

-- Duplicates in daily activity
SELECT id, activity_date, COUNT(*) AS dup_count
FROM daily_activity_features
GROUP BY id, activity_date
HAVING COUNT(*) > 1;

-- Duplicates in sleep
SELECT id, sleep_day, COUNT(*) AS dup_count
FROM sleep_day_features
GROUP BY id, sleep_day
HAVING COUNT(*) > 1;

-- Null checks
SELECT
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS null_id,
  SUM(CASE WHEN activity_date IS NULL THEN 1 ELSE 0 END) AS null_activity_date,
  SUM(CASE WHEN total_steps IS NULL THEN 1 ELSE 0 END) AS null_steps
FROM daily_activity_features;

SELECT
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS null_id,
  SUM(CASE WHEN sleep_date IS NULL THEN 1 ELSE 0 END) AS null_sleep_date,
  SUM(CASE WHEN total_minutes_asleep IS NULL THEN 1 ELSE 0 END) AS null_sleep_minutes
FROM sleep_day_features;

-- “Impossible values” checks

-- Negative / unrealistic values in activity
SELECT *
FROM daily_activity_features
WHERE total_steps < 0
   OR calories < 0
   OR sedentary_minutes < 0
   OR total_active_minutes < 0
   OR (sedentary_minutes IS NOT NULL AND sedentary_minutes > 1440)
   OR (total_active_minutes IS NOT NULL AND total_active_minutes > 1440);

-- Negative / unrealistic values in sleep
SELECT *
FROM sleep_day_features
WHERE total_minutes_asleep < 0
   OR total_time_in_bed < 0
   OR (total_minutes_asleep IS NOT NULL AND total_minutes_asleep > 1440)
   OR (total_time_in_bed IS NOT NULL AND total_time_in_bed > 1440);

-- Activity / Sleep overlap
SELECT
  COUNT(*) AS matched_days
FROM daily_activity_features a
JOIN sleep_day_features s
  ON a.id = s.id
 AND a.activity_date = s.sleep_date;

SELECT
  COUNT(DISTINCT a.id) AS users_with_both
FROM daily_activity_features a
JOIN sleep_day_features s
  ON a.id = s.id
 AND a.activity_date = s.sleep_date;