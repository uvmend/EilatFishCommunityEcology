pacman::p_load(tidyverse)
pacman::p_load(lubridate)
pacman::p_load(leaflet)

## load the data:
df = read.csv("./Data/EilatFishSurveysOnlyTransNoJuv.csv")

# remove unconfidence observations:
df <- df %>% filter(Confidence < 1)

# get only relevant locations:
df$Site_name <- replace(df$Site_name,
                        df$Site_name == "Japanese Gardens" |
                          df$Site_name == "Japanease Gardens",
                        "Japanease_gardens"
                        )
df <- df %>% filter(Site_name == 'IUI' | Site_name == 'Japanease_gardens' | 
                      Site_name == 'Migdalor' | Site_name == 'Caves')

print(paste("# of dates: ", length(unique(df$Date))))
print(paste("# locations: ", length(unique(df$lon))))
print(paste("# Species: ", length(unique(df$Species))))

## remove unnecessary columns:
cols_to_remove <- c("X", "X.1", "survey_method", "juv_sub_transect", "observer_num_juv", 
                    "C", "R", "G", "S", "SG", "A", "B", "A1_size", "A2_size",
                    "A3_size", "K1_size", "K2_size", "K3_size", "Habitat",
                    "Photos", "Logger", "a", "b", "convertion_method", 
                    "Sub_site", "Transect", "Trans_type", "trans_ID", 
                    "observer_num_adults", "Object", "Description", "Notes",
                    "Time_start", "Time_end")

for (col in colnames(df))
{
  if (length(unique(df[[col]])) == 1)
  {
    cols_to_remove <- c(cols_to_remove, col)
  }
}

df <- df[, !names(df) %in% cols_to_remove]
colnames(df)

# make sure all cols are in the right format
# df$year <- as.numeric(df$year)
# df$month <- as.numeric(df$month)
df$lat <- as.numeric(df$lat)
df$lon <- as.numeric(df$lon)
df$Depth <- as.numeric(df$Depth)
df$Amount <- as.numeric(df$Amount)
df$Length <- as.numeric(df$Length)

# spraed df:
df_wide <- df %>%
  group_by(across(Site_name:Species)) %>% 
  summarise(Amount = sum(Amount), Mean_Length = mean(Length)) 

# Save:
saveRDS(df_wide, "./Data/wide_fish_eilat.rds")

# show locations
rec_df <- read.csv("./Data/all stations from EPIC - Yuval.csv")
leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(lng = df$lon, lat = df$lat, radius = 3, color = "black", 
                   label = "Visual Record") %>% 
  addCircleMarkers(lng = rec_df$lon, lat = rec_df$lat, color ="red",
                   radius = 3, fillOpacity = 0.7)

leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(lng = filter(df, Site_name == "IUI")$lon, 
                   lat = filter(df, Site_name == "IUI")$lat, 
                   radius = 3, color = "black", label = "IUI") %>% 
  addCircleMarkers(lng = filter(df, Site_name == "Migdalor")$lon, 
                   lat = filter(df, Site_name == "Migdalor")$lat, 
                   radius = 3, color = "darkgreen", label = "Migdalor") %>% 
 addCircleMarkers(lng = filter(df, Site_name == "Japanese Gardens")$lon, 
                   lat = filter(df, Site_name == "Japanese Gardens")$lat, 
                   radius = 3, color = "purple", label = "Japanese Gardens") %>% 
  addCircleMarkers(lng = filter(df, Site_name == "Caves")$lon, 
                   lat = filter(df, Site_name == "Caves")$lat, 
                   radius = 3, color = "darkorange", label = "Caves") #%>% 
  # addCircleMarkers(lng = rec_df$lon, lat = rec_df$lat, color ="red",
  #                  radius = 3, fillOpacity = 0.7)
