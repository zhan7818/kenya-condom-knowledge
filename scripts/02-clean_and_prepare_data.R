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
# There are multiple variables such as age, residence, province, education, etc.
# As such, the raw data will be split into two separate datasets that each focus
# on either age or province, the two main variables.

## Age dataset ##
# Add a new column that denotes the gender
kenya_condom_age <- kenya_condom_clean %>%
  mutate(gender = ifelse(as.numeric(rownames(kenya_condom_clean))<28,"female","male"))
kenya_condom_age <- kenya_condom_age[,c(1,11,2:10)]
# We will filter to only the age rows and rename the var column
kenya_condom_age <- kenya_condom_age[c(2:6,27,29:34,55),] %>%
  rename(age = var)
# Now we change the class of the variables
kenya_condom_age <- kenya_condom_age %>%
  mutate(age = as.factor(age)) %>%
  mutate(gender = as.factor(gender))

## Province dataset ##
# Add a new column that denotes the gender
kenya_condom_province <- kenya_condom_clean %>%
  mutate(gender = ifelse(as.numeric(rownames(kenya_condom_clean))<28,"female","male"))
kenya_condom_province <- kenya_condom_province[,c(1,11,2:10)]
# We will filter to only the province rows and rename the var column
kenya_condom_province <- kenya_condom_province[c(15:21,27,43:49,55),] %>%
  rename(province = var)
# Now we change the class of the variables
kenya_condom_province <- kenya_condom_province %>%
  mutate(province = as.factor(province)) %>%
  mutate(gender = as.factor(gender))

#### Dataset tests ####
# Test the class of each variable cell and also test that the percentages are
# between 0 and 100, and that number of people is greater than 0
# Could maybe also test that the number of people for each gender
# adds up to the total? (don't know how to T_T)

## Age dataset tests ##
agent <-
  create_agent(tbl = kenya_condom_age) %>%
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

## Province dataset tests ##
agent2 <-
  create_agent(tbl = kenya_condom_province) %>%
  col_is_factor(columns = vars(province, gender)) %>%
  col_is_numeric(columns = vars(public_sector,
                                private_medical_sector,
                                private_pharmacy,
                                shop,
                                cbd_agent,
                                friends_and_relatives,
                                other_sources,
                                dont_know_a_source,
                                number_of_people)) %>%
  col_vals_in_set(columns = province,
                  set = c("Nairobi","Central","Coast","Eastern",
                          "Nyanza","Rift Valley","Western","Total")) %>%
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

agent2

#### Save data ####
write_csv(kenya_condom_age, "outputs/data/cleaned_data_age.csv")
write_csv(kenya_condom_province, "outputs/data/cleaned_data_province.csv")
