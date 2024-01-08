df = read.csv("./Data/Full_data.csv")
transect_df = subset(df, df$survey_method == "Transects")
no_juv_transects = subset(transect_df, 
                          transect_df$Trans_type != "J")
dim(no_juv_transects)
dim(transect_df)
