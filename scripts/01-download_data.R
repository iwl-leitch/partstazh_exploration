#### Preamble ####
# Purpose: Takes the downloaded data from the Harvard Database and saves it as raw data
# Author: Iz Leitch
# Data: 20 March 2023
# Contact: i.leitch@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download the data for yourself from this link: https://dataverse.harvard.edu/file.xhtml?persistentId=doi:10.7910/DVN/ZZPLC0/4PQLYH&version=4.0
# The site has its own disclaimers and you need to read that BEFORE downloading.


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(readr)
library(here)

#### Download data ####


raw_data <- readr::read_csv(here::here("inputs/data/partstazh-dat.csv"))

#### Save data ####
write_csv(raw_data, "inputs/data/raw_data.csv") 

         