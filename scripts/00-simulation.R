#### Preamble ####
# Purpose: Simulate the desire dataset and test it
# Author: Tian Yi Zhang
# Date: 4 April 2022
# Contact: psyminette.zhang@mail.utoronto.ca
# License: MIT

#### Workspace set-up ####
library(janitor) # helps clean dataset
library(tidyverse)

### Simulate data ###
# While there are three different desired datasets, they are structurally very
# similar. Therefore, this script will only simulate the desired education level
# dataset
set.seed(6607)

numb_edu_levels <- 5 # number of education levels

simulate_education_data <-
  tibble(
    education =
      c(
        "No education",
        "Primary incomplete",
        "Primary complete",
        "Secondary+",
        "Total",
        "No education",
        "Primary incomplete",
        "Primary complete",
        "Secondary+",
        "Total"
      ),
    gender =
      c(
        rep('female', numb_edu_levels),
        rep('male', numb_edu_levels)
      ),
    know_about_condoms = round(runif(n = numb_edu_levels * 2, min = 0, max = 100),2),
    public_sector = round(runif(n = numb_edu_levels * 2, min = 0, max = 100),2),
    private_medical_sector = round(runif(n = numb_edu_levels * 2, min = 0, max = 100),2),
    private_pharmacy = round(runif(n = numb_edu_levels * 2, min = 0, max = 100),2),
    shop = round(runif(n = numb_edu_levels * 2, min = 0, max = 100),2),
    cbd_agent = round(runif(n = numb_edu_levels * 2, min = 0, max = 100),2),
    friends_and_relatives = round(runif(n = numb_edu_levels * 2, min = 0, max = 100),2),
    other_sources = round(runif(n = numb_edu_levels * 2, min = 0, max = 100),2),
    dont_know_a_source = round(runif(n = numb_edu_levels * 2, min = 0, max = 100),2),
    number_of_people = round(runif(n = numb_edu_levels * 2, min = 0, max = 6581),0),
  )

# mutate character variables into factor variables
simulate_education_data <- simulate_education_data |>
  mutate(education = as.factor(education)) |>
  mutate(gender = as.factor(gender))
  
### Tests for simulated data ###
# Passing these tests ensures that the simulation is correct
# test the education variable
simulate_education_data$education |>
  unique() == c("No education",
                "Primary incomplete",
                "Primary complete",
                "Secondary+",
                "Total")

simulate_education_data$education |>
  unique() |>
  length() == 5

simulate_education_data$education |>
  class() == "factor"

# test the gender variable
simulate_education_data$gender |>
  unique() == c("female","male")

simulate_education_data$gender |>
  unique() |>
  length() == 2

simulate_education_data$gender |>
  class() == "factor"

# all subsequent variables aside from number_of_people are percentages from 0
# to 100, so testing only one of them should be enough as the code used to 
# simulate these different variables are identical
simulate_education_data$know_about_condoms |>
  min() >= 0

simulate_education_data$know_about_condoms |>
  max() <= 100

simulate_education_data$know_about_condoms |>
  class() == "numeric"

# test the number_of_people variable
# minimum should be 0
# maximum number of people should be equal to the one provided in the raw data
# in the DHS Program report stored in inputs/pdfs/FR102, which is 6581.
simulate_education_data$number_of_people |>
  min() >= 0

simulate_education_data$number_of_people |>
  max() <= 6581

simulate_education_data$number_of_people |>
  class() == "numeric"
