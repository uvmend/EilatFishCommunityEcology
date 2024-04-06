pacman::p_load(vegan)
pacman::p_load(tidyverse)
pacman::p_load(plotrix)
pacman::p_load(betapart)

m_data <- readRDS('./Data/wide_fish_eilat.rds')

first_col_species <- 12
sp_matrix <- m_data[,first_col_species:ncol(m_data)]

renyi_profile <- renyi(sp_matrix,
                       scales = c(0, 0.05, 0.1, 0.2, 0.4, 0.6, 0.8, 1.0, 2, 4, 8, 16, 32, 64, Inf),
                       hill = T)

renyi_df <- bind_cols(m_data, renyi_profile)
renyi_df<-gather(renyi_df,"Q","Value",first_col_species:ncol(renyi_df))

colnames(renyi_df)
ggplot( data = renyi_df ) +
  aes(x = Q, y = Value, group = trans_ID , color = Site_name)+
  geom_line() +
  geom_point()+
  scale_x_continuous(limits = c(0,64))
