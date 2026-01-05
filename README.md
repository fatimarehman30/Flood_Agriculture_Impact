
# Flooding & Agricultural Yield Impact Analysis

**Group 8 – Phase 1 to 3**

This repository contains the complete workflow for analyzing the impact of flooding events on agricultural yield. The project is divided into **three phases**: Data Importing & Cleaning, Exploratory Data Analysis, and Predictive Modeling & Machine Learning.

---

## **Project Overview**

Flooding is a major environmental factor affecting agricultural productivity. This project focuses on:

* Cleaning and merging crop yield and flood event datasets
* Performing univariate EDA to understand trends and distributions
* Developing predictive models to estimate crop yield based on flood events and other factors

The dataset primarily includes crop yields and flood damage across multiple years in Pakistan.

---

## **Dataset**

**Source Files:**

1. `crop data.csv` – contains crop yield data by country, crop, and year
2. `flood events.xlsx` – contains flood events by country and year

**Columns after cleaning (merged dataset):**

| Column             | Description                                   |
| ------------------ | --------------------------------------------- |
| country            | Country name                                  |
| crop               | Crop type                                     |
| year               | Year of record                                |
| yield              | Crop yield                                    |
| total_floods       | Number of flood events                        |
| total_damage_usd   | Total flood damage in USD                     |
| yield_loss_percent | Percentage change in yield from previous year |
| damage_scaled      | Scaled damage value for modeling              |

---

## **Phase 1 – Data Importing, Cleaning & Transformation**

**Key Steps:**

* Imported CSV and Excel datasets using `readr` and `readxl`
* Cleaned column names with `janitor::clean_names`
* Handled missing values:

  * Interpolated missing crop yields using `zoo::na.approx`
  * Median imputation for missing flood damages
* Aggregated flood events and merged datasets
* Calculated crop yield loss percentage
* Scaled flood damage for modeling
* Saved the cleaned dataset: `cleaned_flood_crop_data.csv`

---

## **Phase 2 – Univariate EDA & Visualization**

**Techniques Used:**

* Frequency of records per year
* Year-wise average crop yield, yield loss, and flood damage
* Year-wise average number of flood events
* Boxplots for distribution of crop yield and yield loss by year

**Tools:**

* `ggplot2` for visualizations
* `dplyr` for aggregation

**Outputs:**

* Bar charts for number of records per year
* Line plots for trends in yield, yield loss, and flood damage
* Boxplots showing distribution of yield and yield loss

---

## **Phase 3 – Predictive Modeling & Machine Learning**

**Goal:** Predict crop yield using flood and crop data.

**Steps:**

1. **Data Preparation:**

   * Removed rows with missing yield
   * Converted categorical variables (`crop`) to dummy variables
   * Excluded single-level factors (e.g., `country`)
   * Ensured dummy variable names were valid using `make.names()`

2. **Train/Test Split:**

   * 80% training, 20% testing

3. **Models Implemented:**

   * **Linear Regression** (`lm`)
   * **Random Forest** (`randomForest`)
   * **SVM Regression** (`e1071::svm`)

4. **Evaluation Metrics:**

   * RMSE (Root Mean Squared Error)
   * MAE (Mean Absolute Error)
   * R² (Coefficient of Determination)

5. **Visualizations:**

   * Random Forest Feature Importance plot
   * Actual vs Predicted Yield scatter plot


---

## **R Packages Used**

* `readr`, `readxl`, `dplyr`, `tidyr`, `janitor`, `zoo` – Data importing & cleaning
* `ggplot2` – Visualization
* `caret` – Dummy variables, train/test split
* `randomForest` – Random Forest modeling
* `e1071` – SVM regression
