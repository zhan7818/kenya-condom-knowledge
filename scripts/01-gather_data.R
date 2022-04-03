#### Preamble ####
# Purpose: Parse the PDF obtained from the Kenya DHS Program
# Author: Tian Yi Zhang
# Date: 2 April 2022
# Contact: psyminette.zhang@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(haven)
library(janitor)
library(pdftools)
library(purrr)
library(tidyverse)
library(stringi)

#### Parse the PDF ####
# The PDF used in this work is obtained from the Kenya DHS Final Report in 1998
# from the DHS Program. Link to the PDF, titled 'FR102', can be found at
# https://dhsprogram.com/publications/publication-fr102-dhs-final-reports.cfm

# Read in the PDF as a character vector and convert it to a tibble
dhs_1998 <- pdf_text("inputs/pdfs/FR102.pdf")
dhs_1998 <- tibble(raw_data = dhs_1998)

# Filter to only the pages in the PDF that we need (page 170 and 171)
dhs_1998 <-
  dhs_1998 %>%
  slice(170:171)

# Separate the rows
dhs_1998 <-
  dhs_1998 %>%
  separate_rows(raw_data, sep = "\\n", convert = FALSE)

# Separate rows into columns by space
# Note: variable name and the data are separated by irregular numbers of spaces.
# No idea how to insert whitespaces eloquently so have to manually change space
# count in certain rows T_T
# Adjustments in table section for Women
dhs_1998[21,] <- " Currently married          96.2      34.4       6.8      3.1     11.5       3.9      0.0       0.4     39.9       668"
dhs_1998[22,] <- " Formerly married         98.0      23.0       7.0      5.6     19.1       1.7      0.9       0.5     42.2     1,127"
dhs_1998[39,] <- " Primary incomplete         95.5      30.6      5.8       2.4     10.8       2.5      0.5       0.5     46.8     2,262"
dhs_1998[40,] <- " Primary complete         98.1      34.1      8.4       2.6     12.5       4.1      0.3       0.8     37.2     1,588"
# Adjustments in table section for Men
dhs_1998[71,] <- "  Currently married         98.7     27.5       2.7       6.7     33.5      4.2      4.6      0.7     20.1      126"
dhs_1998[72,] <- "  Formerly married        99.7     18.5       6.6       5.9     38.7      5.6      4.4      2.6     17.8    1,052"
dhs_1998[86,] <- "  Primary incomplete        99.5     20.1       4.5       3.1     26.0      7.4      4.6      2.3     32.0      778"
dhs_1998[87,] <- "  Primary complete        99.0     20.6       8.5       3.8     32.3      5.7      2.4      2.1     24.7      783"
# Finally, separate rows into variable name and data
dhs_1998 <-
  dhs_1998 %>%
  separate(col = raw_data,
           into = c("age", "data"),
           sep = " {8,}",
           remove = FALSE,
           fill = "right"
           )

# Separate data based on spaces
# First squish all >1 spaces into just one space
dhs_1998 <-
  dhs_1998 %>%
  mutate(data = str_squish(data)) %>%
  tidyr::separate(col = data,
                  into = c("know_about_condoms",
                           "public_sector",
                           "private_medical_sector",
                           "private_pharmacy",
                           "shop",
                           "cbd_agent",
                           "friends_and_relatives",
                           "other_sources",
                           "dont_know_a_source",
                           "number_of_people"),
                  sep = "\\s",
                  remove = FALSE
                  )

# Now just select only the rows and columns that we need
dhs_1998 <-
  dhs_1998 %>%
  select(age,
         know_about_condoms,
         public_sector,
         private_medical_sector,
         private_pharmacy,
         shop,
         cbd_agent,
         friends_and_relatives,
         other_sources,
         dont_know_a_source,
         number_of_people) %>%
  slice(12:17, 19:22, 24:26, 28:35, 37:41, 43, 62:89) %>%
  rename(var = age)

#### Save data ####
write_csv(dhs_1998, "outputs/data/raw_data.csv")
