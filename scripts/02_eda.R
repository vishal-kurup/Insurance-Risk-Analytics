# Exploratory data analysis for US Health Insurance dataset

library(tidyverse)
library(skimr)
library(here)

insurance <- readRDS(here("data", "insurance_clean.rds"))

# Overall stats
summary(insurance)

# Distributions
insurance %>%
  select(age, bmi, children, charges) %>%
  skim()

p1 <- ggplot(insurance, aes(x = charges)) +
  geom_histogram(bins = 40) +
  labs(
    title = "Distribution of Annual Insurance Charges",
    x = "Charges",
    y = "Customers"
  )

p1

ggsave(here("outputs/figures", "charges_distribution.png"), p1, width = 8, height = 5)

p2 <- ggplot(insurance, aes(smoker, charges)) +
  geom_boxplot() +
  labs(
    title = "Insurance Charges by Smoking Status",
    x = "Smoker",
    y = "Charges"
  )

p2

ggsave(here("outputs/figures", "charges_by_smoker.png"), p2, width = 7, height = 5)

p3 <- ggplot(insurance, aes(bmi, charges, color = smoker)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "BMI vs Charges (Colored by Smoking)",
    x = "BMI",
    y = "Charges"
  )

p3

ggsave(here("outputs/figures", "bmi_vs_charges.png"), p3, width = 7, height = 5)

p4 <- ggplot(insurance, aes(age, charges)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(
    title = "Charges by Age",
    x = "Age",
    y = "Charges"
  )

p4

ggsave(here("outputs/figures", "age_vs_charges.png"), p4, width = 7, height = 5)

p5 <- ggplot(insurance, aes(region, charges)) +
  geom_boxplot() +
  labs(
    title = "Charges by Region",
    x = "Region",
    y = "Charges"
  )

p5

ggsave(here("outputs/figures", "charges_by_region.png"), p5, width = 7, height = 5)

p6 <- ggplot(insurance, aes(as.factor(children), charges)) +
  geom_boxplot() +
  labs(
    title = "Charges by Number of Children",
    x = "Number of Dependents",
    y = "Charges"
  )

p6

ggsave(here("outputs/figures", "charges_by_children.png"), p6, width = 7, height = 5)

insurance <- insurance %>%
  mutate(
    bmi_band = case_when(
      bmi < 18.5 ~ "Underweight",
      bmi < 25 ~ "Normal",
      bmi < 30 ~ "Overweight",
      TRUE ~ "Obese"
    )
  )

p7 <- ggplot(insurance, aes(bmi_band, charges, fill = smoker)) +
  geom_boxplot() +
  labs(
    title = "Charges by BMI Risk Band (Split by Smoking)",
    x = "BMI Category",
    y = "Charges"
  )

p7

ggsave(here("outputs/figures", "charges_by_bmi_band.png"), p7, width = 8, height = 5)


