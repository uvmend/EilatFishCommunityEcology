library(dplyr)

df = read.csv("./Data/Full_data.csv")

no_juv_transect = df %>% 
  filter(survey_method == "Transects") %>% 
  filter(Trans_type == 'J')

dim(no_juv_transects)
dim(transect_df)
write.csv(no_juv_transects, "./Data/EilatFishSurveysOnlyTransNoJuv.csv")
