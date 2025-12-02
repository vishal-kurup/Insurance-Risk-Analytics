library(tidyverse)
library(here)

insurance <- readRDS(here("data", "insurance_features.rds"))

charge_quants <- quantile(
  insurance$charges,
  probs = c(0.60, 0.85),
  na.rm = TRUE
)

insurance <- insurance %>%
  mutate(
    risk_tier = case_when(
      charges <= charge_quants[1] ~ "Low",
      charges <= charge_quants[2] ~ "Medium",
      TRUE ~ "High"
    ) %>% as.factor()
  )

table(insurance$risk_tier)

prop.table(table(insurance$risk_tier))

model_df <- insurance %>%
  select(
    charges,
    risk_tier,
    age,
    sex,
    bmi,
    children,
    smoker_flag,
    region,
    family_size,
    smoker_bmi_risk,
    smoker_age_risk
  )

set.seed(42)

split_index <- sample(
  seq_len(nrow(model_df)),
  size = 0.80 * nrow(model_df)
)

train <- model_df[split_index, ]
test  <- model_df[-split_index, ]

prop.table(table(train$risk_tier))
prop.table(table(test$risk_tier))

saveRDS(train, here("data", "train_set.rds"))
saveRDS(test,  here("data", "test_set.rds"))
