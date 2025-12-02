library(tidyverse)
library(here)

insurance <- readRDS(here("data", "insurance_clean.rds"))

insurance_fe <- insurance %>%
  mutate(
    
    # Age bucket
    age_group = case_when(
      age < 30 ~ "Young",
      age < 45 ~ "Mid",
      age < 60 ~ "Senior",
      TRUE ~ "Elder"
    ),
    
    # BMI risk grouping
    bmi_group = case_when(
      bmi < 18.5 ~ "Underweight",
      bmi < 25 ~ "Normal",
      bmi < 30 ~ "Overweight",
      TRUE ~ "Obese"
    ),
    
    # Binary smoker flag
    smoker_flag = if_else(smoker == "yes", 1, 0),
    
    # Combined lifestyle risk interaction
    smoker_bmi_risk = smoker_flag * bmi,
    
    # Age and smoker interaction
    smoker_age_risk = smoker_flag * age,
    
    # Family dependency impact
    family_size = children + 1
  )

glimpse(insurance_fe)

summary(insurance_fe$smoker_bmi_risk)
summary(insurance_fe$smoker_age_risk)

saveRDS(insurance_fe, here("data", "insurance_features.rds"))
