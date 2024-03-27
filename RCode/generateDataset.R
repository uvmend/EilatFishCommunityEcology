library(dplyr)

df = read.csv("./Data/Full_data.csv")

# filter data by removing:
#   * non transects observations
#   * juvenile transects
#   * experienced observers
filtered_df <- df %>% 
  filter(survey_method == "Transects") %>% 
  filter(Trans_type != "J") %>% 
  filter(!observer %in% c("Yonat Gefen", "Tamar Hamiel"))

# choose randomly observer:
one_observer <- list()
for (id in unique(filtered_df$trans_ID)) {
  trans_df <- filtered_df %>% filter(trans_ID == id)
  if (length(unique(trans_df$observer)) > 1) {
    obs_names <- unique(trans_df$observer)
    choosen_obs <- sample(obs_names, 1)
    one_observer[[id]] <- trans_df %>% filter(observer == choosen_obs)
  } else {
    one_observer[[id]] <- trans_df
  }
}

# test that I really have only one observer per transect
single_observer_df <- bind_rows(one_observer)
for (id in single_observer_df$trans_ID) {
  trans_df <- single_observer_df %>% filter((trans_ID == id))
  if (length(unique(trans_df$observer)) > 1) {
    print(paste("!!!Trans: ", id, " has more than one observer!!!"))
  }
}

write.csv(single_observer_df, "./Data/EilatFishSurveysOnlyTransNoJuv.csv")

# clean environment:
rm(df, one_observer, filtered_df, trans_df, single_observer_df, choosen_obs,
   id, obs_names)



