df = read.csv("./EilatFishCommunityEcology/Data/Full_data.csv")
no_juv_transect = df %>% 
  subset(survey_method == Transects) %>% 
  subset(Trans_type == 'J')

dim(no_juv_transects)
dim(transect_df)
write.csv(no_juv_transects, "./EilatFishCommunityEcology/Data/EilatFishSurveysOnlyTransNoJuv.csv")
