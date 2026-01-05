# ===============================
# 📘 PHASE 2 – EDA & Visualization
# Flooding & Agricultural Yield Impact
# ===============================

# --- STEP 1: Load Required Libraries ---
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(corrplot)

# --- STEP 2: Load Cleaned Data ---
merged_data <- read_csv("F:/6th Sem/IDS/Cleaned_Flood_Crop_Data.csv")

# --- STEP 2.1: Recreate MissingFlood column ---
merged_data <- merged_data %>%
  mutate(MissingFlood = ifelse(is.na(Total_Events) | Total_Events == 0, "Yes", "No"),
         Flood_Year = ifelse(Total_Events > 0, "Flood", "No Flood"))

# --- STEP 3: Overview of the Data ---
cat("\n--- Dataset Summary ---\n")
summary(merged_data)

cat("\n--- Missing Values ---\n")
print(colSums(is.na(merged_data)))

# --- STEP 4: Statistical Summary of Key Columns ---
numeric_cols <- merged_data %>% 
  select(Value, Yield_Loss_Percent, Avg_Deaths, Avg_Damage_USD, Total_Events)

cat("\n--- Descriptive Statistics ---\n")
print(summary(numeric_cols))

# --- STEP 5: Correlation Analysis ---
cor_matrix <- cor(numeric_cols, use = "complete.obs")
cat("\n--- Correlation Matrix ---\n")
print(cor_matrix)

# Visualize correlation
corrplot(cor_matrix, method = "color", type = "upper", addCoef.col = "black", tl.cex = 0.8)

# --- STEP 6: Visualizations ---

# 6.1 Scatter plot: Flood Damage vs Yield Loss (only flood years)
flood_data_plot <- merged_data %>% filter(Total_Events > 0)

ggplot(flood_data_plot, aes(x = Avg_Damage_USD, y = Yield_Loss_Percent)) +
  geom_point(color = "blue", alpha = 0.7) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(
    title = "Impact of Flood Damage on Crop Yield Loss (%)",
    x = "Average Flood Damage (000 US$)",
    y = "Crop Yield Loss (%)"
  ) +
  theme_minimal()

# 6.2 Scatter plot: Flood Deaths vs Yield Loss
ggplot(flood_data_plot, aes(x = Avg_Deaths, y = Yield_Loss_Percent)) +
  geom_point(color = "darkgreen", alpha = 0.7) +
  geom_smooth(method = "lm", color = "black", se = TRUE) +
  labs(
    title = "Impact of Flood Deaths on Crop Yield Loss (%)",
    x = "Average Deaths",
    y = "Crop Yield Loss (%)"
  ) +
  theme_minimal()

# 6.3 Boxplot: Yield Loss by Flood vs Non-Flood Year
ggplot(merged_data, aes(x = Flood_Year, y = Yield_Loss_Percent, fill = Flood_Year)) +
  geom_boxplot(alpha = 0.7) +
  labs(
    title = "Yield Loss Distribution: Flood vs Non-Flood Years",
    x = "Flood Year",
    y = "Crop Yield Loss (%)"
  ) +
  scale_fill_manual(values = c("No Flood" = "lightblue", "Flood" = "orange")) +
  theme_minimal()

# 6.4 Trend analysis: Yield Loss over Years by Area (flood years only)
ggplot(flood_data_plot, aes(x = Year, y = Yield_Loss_Percent, group = Area, color = Area)) +
  geom_line(alpha = 0.7) +
  geom_point() +
  labs(
    title = "Crop Yield Loss Over Years by Area (Flood Years)",
    x = "Year",
    y = "Yield Loss (%)"
  ) +
  theme_minimal()

# 6.5 Histogram of Yield Loss
ggplot(merged_data, aes(x = Yield_Loss_Percent, fill = Flood_Year)) +
  geom_histogram(binwidth = 5, color = "black", alpha = 0.7, position = "dodge") +
  labs(
    title = "Distribution of Crop Yield Loss (%)",
    x = "Yield Loss (%)",
    y = "Frequency",
    fill = "Flood Year"
  ) +
  theme_minimal()

# --- STEP 7: Aggregate Analysis ---

# Average Yield Loss by Area
avg_loss_area <- merged_data %>%
  group_by(Area) %>%
  summarise(Average_Yield_Loss = mean(Yield_Loss_Percent, na.rm = TRUE),
            Total_Flood_Events = sum(Total_Events))

# Bar plot: Average Yield Loss by Area
ggplot(avg_loss_area, aes(x = reorder(Area, -Average_Yield_Loss), y = Average_Yield_Loss, fill = Total_Flood_Events)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Average Crop Yield Loss by Area",
    x = "Area",
    y = "Average Yield Loss (%)",
    fill = "Total Flood Events"
  ) +
  theme_minimal() +
  coord_flip()

# --- STEP 8: Save Aggregated Results ---
write_csv(avg_loss_area, "F:/6th Sem/IDS/Average_Yield_Loss_by_Area.csv")
cat("\n✅ Aggregated yield loss by area saved at: F:/6th Sem/IDS/Average_Yield_Loss_by_Area.csv\n")
