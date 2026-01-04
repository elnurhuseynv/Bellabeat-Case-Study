# Days tracked per user
engagement_days <- daily_activity %>%
  group_by(id) %>%
  summarise(
    tracked_days = n()
  )

# Engagement levels
engagement_days <- engagement_days %>%
  mutate(
    engagement_level = case_when(
      tracked_days < 15 ~ "Low",
      tracked_days < 25 ~ "Moderate",
      tracked_days >= 25 ~ "High"
    )
  )

engagement_days %>%
  count(engagement_level)

# Engagement vs Activity
engagement_activity <- daily_activity %>%
  group_by(id) %>%
  summarise(
    avg_steps = mean(total_steps),
    tracked_days = n()
  )

# Visualization: Engagement vs Steps
ggplot(engagement_activity, aes(x = tracked_days, y = avg_steps)) +
  geom_point(color = "#fc8d62") +
  labs(
    title = "User Engagement vs Average Daily Steps",
    x = "Tracked Days",
    y = "Average Daily Steps"
  ) +
  theme_minimal()

# Export Engagement
write_csv(engagement_days, "~/Downloads/Bellabeat_FitBit_Case_Study/R/Outputs/Summaries/engagement_levels.csv")

write_csv(engagement_activity, "~/Downloads/Bellabeat_FitBit_Case_Study/R/Outputs/Summaries/engagement_vs_activity.csv")