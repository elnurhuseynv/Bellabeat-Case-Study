# Overall daily activity trends
daily_activity %>%
  summarise(
    avg_steps = mean(total_steps),
    median_steps = median(total_steps),
    avg_active_minutes = mean(total_active_minutes)
  )

# Activity by day of week
steps_by_day <- daily_activity %>%
  group_by(day_of_week) %>%
  summarise(
    avg_steps = mean(total_steps),
    avg_active_minutes = mean(total_active_minutes)
  )

# Visualization: Steps by day
ggplot(steps_by_day, aes(x = day_of_week, y = avg_steps)) + 
  geom_col(fill = "#69b3a2") + 
  labs(
    title = "Average Daily Steps by Day of Week",
    x = "Day of Week", 
    y = "Average Steps"
  ) +
  theme_minimal()

# Weekday and Weekend comparison
daily_activity %>%
  group_by(is_weekend) %>%
  summarise(
    avg_steps = mean(total_steps),
    avg_active_minutes = mean(total_active_minutes)
  )

# Activity level distribution
daily_activity %>%
  count(activity_level)

# Visualization: Activity Levels
ggplot(daily_activity, aes(x = activity_level)) +
  geom_bar(fill = "#404080") + 
  labs(
    title = "Distribution of Daily Activity Levels",
    x = "Activity Level", 
    y = "Number of Days"
  ) +
  theme_minimal()

# Export activity summary
write_csv(steps_by_day, "~/Downloads/Bellabeat_FitBit_Case_Study/R/Outputs/Tables/activity_by_day.csv")