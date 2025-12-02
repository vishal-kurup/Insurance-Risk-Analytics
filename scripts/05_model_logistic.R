library(tidyverse)
library(here)
library(tidymodels)
library(yardstick)

train <- readRDS(here("data", "train_set.rds"))
test  <- readRDS(here("data", "test_set.rds"))

risk_recipe <- recipe(
  risk_tier ~ age + sex + bmi + children + smoker_flag +
    region + family_size + smoker_bmi_risk + smoker_age_risk,
  data = train
) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_normalize(all_numeric_predictors())

risk_model <- logistic_reg() %>%
  set_engine("glm") %>%
  set_mode("classification")

risk_workflow <- workflow() %>%
  add_recipe(risk_recipe) %>%
  add_model(risk_model)

log_fit <- fit(risk_workflow, data = train)

test_preds <- predict(log_fit, test, type = "prob") %>%
  bind_cols(predict(log_fit, test)) %>%
  bind_cols(test %>% select(risk_tier))

metrics(test_preds, truth = risk_tier, estimate = .pred_class)

conf_mat(test_preds, truth = risk_tier, estimate = .pred_class)

# Convert to binary classification problem: High vs NotHigh
test_preds <- test_preds %>%
  mutate(high_risk_flag = if_else(
    risk_tier == "High", "High", "NotHigh"
  ) %>% as.factor())

# Compute ROC curve data
roc_obj <- roc_curve(
  test_preds,
  truth = high_risk_flag,
  .pred_High
)

# Plot ROC curve and force display
roc_plot <- autoplot(roc_obj)
print(roc_plot)

# Calculate AUC
roc_auc(
  test_preds,
  truth = high_risk_flag,
  .pred_High
)

ggsave(
  filename = here("outputs/figures", "roc_logistic_highrisk.png"),
  plot = roc_plot,
  width = 7,
  height = 5
)