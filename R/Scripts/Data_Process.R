# Load libraries
library(tidyverse)
library(lubridate)
library(janitor)
library(dplyr)
library(tidyr)
library(ggplot2)

# Set working directory
setwd("~/Downloads/Bellabeat_FitBit_Case_Study/R")

# Import datasets
daily_activity <- read.csv("~/Downloads/Bellabeat_FitBit_Case_Study/R/Raw_Data/dailyActivity_merged.csv")

sleep_day <- read.csv("~/Downloads/Bellabeat_FitBit_Case_Study/R/Raw_Data/sleepDay_merged.csv")

# Quick check
head(daily_activity)

head(sleep_day)

# Clean column names
daily_activity <- daily_activity %>%
  clean_names()

sleep_day <- sleep_day %>%
  clean_names()

# Check result
colnames(daily_activity)

colnames(sleep_day)

# Inspect date columns
str(daily_activity)

str(sleep_day)

# Convert dates
daily_activity <- daily_activity %>%
  mutate(activity_date = mdy(activity_date))

sleep_day <- sleep_day %>%
  mutate(sleep_day = mdy_hms(sleep_day))

# Duplicates
daily_activity %>%
  duplicated() %>%
  sum() # # Result: 0

sleep_day %>%
  duplicated() %>%
  sum() # Result: 3

# Remove duplicates
sleep_day <- sleep_day %>%
  distinct()

# Validate user counts
n_distinct(daily_activity$id) # Result: 33

n_distinct(sleep_day$id) # Result: 24

# Check missing values
daily_activity %>%
  summarise(across(everything(), ~ sum(is.na(.)))) # Result: 0

sleep_day %>%
  summarise(across(everything(), ~ sum(is.na(.)))) # Result: 0

# Export clean datasets
write_csv(daily_activity, "~/Downloads/Bellabeat_FitBit_Case_Study/R/Clean_Data/daily_activity_clean.csv")

write_csv(sleep_day, "~/Downloads/Bellabeat_FitBit_Case_Study/R/Clean_Data/sleep_day_clean.csv")