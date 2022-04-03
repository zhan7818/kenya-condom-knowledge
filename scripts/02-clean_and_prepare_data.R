#### Preamble ####
# Purpose: Clean and prepare the data
# Author: Tian Yi Zhang
# Date: 2 April 2022
# Contact: psyminette.zhang@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(janitor)
library(pointblank)

#### Get Data ####
# Data is parsed from the Kenya DHS PDF titled 'FR102' which is stored in
# inputs/pdfs using the Rscript 01-gather_data.R
# Read in the data
kenya_condom <- read_csv("outputs/data/raw_data.csv")
kenya_condom_clean <- kenya_condom %>%
  clean_names()

#### Data cleanup and prepare ####
# Add a new column that denotes the gender
kenya_condom_clean <- kenya_condom_clean %>%
  mutate(gender = ifelse(as.numeric(rownames(kenya_condom_clean))<28,"female","male"))
kenya_condom_clean <- kenya_condom_clean[,c(1,11,2:10)]
# We will filter to only the age rows and rename the var column
kenya_condom_clean <- kenya_condom_clean[c(2:6,27,29:34,55),] %>%
  rename(age = var)

# Now we change the class of the variables
kenya_condom_clean <- kenya_condom_clean %>%
  mutate(age = as.factor(age)) %>%
  mutate(gender = as.factor(gender))

#### Dataset tests ####
# Test the class of each variable cell and also test that the percentages are
# between 0 and 100, and that number of people is greater than 0
# Could maybe also test that the number of people for each gender
# adds up to the total? (don't know how to T_T)
agent <-
  create_agent(tbl = kenya_condom_clean) %>%
  col_is_factor(columns = vars(age, gender)) %>%
  col_is_numeric(columns = vars(public_sector,
                                private_medical_sector,
                                private_pharmacy,
                                shop,
                                cbd_agent,
                                friends_and_relatives,
                                other_sources,
                                dont_know_a_source,
                                number_of_people)) %>%
  col_vals_in_set(columns = age,
                  set = c("15-19","20-24","25-29","30-39","40-49","50-54","Total")) %>%
  col_vals_in_set(columns = gender,
                  set = c("male", "female")) %>%
  col_vals_between(columns = vars(public_sector,
                                  private_medical_sector,
                                  private_pharmacy,
                                  shop,
                                  cbd_agent,
                                  friends_and_relatives,
                                  other_sources,
                                  dont_know_a_source),
                   left = 0,
                   right = 100) %>%
  col_vals_gte(columns = number_of_people, value = 0) %>%
  interrogate()

agent
