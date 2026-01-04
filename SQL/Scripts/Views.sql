																-- Final Deliverable

SET search_path = public;

-- Daily KPI summary
CREATE OR REPLACE VIEW v_kpi_overall AS
SELECT
  COUNT(*) AS days,
  COUNT(DISTINCT id) AS users,
  ROUND(AVG(total_steps), 0) AS avg_steps,
  ROUND(AVG(total_active_minutes), 1) AS avg_active_minutes,
  ROUND(AVG(calories), 0) AS avg_calories
FROM daily_activity_features;

-- Activity by weekday 
CREATE OR REPLACE VIEW v_activity_by_weekday AS
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

-- Sleep by weekday
CREATE OR REPLACE VIEW v_sleep_by_weekday AS
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

-- Weekday vs weekend comparison (activity + sleep)
CREATE OR REPLACE VIEW v_weekday_vs_weekend AS
SELECT
  'Activity' AS domain,
  is_weekend,
  COUNT(*) AS records,
  ROUND(AVG(total_steps), 0) AS avg_steps,
  ROUND(AVG(total_active_minutes), 1) AS avg_active_minutes,
  NULL::NUMERIC AS avg_sleep_hours
FROM daily_activity_features
GROUP BY is_weekend

UNION ALL

SELECT
  'Sleep' AS domain,
  is_weekend,
  COUNT(*) AS records,
  NULL::NUMERIC AS avg_steps,
  NULL::NUMERIC AS avg_active_minutes,
  ROUND(AVG(total_minutes_asleep) / 60.0, 2) AS avg_sleep_hours
FROM sleep_day_features
GROUP BY is_weekend;

-- Engagement summary (segment size + behavior)
CREATE OR REPLACE VIEW v_engagement_summary AS
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

-- Combined activity+sleep dataset for deeper insights
CREATE OR REPLACE VIEW v_activity_sleep_joined AS
SELECT
  a.id,
  a.activity_date,
  a.day_of_week,
  a.is_weekend,
  a.total_steps,
  a.total_active_minutes,
  a.calories,
  s.total_minutes_asleep,
  ROUND(s.total_minutes_asleep / 60.0, 2) AS sleep_hours
FROM daily_activity_features a
JOIN sleep_day_features s
  ON a.id = s.id
 AND a.activity_date = s.sleep_date;

-- Export Views for Excel
SELECT * FROM v_kpi_overall;
SELECT * FROM v_activity_by_weekday;
SELECT * FROM v_sleep_by_weekday;
SELECT * FROM v_weekday_vs_weekend;
SELECT * FROM v_engagement_summary;

