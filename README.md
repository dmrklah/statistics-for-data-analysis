# Descriptive and Inferential Statistics for Strategic Business Decision-Making

**Module:** Statistics for Data Analysis  
**Degree:** BSc Computer Science and Digitization

---

## Overview

This project applies descriptive and inferential statistical methods to an air quality dataset. The analysis covers ozone concentration, solar radiation, wind speed, and temperature, with the goal of deriving strategic insights for environmental policy and public health decision-making.

---

## Tasks

| Task | Description |
|------|-------------|
| Task 1 | Data cleaning — mean imputation for missing values, Z-score outlier removal |
| Task 2 | Descriptive statistics — mean, std dev, min/max, histograms, boxplots |
| Task 3 | Data normalization — Min-Max scaling to 0–1 range |
| Task 4 | Inferential statistics — T-test comparing Ozone and Solar Radiation |
| Task 5 | Data visualization — scatter plots, correlation analysis |

---

## Key Findings

- Ozone levels ranged from 1 to 115 ppb with significant variability (std dev: 25.95)
- T-test result: p < 0.05 — statistically significant relationship between Ozone and Solar Radiation
- Solar radiation shows a negative correlation with ozone concentration, suggesting natural degradation processes
- Min-Max normalization enabled consistent cross-variable comparison

---

## Dataset

Uses the built-in **airquality** dataset (R) — New York air quality measurements (May–September 1973).

Variables: `Ozone`, `Solar.R`, `Wind`, `Temp`, `Month`, `Day`

---

## Files

| File | Description |
|------|-------------|
| `statistics_analysis.R` | Full R script — data cleaning, statistics, normalization, T-test, visualizations |
| `report.pdf` | Full assignment report with outputs and strategic recommendations |

---

## How to Run

```r
# In R or RStudio:
source("statistics_analysis.R")
```

Required packages: `ggplot2`, `dplyr`, `tidyr`

```r
install.packages(c("ggplot2", "dplyr", "tidyr"))
```

---

## Technologies

- R · ggplot2 · dplyr · RStudio
