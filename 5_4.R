library(tidyverse)
library(dplyr)
library(embed)

rm(list=ls())

load("./Datasets/okc.RData")

sample_towns <- c(
  "belvedere_tiburon", "berkeley", "martinez", "mountain_view", "san_leandro",
  "san_mateo", "south_san_francisco")

# get raw rates and log-odds for the sample towns

okc_props <- 
  okc_train %>%
  group_by(where_town) %>%
  summarise(
    rate = round(mean(Class == "stem"),3),
    n = length(Class),
    raw  = round(log(rate/(1-rate)),3)
  ) %>%
  mutate(where_town = as.character(where_town)) %>% 
  filter(where_town %in% sample_towns) %>% 
  rename(location = where_town)

okc_props$location <- str_replace_all(okc_props$location, "_", " ")

# fit a generalized linear model and return encoding

partial_rec <- 
  recipe(Class ~ ., data = okc_train) %>%
  step_lencode_bayes(
    where_town,
    outcome = vars(Class),
    verbose = FALSE,
    options = list(
      chains = 5, 
      iter = 1000,
      cores = min(parallel::detectCores(), 5),
      seed = 18324)) %>% prep()
