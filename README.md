This repo contains the code and data supporting the paper on the knowledge of
men and women in Kenya regarding condoms. It is organized as follows:

# Scripts

The scripts folder contains the 3 scripts utilized for simulating, parsing and
preparing the datasets:

- The script used to simulate and test the desired dataset
is located in 00-simulation.R. This script includes simulations for the desired
dataset and tests set up to ensure that the simulation is representative of
the desire dataset.

- The script used to parse the PDF into usable datasets is called
01-gather_data.R. The script parses Table 10.14.1 and Table 10.14.2 on page 170
and 171 of the Kenya DHS report PDF respectively into a usable dataset, and
stores it in outputs/data/raw_data.csv.

- The script used to clean and prepare the data is called 
02-clean_and_prepare_data.R. This process involves splitting the raw data
into three datasets, each for a different background characteristic, and then
setting up tests to ensure that the class and content of each row and column in
the datasets are of the desired type. The final datasets are stored in
outputs/data as cleaned_data_age.csv, cleaned_data_education.csv, and
cleaned_data_province.csv.

# Inputs

The inputs folder contains the pdf used to parse the datasets used in this paper
from and contains the literature cited in this paper.

The literature cited in this paper include:

- Volume I of Population by County and Sub-County in the 2019 Kenya Population
and Housing Census, titled "VOLUME 1 KPHC 2019.pdf" and referenced in this 
paper.

The pdf used to parse the dataset from in this paper is the final report
of the Kenya DHS program published in 1998, titled "FR102" and reference in
this paper.

# Outputs

The outputs folder contains two folders: `data` and `paper`.

- The `data` folder contains the raw data (raw_data) parsed from the Kenya DHS 
report published in 1998 which is available at
https://dhsprogram.com/publications/publication-fr102-dhs-final-reports.cfm?csSearch=456440_1.
The folder also contains the three cleaned datasets (cleaned_data_age,
cleaned_data_education, cleaned_data_province) used in this paper.

- The `paper` folder contains the Rmarkdown file used to construct this paper,
the pdf output of the said Rmarkdown file, and the BibTex file for the
references used in this paper. If you wish to view this paper,
open paper.pdf. If you wish to view the analysis process,
open paper.Rmd.