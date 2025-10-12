# ===============================
# 📘 PHASE 1 – Data Science Project
# Group 8:Flooding & Agricultural Yield Impact
# ===============================

# --- STEP 1: Load Required Libraries ---
library(readr)
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(zoo)
library(ggplot2)

# --- STEP 2: Data Importing ---
crop_data <- read_csv("F:/6th Sem/IDS/crop data.csv")
flood_data <- read_excel("F:/6th Sem/IDS/flood events.xlsx")

# --- STEP 3: Structure Check ---
cat("\n--- Crop Data Columns ---\n")
print(colnames(crop_data))

cat("\n--- Flood Data Columns ---\n")
print(colnames(flood_data))

# --- STEP 4: Data Cleaning ---

# 4.1 Standardize region (Area) and flood event names
crop_data <- crop_data %>%
  mutate(Area = str_to_title(trimws(Area)))

flood_data <- flood_data %>%
  mutate(Country = str_to_title(trimws(Country)),
         `Event Name` = str_to_title(trimws(`Event Name`)))

# 4.2 Remove duplicate flood events (Event Name + Start Year)
flood_data <- flood_data %>%
  distinct(`Event Name`, `Start Year`, .keep_all = TRUE)

# 4.3 Handle missing yield values with linear interpolation
crop_data <- crop_data %>%
  group_by(Area, Item) %>%
  arrange(Year) %>%
  mutate(Value = na.approx(Value, na.rm = FALSE))

# 4.4 Missing values summary
cat("\n--- Missing Values in Crop Data ---\n")
print(colSums(is.na(crop_data)))

cat("\n--- Missing Values in Flood Data ---\n")
print(colSums(is.na(flood_data)))

# --- STEP 5: Data Transformation ---

# 5.1 Create crop yield loss percentage
crop_data <- crop_data %>%
  group_by(Area, Item) %>%
  arrange(Year) %>%
  mutate(Yield_Loss_Percent = (Value - lag(Value)) / lag(Value) * -100)

# 5.2 Aggregate flood data by Country and Year
flood_summary <- flood_data %>%
  group_by(Country, `Start Year`) %>%
  summarise(
    Avg_Deaths = mean(`Total Deaths`, na.rm = TRUE),
    Avg_Damage_USD = mean(`Total Damage ('000 US$)`, na.rm = TRUE),
    Total_Events = n()
  ) %>%
  rename(Year = `Start Year`)

# 5.3 Merge flood and crop datasets
merged_data <- merge(
  crop_data,
  flood_summary,
  by.x = c("Area", "Year"),
  by.y = c("Country", "Year"),
  all.x = TRUE
)

# --- STEP 6: Visualization ---
ggplot(merged_data, aes(x = Avg_Damage_USD, y = Yield_Loss_Percent)) +
  geom_point(color = "blue") +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(
    title = "Flood Damage vs Crop Yield Loss (%)",
    x = "Average Flood Damage (000 US$)",
    y = "Crop Yield Loss (%)"
  )

# --- STEP 7: Save Cleaned & Transformed Data ---
write_csv(merged_data, "F:/6th Sem/IDS/Cleaned_Flood_Crop_Data.csv")

cat("\n✅ Cleaned and merged dataset saved at: F:/6th Sem/IDS/Cleaned_Flood_Crop_Data.csv\n")

