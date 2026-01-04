# Overall sleep duration summary
sleep_day %>%
  summarise(
    avg_sleep_hours = mean(sleep_hours),
    median_sleep_hours = median(sleep_hours)
  )

# Sleep duration by day of week
sleep_by_day <- sleep_day %>%
  group_by(day_of_week) %>%
  summarise(
    avg_sleep_hours = mean(sleep_hours)
  )

# Visualization: Sleep by Day
ggplot(sleep_by_day, aes(x = day_of_week, y = avg_sleep_hours)) +
  geom_col(fill = "#8da0cb") + 
  labs(
    title = "Average Sleep Duration by Day of Week",
    x = "Day of Week",
    y = "Average Sleep (Hours)"
  ) +
  theme_minimal()

# Weekday and Weekend sleep comparison
sleep_day %>%
  group_by(is_weekend) %>%
  summarise(
    avg_sleep_hours = mean(sleep_hours)
  )

# Sleep category distribution
sleep_day %>%
  count(sleep_category)

# Visualization: Sleep Categories
ggplot(sleep_day, aes(x = sleep_category)) +
  geom_bar(fill = "#66c2a5") +
  labs(
    title = "Distribution of Sleep Duration Categories", 
    x = "Sleep Category",
    y = "Number of Days"
  ) +
  theme_minimal()

# Export sleep summary
write_csv(sleep_by_day, "~/Downloads/Bellabeat_FitBit_Case_Study/R/Outputs/Summaries/sleep_by_day.csv")