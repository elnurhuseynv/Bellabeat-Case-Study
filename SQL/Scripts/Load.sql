-- Use public schema
SET search_path = public;

CREATE TABLE daily_activity_features (
  id                          BIGINT NOT NULL,
  activity_date               DATE   NOT NULL,      -- R: chr "2016-04-12"

  total_steps                 INTEGER,              -- R: int
  total_distance              NUMERIC(10,3),        -- R: num
  tracker_distance            NUMERIC(10,3),        -- R: num
  logged_activities_distance  NUMERIC(10,3),        -- R: num

  very_active_distance        NUMERIC(10,3),        -- R: num
  moderately_active_distance  NUMERIC(10,3),        -- R: num
  light_active_distance       NUMERIC(10,3),        -- R: num
  sedentary_active_distance   NUMERIC(10,3),        -- R: num

  very_active_minutes         INTEGER,              -- R: int
  fairly_active_minutes       INTEGER,              -- R: int
  lightly_active_minutes      INTEGER,              -- R: int
  sedentary_minutes           INTEGER,              -- R: int

  calories                    INTEGER,              -- R: int
  day_of_week                 TEXT,                 -- R: chr e.g., "Tue"
  is_weekend                  TEXT,                 -- R: chr "Weekday"/"Weekend"

  total_active_minutes        INTEGER,              -- R: int
  sedentary_ratio             NUMERIC(10,4),        -- R: num
  activity_level              TEXT,                 -- R: chr e.g., "High","Moderate"

  PRIMARY KEY (id, activity_date)
);

CREATE TABLE sleep_day_features (
  id                   BIGINT NOT NULL,
  sleep_day            TIMESTAMPTZ NOT NULL,  -- R: chr "2016-04-12T00:00:00Z"

  total_sleep_records  INTEGER,               -- R: int
  total_minutes_asleep INTEGER,               -- R: int
  total_time_in_bed    INTEGER,               -- R: int

  sleep_date           DATE,                  -- R: chr "2016-04-12"
  day_of_week          TEXT,                  -- R: chr
  is_weekend           TEXT,                  -- R: chr "Weekday"/"Weekend"

  sleep_hours          NUMERIC(6,2),          -- R: num e.g., 5.45
  sleep_category       TEXT,                  -- R: chr e.g., "Short","Recommended"

  PRIMARY KEY (id, sleep_day)
);

CREATE TABLE user_engagement_summary (
  id           BIGINT PRIMARY KEY,
  active_days  INTEGER,            -- R: int
  avg_steps    NUMERIC(12,2),      -- R: num
  avg_calories NUMERIC(12,2)       -- R: num
);

CREATE TABLE activity_by_day (
  day_of_week        TEXT PRIMARY KEY,   -- R: chr "Sun","Mon",...
  avg_steps          NUMERIC(12,2),      -- R: num
  avg_active_minutes NUMERIC(12,2)       -- R: num
);

CREATE TABLE sleep_by_day (
  day_of_week      TEXT PRIMARY KEY,   -- R: chr
  avg_sleep_hours  NUMERIC(8,2)        -- R: num
);

CREATE TABLE engagement_levels (
  id               BIGINT PRIMARY KEY,
  tracked_days     INTEGER,     -- R: int
  engagement_level TEXT         -- R: chr e.g., "High"
);

CREATE TABLE engagement_vs_activity (
  id           BIGINT PRIMARY KEY,
  avg_steps    NUMERIC(12,2),   -- R: num
  tracked_days INTEGER          -- R: int
);