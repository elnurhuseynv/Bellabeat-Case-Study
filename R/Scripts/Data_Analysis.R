# Add day-based features
daily_activity <- daily_activity %>%
  mutate(
    day_of_week = wday(activity_date, label = TRUE),
    is_weekend = if_else(day_of_week %in% c("Sat", "Sun"), "Weekend", "Weekday")
  )

sleep_day <- sleep_day %>%
  mutate(
    sleep_date = as_date(sleep_day),
    day_of_week = wday(sleep_date, label = TRUE),
    is_weekend = if_else(day_of_week %in% c("Sat", "Sun"), "Weekend", "Weekday")
  )

# Create activity level features
daily_activity <- daily_activity %>%
  mutate(
    total_active_minutes = 
      very_active_minutes + 
      fairly_active_minutes +
      lightly_active_minutes,
    
    sedentary_ratio = 
      sedentary_minutes / 
      (sedentary_minutes + total_active_minutes)
  )

# Categorize daily activity
daily_activity <- daily_activity %>%
  mutate(
    activity_level = case_when(
      total_steps < 5000 ~ "Low",
      total_steps < 10000 ~ "Moderate",
      total_steps >= 10000 ~ "High"
    )
  )

# Create sleep duration features
sleep_day <- sleep_day %>%
  mutate(
    sleep_hours = total_minutes_asleep / 60, 
    
    sleep_category = case_when (
      sleep_hours < 6 ~ "Short",
      sleep_hours < 8 ~ "Recommended",
      sleep_hours >=8 ~ "Long"
    )
  )

# User engagement metrics
user_engagement <- daily_activity %>%
  group_by(id) %>%
  summarise(
    active_days = n(),
    avg_steps = mean(total_steps, na.rm = TRUE),
    avg_calories = mean(calories, na.rm = TRUE)
  )

# Export feature-enhanced datasets
write_csv(daily_activity, "~/Downloads/Bellabeat_FitBit_Case_Study/R/Outputs/daily_activity_features.csv")

write_csv(sleep_day, "~/Downloads/Bellabeat_FitBit_Case_Study/R/Outputs/sleep_day_features.csv")

write_csv(user_engagement, "~/Downloads/Bellabeat_FitBit_Case_Study/R/Outputs/user_engagement_summary.csv")