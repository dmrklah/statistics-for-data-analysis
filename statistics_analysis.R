# ============================================================
# Descriptive and Inferential Statistics for Strategic
# Business Decision-Making — Air Quality Dataset
# Module: Statistics for Data Analysis
# Degree: BSc Computer Science and Digitization
# ============================================================

# Install required packages if not already installed
# install.packages(c("ggplot2", "dplyr", "tidyr"))

library(ggplot2)
library(dplyr)
library(tidyr)

# ── Load Dataset ─────────────────────────────────────────────
# Using the built-in airquality dataset (New York air quality measurements)
data("airquality")
df <- airquality
cat("Dataset loaded:", nrow(df), "rows,", ncol(df), "columns\n")

# ── Task 1: Data Cleaning ────────────────────────────────────

# Check missing values
cat("\nMissing values per column:\n")
print(colSums(is.na(df)))

# Mean imputation for missing values
df$Ozone[is.na(df$Ozone)]   <- mean(df$Ozone,   na.rm = TRUE)
df$Solar.R[is.na(df$Solar.R)] <- mean(df$Solar.R, na.rm = TRUE)

cat("\nAfter imputation — missing values:\n")
print(colSums(is.na(df)))

# Outlier detection and removal using Z-score method
remove_outliers_zscore <- function(df, cols, threshold = 3) {
  for (col in cols) {
    z_scores <- abs(scale(df[[col]]))
    df <- df[z_scores <= threshold, ]
  }
  return(df)
}

df_clean <- remove_outliers_zscore(df, c("Ozone", "Solar.R", "Wind", "Temp"))
cat("\nRows after outlier removal:", nrow(df_clean), "\n")

# ── Task 2: Descriptive Statistics ───────────────────────────

cat("\nDescriptive Statistics:\n")
print(summary(df_clean))

# Custom summary table
desc_stats <- df_clean %>%
  select(Ozone, Solar.R, Wind, Temp, Month, Day) %>%
  summarise(across(everything(), list(
    Count  = ~n(),
    Mean   = ~round(mean(., na.rm = TRUE), 2),
    StdDev = ~round(sd(., na.rm = TRUE), 2),
    Min    = ~min(., na.rm = TRUE),
    Max    = ~max(., na.rm = TRUE)
  )))

cat("\nCustom Summary Table:\n")
print(t(desc_stats))

# Histograms
df_long <- df_clean %>%
  select(Ozone, Solar.R, Wind, Temp) %>%
  pivot_longer(everything(), names_to = "Variable", values_to = "Value")

p1 <- ggplot(df_long, aes(x = Value, fill = Variable)) +
  geom_histogram(bins = 20, color = "white", alpha = 0.8) +
  facet_wrap(~Variable, scales = "free") +
  labs(title = "Figure 1: Histograms of Numerical Variables",
       x = "Value", y = "Frequency") +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("histograms.png", plot = p1, width = 10, height = 6, dpi = 150)

# Boxplots
p2 <- ggplot(df_long, aes(x = Variable, y = Value, fill = Variable)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Figure 2: Boxplots of Numerical Variables",
       x = "Variable", y = "Value") +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("boxplots.png", plot = p2, width = 10, height = 6, dpi = 150)

# ── Task 3: Data Normalization (Min-Max Scaling) ──────────────

min_max_scale <- function(x) {
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

df_normalized <- df_clean %>%
  mutate(across(c(Ozone, Solar.R, Wind, Temp, Month, Day), min_max_scale))

cat("\nNormalized data (first 5 rows):\n")
print(head(df_normalized, 5))

# ── Task 4: Inferential Statistics (T-Test) ───────────────────

cat("\nT-Test: Ozone vs Solar Radiation\n")
t_result <- t.test(df_clean$Ozone, df_clean$Solar.R)
print(t_result)

if (t_result$p.value < 0.05) {
  cat("Result: p <", round(t_result$p.value, 4),
      "— Reject null hypothesis. Significant difference between Ozone and Solar Radiation.\n")
} else {
  cat("Result: p =", round(t_result$p.value, 4),
      "— Fail to reject null hypothesis.\n")
}

# Correlation
cor_val <- cor(df_clean$Ozone, df_clean$Solar.R, use = "complete.obs")
cat("\nPearson Correlation (Ozone vs Solar.R):", round(cor_val, 4), "\n")

# ── Task 5: Data Visualization ────────────────────────────────

# Scatter plot: Ozone vs Solar Radiation
p3 <- ggplot(df_clean, aes(x = Solar.R, y = Ozone)) +
  geom_point(alpha = 0.6, color = "#2E86AB") +
  geom_smooth(method = "lm", color = "#E84855", se = TRUE) +
  labs(title = "Figure 3: Scatter Plot — Ozone vs Solar Radiation",
       x = "Solar Radiation (Langleys)",
       y = "Ozone Concentration (ppb)") +
  theme_minimal()

ggsave("scatter_ozone_solar.png", plot = p3, width = 8, height = 5, dpi = 150)

# Ozone vs Temperature
p4 <- ggplot(df_clean, aes(x = Temp, y = Ozone)) +
  geom_point(alpha = 0.6, color = "#F4A261") +
  geom_smooth(method = "lm", color = "#264653", se = TRUE) +
  labs(title = "Figure 4: Scatter Plot — Ozone vs Temperature",
       x = "Temperature (°F)",
       y = "Ozone Concentration (ppb)") +
  theme_minimal()

ggsave("scatter_ozone_temp.png", plot = p4, width = 8, height = 5, dpi = 150)

cat("\nAll plots saved. Analysis complete.\n")
