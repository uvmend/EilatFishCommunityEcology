pacman::p_load(leaflet)

# show locations
rec_df <- read.csv("./Data/all stations from EPIC - Yuval.csv")
df <- readRDS("./Data/wide_fish_eilat.rds")

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
  addCircleMarkers(lng = filter(df, Site_name == "Japanease_gardens")$lon, 
                   lat = filter(df, Site_name == "Japanease_gardens")$lat, 
                   radius = 3, color = "purple", label = "Japanese Gardens") %>% 
  addCircleMarkers(lng = filter(df, Site_name == "Caves")$lon, 
                   lat = filter(df, Site_name == "Caves")$lat, 
                   radius = 3, color = "darkorange", label = "Caves")

## Before the the storm:
bf_storm_df <- filter(df, df$Date < as.Date("2020-03-12"))

leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(lng = bf_storm_df$lon, lat = bf_storm_df$lat, radius = 3, color = "black", 
                   label = "Visual Record") %>% 
  addCircleMarkers(lng = rec_df$lon, lat = rec_df$lat, color ="red",
                   radius = 3, fillOpacity = 0.7)

leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(lng = filter(bf_storm_df, Site_name == "IUI")$lon, 
                   lat = filter(bf_storm_df, Site_name == "IUI")$lat, 
                   radius = 3, color = "black", label = "IUI") %>% 
  addCircleMarkers(lng = filter(bf_storm_df, Site_name == "Migdalor")$lon, 
                   lat = filter(bf_storm_df, Site_name == "Migdalor")$lat, 
                   radius = 3, color = "darkgreen", label = "Migdalor") %>% 
  addCircleMarkers(lng = filter(bf_storm_df, Site_name == "Japanease_gardens")$lon, 
                   lat = filter(bf_storm_df, Site_name == "Japanease_gardens")$lat, 
                   radius = 3, color = "purple", label = "Japanese Gardens") %>% 
  addCircleMarkers(lng = filter(bf_storm_df, Site_name == "Caves")$lon, 
                   lat = filter(bf_storm_df, Site_name == "Caves")$lat, 
                   radius = 3, color = "darkorange", label = "Caves")

## After the storm:
af_storm_df <- filter(df, df$Date > as.Date("2020-03-13"))

leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(lng = af_storm_df$lon, lat = af_storm_df$lat, radius = 3, color = "black", 
                   label = "Visual Record") %>% 
  addCircleMarkers(lng = rec_df$lon, lat = rec_df$lat, color ="red",
                   radius = 3, fillOpacity = 0.7)


leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(lng = filter(af_storm_df, Site_name == "IUI")$lon, 
                   lat = filter(af_storm_df, Site_name == "IUI")$lat, 
                   radius = 3, color = "black", label = "IUI") %>% 
  addCircleMarkers(lng = filter(af_storm_df, Site_name == "Migdalor")$lon, 
                   lat = filter(af_storm_df, Site_name == "Migdalor")$lat, 
                   radius = 3, color = "darkgreen", label = "Migdalor") %>% 
  addCircleMarkers(lng = filter(af_storm_df, Site_name == "Japanease_gardens")$lon, 
                   lat = filter(af_storm_df, Site_name == "Japanease_gardens")$lat, 
                   radius = 3, color = "purple", label = "Japanese Gardens") %>% 
  addCircleMarkers(lng = filter(af_storm_df, Site_name == "Caves")$lon, 
                   lat = filter(af_storm_df, Site_name == "Caves")$lat, 
                   radius = 3, color = "darkorange", label = "Caves") #%>% 


# compare before and after 
leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(lng = af_storm_df$lon, lat = af_storm_df$lat, radius = 3, color = "red") %>% 
  addCircleMarkers(lng = bf_storm_df$lon, lat = bf_storm_df$lat, color ="blue",
                   radius = 3, fillOpacity = 0.7)
