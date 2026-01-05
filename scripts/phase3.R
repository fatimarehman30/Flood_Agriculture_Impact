library(caret)
library(dplyr)

# Keep only factors with 2+ levels
factor_vars <- sapply(data, is.factor)
multi_level_factors <- names(which(sapply(data[, factor_vars], function(x) nlevels(x) > 1)))

# Create a formula with only multi-level factors
formula <- as.formula(paste("yield ~", paste(c("year", "total_floods", "total_damage_usd", multi_level_factors), collapse = " + ")))

# Create dummy variables
dummies <- dummyVars(formula, data = data)
data_dummy <- predict(dummies, newdata = data) %>% as.data.frame()
colnames(data_dummy) <- make.names(colnames(data_dummy))

# Add target back
data_dummy$yield <- data$yield
# Train/test split (80/20)
set.seed(123)
train_index <- createDataPartition(data_dummy$yield, p = 0.8, list = FALSE)
train_data <- data_dummy[train_index, ]
test_data  <- data_dummy[-train_index, ]

# =============================================================
# 1️⃣ Linear Regression
# =============================================================
lm_model <- lm(yield ~ ., data = train_data)
lm_pred <- predict(lm_model, test_data)

# Evaluation
lm_rmse <- sqrt(mean((test_data$yield - lm_pred)^2))
lm_mae  <- mean(abs(test_data$yield - lm_pred))
lm_r2   <- 1 - sum((test_data$yield - lm_pred)^2) / sum((test_data$yield - mean(test_data$yield))^2)

cat("\n--- Linear Regression ---\n")
cat("RMSE:", lm_rmse, "\nMAE:", lm_mae, "\nR²:", lm_r2, "\n")

# =============================================================
# 2️⃣ Random Forest
# =============================================================
library(randomForest)
set.seed(123)
rf_model <- randomForest(yield ~ ., data = train_data, ntree = 500)
rf_pred <- predict(rf_model, test_data)

rf_rmse <- sqrt(mean((test_data$yield - rf_pred)^2))
rf_mae  <- mean(abs(test_data$yield - rf_pred))
rf_r2   <- 1 - sum((test_data$yield - rf_pred)^2) / sum((test_data$yield - mean(test_data$yield))^2)

cat("\n--- Random Forest ---\n")
cat("RMSE:", rf_rmse, "\nMAE:", rf_mae, "\nR²:", rf_r2, "\n")

# Feature importance plot
importance_df <- data.frame(
  Feature = rownames(rf_model$importance),
  Importance = rf_model$importance[, "%IncMSE"]
)

ggplot(importance_df, aes(x = reorder(Feature, Importance), y = Importance)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(title = "Random Forest Feature Importance", x = "Feature", y = "% Increase in MSE") +
  theme_minimal()

# =============================================================
# 3️⃣ SVM Regression
# =============================================================
library(e1071)
svm_model <- svm(yield ~ ., data = train_data, type = "eps-regression", kernel = "radial")
svm_pred <- predict(svm_model, test_data)

svm_rmse <- sqrt(mean((test_data$yield - svm_pred)^2))
svm_mae  <- mean(abs(test_data$yield - svm_pred))
svm_r2   <- 1 - sum((test_data$yield - svm_pred)^2) / sum((test_data$yield - mean(test_data$yield))^2)

cat("\n--- SVM Regression ---\n")
cat("RMSE:", svm_rmse, "\nMAE:", svm_mae, "\nR²:", svm_r2, "\n")

# =============================================================
# 4️⃣ Actual vs Predicted Plot (Random Forest example)
# =============================================================
pred_df <- data.frame(
  Actual = test_data$yield,
  Predicted = rf_pred
)

ggplot(pred_df, aes(x = Actual, y = Predicted)) +
  geom_point(color = "blue", alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(title = "Random Forest: Actual vs Predicted Yield", x = "Actual Yield", y = "Predicted Yield") +
  theme_minimal()
