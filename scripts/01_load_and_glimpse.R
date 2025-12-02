# Initial loading and sanity checks for US Health Insurance dataset

library(tidyverse)
library(skimr)
library(janitor)
library(here)

# Build a robust path to the data file
data_path <- here("data", "insurance.csv")

# Read the CSV
insurance_raw <- read_csv(
  data_path,
  show_col_types = FALSE   # hides the verbose type message
)

# Quick look at the top rows
head(insurance_raw)

# Structure of the dataset
glimpse(insurance_raw)

# Summary stats
summary(insurance_raw)

# Count missing values per column
colSums(is.na(insurance_raw))

insurance <- insurance_raw %>%
  mutate(
    sex    = as.factor(sex),
    smoker = as.factor(smoker),
    region = as.factor(region)
  )

glimpse(insurance)

# Overall data profile
skim(insurance)

# Check distinct values of categoricals
insurance %>% tabyl(sex)
insurance %>% tabyl(smoker)
insurance %>% tabyl(region)

saveRDS(insurance, file = here("data", "insurance_clean.rds"))