# Phase 1: Data Importing, Cleaning & Transformation
# Group 8: Flooding & Agricultural Yield Impact

library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(janitor)
library(zoo)

# -------- Data Importing -------------------------------
crop_data <- read_csv("F:/6th Sem/IDS/crop data.csv")
flood_data <- read_excel("F:/6th Sem/IDS/flood events.xlsx")

# -------- Clean Column Names ---------------------------
crop_data  <- clean_names(crop_data)
flood_data <- clean_names(flood_data)

# -------- Select & Rename Needed Columns ---------------
crop_data <- crop_data %>%
  select(area, item, year, value) %>%
  rename(
    country = area,
    crop = item,
    yield = value
  )

flood_data <- flood_data %>%
  select(country, start_year, total_damage_000_us) %>%
  rename(
    year = start_year,
    damage_usd = total_damage_000_us
  )

# -------- Data Cleaning --------------------------------
crop_data  <- distinct(crop_data)
flood_data <- distinct(flood_data)

crop_data$country  <- toupper(crop_data$country)
flood_data$country <- toupper(flood_data$country)

# Interpolate missing crop yield values
crop_data <- crop_data %>%
  group_by(country, crop) %>%
  arrange(year) %>%
  mutate(yield = na.approx(yield, na.rm = FALSE)) %>%
  ungroup()

# Median imputation for flood damage
flood_data <- flood_data %>%
  mutate(
    damage_usd = ifelse(
      is.na(damage_usd),
      median(damage_usd, na.rm = TRUE),
      damage_usd
    )
  )

# -------- Data Transformation --------------------------

# Aggregate floods yearly
flood_yearly <- flood_data %>%
  group_by(country, year) %>%
  summarise(
    total_floods = n(),
    total_damage_usd = sum(damage_usd),
    .groups = "drop"
  )

# Merge datasets
merged_data <- crop_data %>%
  left_join(flood_yearly, by = c("country", "year"))

# Replace NA flood values
merged_data <- merged_data %>%
  mutate(
    total_floods = replace_na(total_floods, 0),
    total_damage_usd = replace_na(total_damage_usd, 0)
  )

# Crop yield loss %
merged_data <- merged_data %>%
  group_by(country, crop) %>%
  arrange(year) %>%
  mutate(
    yield_loss_percent =
      ifelse(lag(yield) > 0,
             ((lag(yield) - yield) / lag(yield)) * 100,
             0)
  ) %>%
  ungroup()

# Scale damage (FIXED)
merged_data <- merged_data %>%
  mutate(damage_scaled = as.numeric(scale(total_damage_usd)))

# -------- Save Cleaned Dataset -------------------------
write_csv(
  merged_data,
  "F:/6th Sem/IDS/cleaned_flood_crop_data.csv"
)
