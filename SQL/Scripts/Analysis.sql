																-- Business Queries

																-- Activity trends
-- Overall activity summary
SELECT
  COUNT(*) AS days,
  COUNT(DISTINCT id) AS users,
  ROUND(AVG(total_steps), 0) AS avg_steps,
  ROUND(AVG(total_active_minutes), 1) AS avg_active_minutes,
  ROUND(AVG(calories), 0) AS avg_calories
FROM daily_activity_features;

-- Weekday pattern
SELECT
  day_of_week,
  COUNT(*) AS days,
  ROUND(AVG(total_steps), 0) AS avg_steps,
  ROUND(AVG(total_active_minutes), 1) AS avg_active_minutes,
  ROUND(AVG(calories), 0) AS avg_calories
FROM daily_activity_features
GROUP BY day_of_week
ORDER BY CASE day_of_week
  WHEN 'Mon' THEN 1 WHEN 'Tue' THEN 2 WHEN 'Wed' THEN 3
  WHEN 'Thu' THEN 4 WHEN 'Fri' THEN 5 WHEN 'Sat' THEN 6
  WHEN 'Sun' THEN 7 ELSE 8 END;

															-- Sleep Trends
-- Overall sleep summary
SELECT
  COUNT(*) AS nights,
  COUNT(DISTINCT id) AS users,
  ROUND(AVG(total_minutes_asleep) / 60.0, 2) AS avg_sleep_hours,
  ROUND(AVG(total_time_in_bed) / 60.0, 2) AS avg_time_in_bed_hours
FROM sleep_day_features;

-- Sleep by weekday
SELECT
  day_of_week,
  COUNT(*) AS nights,
  ROUND(AVG(total_minutes_asleep) / 60.0, 2) AS avg_sleep_hours,
  ROUND(AVG(total_time_in_bed) / 60.0, 2) AS avg_time_in_bed_hours
FROM sleep_day_features
GROUP BY day_of_week
ORDER BY CASE day_of_week
  WHEN 'Mon' THEN 1 WHEN 'Tue' THEN 2 WHEN 'Wed' THEN 3
  WHEN 'Thu' THEN 4 WHEN 'Fri' THEN 5 WHEN 'Sat' THEN 6
  WHEN 'Sun' THEN 7 ELSE 8 END;

														-- Weekday vs weekend behavior

--Activity: weekday vs weekend
SELECT
  is_weekend,
  COUNT(*) AS days,
  ROUND(AVG(total_steps), 0) AS avg_steps,
  ROUND(AVG(total_active_minutes), 1) AS avg_active_minutes
FROM daily_activity_features
GROUP BY is_weekend
ORDER BY is_weekend;

-- Sleep: weekday vs weekend
SELECT
  is_weekend,
  COUNT(*) AS nights,
  ROUND(AVG(total_minutes_asleep) / 60.0, 2) AS avg_sleep_hours
FROM sleep_day_features
GROUP BY is_weekend
ORDER BY is_weekend;

														-- Engagement & consistency

-- Engagement & consistency
SELECT
  engagement_level,
  COUNT(*) AS users
FROM engagement_levels
GROUP BY engagement_level
ORDER BY users DESC;

-- Engagement vs activity
SELECT
  e.engagement_level,
  COUNT(*) AS users,
  ROUND(AVG(u.avg_steps), 0) AS avg_steps,
  ROUND(AVG(u.avg_calories), 0) AS avg_calories,
  ROUND(AVG(e.tracked_days), 1) AS avg_tracked_days
FROM engagement_levels e
JOIN user_engagement_summary u
  ON e.id = u.id
GROUP BY e.engagement_level
ORDER BY users DESC;




