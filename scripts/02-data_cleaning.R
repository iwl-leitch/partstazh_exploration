#### Preamble ####
# Purpose: Cleans.... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Data: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(readr)
library(janitor)
library(here)
library(dplyr)
# [...UPDATE THIS...]
raw_data <- read_csv("inputs/data/raw_data.csv")
#### Clean data ####
# [...UPDATE THIS...]

## this leaves in the unknown years, but not the unknown parties, this is useful because the removing the unknown years can skew the participation metrics, as some parties have huge participation but terrible follow up on time left due to reasons explored in the paper
ambiguous_years_data <-readr::read_csv(here::here("inputs/data/raw_data.csv"), show_col_types = FALSE) |>
  clean_names()|>
  select(id, year_joined_party, political_party, year_left_party)|>
  filter(political_party >= 0)|>
  filter(year_joined_party < 1923)|>
  filter(year_joined_party >= 0)

## because the data uses -9 instead of N/A to represent unknowns, this just changes it to N/A to be more readable
ambiguous_years_data$year_left_party <- replace(cleaned_parties_only_data$year_left_party, cleaned_parties_only_data$year_left_party < 0, NA)




## this takes the raw data and filters out the unknown parties, unknown years, and years after 1923 which marks the end of the Russian Civil War, as we are only concerned with that time period
cleaned_years_and_parties_data <- readr::read_csv(here::here("inputs/data/raw_data.csv"), show_col_types = FALSE) |>
  clean_names()|>
  select(id, year_joined_party, political_party, year_left_party)|>
  filter(political_party >=0) |>
  filter(year_joined_party >= 0)|>
  filter(year_left_party >=0)|>
  filter(year_joined_party < 1923)

## this creates a new column to show the time spent in the listed parties by number of years, so we can call on this to get average times later
cleaned_years_and_parties_data$time_spent_in_party <- cleaned_years_and_parties_data$year_left_party - cleaned_years_and_parties_data$year_joined_party

## this takes the party codes held separate from the main data and cleans them, so removes numbers and symbols from their names
party_codes <- readr::read_csv(here::here("inputs/data/party-cod.csv"), show_col_types = FALSE)|>
  clean_names()

party_codes$id_party <-gsub("[0-9\\\\;]", "", party_codes$id_party)
labels <- party_codes$id_party

## this changes the parties from numbers to their corresponding party designation

combo1 <-match(cleaned_years_and_parties_data$political_party, seq_along(party_codes$id_party))
combo2 <-match(ambiguous_years_data$political_party, seq_along(party_codes$id_party))

cleaned_years_and_parties_data$political_party <-party_codes$id_party[combo1]

ambiguous_years_data$political_party <-party_codes$id_party[combo2]

## this filters out parties with only one member, so we can view them separately from the very small parties
parties_with_more_than_one_recorded_member_cleaned <- cleaned_years_and_parties_data[duplicated(cleaned_years_and_parties_data$political_party)|duplicated(cleaned_years_and_parties_data$political_party, fromLast= TRUE),]


## this takes the data and pares it down to political party, number of recorded members and average time spent in that party, for ease of graphing
graphing_values_cleaned <-aggregate(time_spent_in_party ~ political_party, data = parties_with_more_than_one_recorded_member_cleaned, FUN = function(x) c(mean = mean (x), count = length(x)))


graphing_values_ambiguous <- ambiguous_years_data |>
  group_by(year_joined_party, political_party)|>
  summarise(num_joined = n())


graphing_membership_ambiguous <- ambiguous_years_data |>
  group_by(political_party)|>
  summarize(number_joined = n())

#### Save data ####
# [...UPDATE THIS...]
# change cleaned_data to whatever name you end up with at the end of cleaning
write.csv(cleaned_years_and_parties_data, "inputs/data/cleaned_years_and_parties_data.csv")
write.csv(graphing_values_cleaned, "inputs/data/graphing_values_cleaned.csv")
write.csv(graphing_membership_ambiguous, "inputs/data/graphing_membership_ambiguous.csv")
