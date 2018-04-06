rm(list = ls())

library(tidyverse)
library(leaflet)

data_df <- read_csv("parcial.csv")

data_df <- data_df %>% 
  select(-NR_SECAO) %>% 
  distinct()

summary(data_df$dispersion)

amostra <- data_df %>% 
  sample_n(size = nrow(data_df) * 0.05)

leaflet(data_df) %>%
  addTiles() %>%
  addMarkers(~longitude, ~latitude,
             popup = ~as.character(str_c(DS_BAIRRO, street_name, dispersion,providers_count, sep = " "),
             label = ~as.character(str_c(DS_BAIRRO, street_name, dispersion,providers_count, sep = " ")),
             color = ~as.factor(provider)))

data_df %>% 
  ggplot(mapping = aes(x = long, y = lat))