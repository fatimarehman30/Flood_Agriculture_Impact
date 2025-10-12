# 🌾 Flooding & Agricultural Yield Impact  
### **Group 8 – Phase 1: Data Science Project**

---

## 📘 1. Dataset Sources

### **1. FAO Crop Data (CSV)**
- **Source:** Food and Agriculture Organization (FAO)  
- **Description:** Contains annual agricultural yield data for multiple crops across different regions from 2000–2025.  
- **Purpose:** Used to measure yearly variations in crop yield for each region (Area).

### **2. EM-DAT Flood Events Data (Excel)**
- **Source:** Emergency Events Database (EM-DAT)  
- **Description:** Includes flood event information such as event name, country, year, magnitude, total deaths, and total damage (in thousand USD).  
- **Purpose:** Used to assess the frequency and intensity of flood disasters and their economic impact.

---

## 🧹 2. Data Cleaning Decisions

| Step | Description | Purpose |
|------|--------------|----------|
| **1. Standardized Names** | Converted `Area` and `Country` fields to title case and trimmed spaces. | Ensures consistent naming for merging datasets. |
| **2. Removed Duplicates** | Eliminated duplicate flood events (same name and year). | Avoids repetition of disaster data. |
| **3. Handled Missing Values** | Interpolated missing crop yield values using linear approximation (`na.approx`). | Maintains yearly continuity in yield trends. |
| **4. Aligned Columns** | Matched `Area` (from FAO) with `Country` (from EM-DAT) and aligned the year columns. | Enables correct dataset merging. |
| **5. Verified Data Consistency** | Checked for nulls and verified numeric data types. | Ensures clean and usable data for transformation. |

---

## 🔄 3. Data Transformations

| Transformation | Description | Output |
|----------------|--------------|---------|
| **Crop Yield Loss (%)** | Calculated the year-over-year percentage change in yield. | New variable: `Yield_Loss_Percent` |
| **Flood Data Aggregation** | Grouped flood data by `Country` and `Year` to calculate total deaths, average damage, and event count. | Variables: `Avg_Deaths`, `Avg_Damage_USD`, `Total_Events` |
| **Merging Datasets** | Combined FAO crop data with EM-DAT flood summaries by region and year. | Integrated dataset linking floods and yields. |

---

## 📊 4. Output Summary

- **Final Dataset:** `Cleaned_Flood_Crop_Data.csv`  
- **Records:** 1,741 rows × 15 columns  
- **Key Variables:**  
  `Area`, `Item`, `Year`, `Value`, `Yield_Loss_Percent`, `Avg_Deaths`, `Avg_Damage_USD`

**Example Visualization:**  
*Flood Damage vs Crop Yield Loss (%)* — used to verify correct merging and data relationships.  

Interpretation:  
Most data points cluster near zero yield loss, indicating that flood damage alone does not have a strong linear correlation with crop yield changes.

---

## 🧠 5. Summary

- Both datasets were successfully imported, cleaned, and merged using R.  
- Missing yield values were interpolated, and flood data was aggregated for consistency.  
- A new variable (*Yield_Loss_Percent*) was created to capture yearly yield changes.  
- The resulting dataset is ready for **Phase 2 (Exploratory Data Analysis)** and visualization.

---

## 🧑‍💻 6. Technical Details

**Tools Used:**  
- RStudio (R version 4.x)  
- Libraries: `readr`, `readxl`, `dplyr`, `tidyr`, `stringr`, `zoo`, `ggplot2`

**Script File:**  
`scripts/Phase1_Group8.R`

**Output Files:**  
- `data/cleaned_Flood_Crop_Data.csv`  
- `outputs/Flood_Damage_vs_YieldLoss.png`
