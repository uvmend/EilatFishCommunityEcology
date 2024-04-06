pacman::p_load(leaflet)
source('./RCode/Geographic/SpatialPlottingFunctions.R')

orig_df <- readRDS("./Data/wide_fish_eilat.rds")
unique(orig_df$Site_name)
colnames(orig_df)
# plot surveyes locations:

map <- orig_df %>% 
  createSimplePointsOnMap(lng_label = 'lon', lat_label = 'lat', 
                               radius = 2)
map


# plot before the storm:

map <- orig_df %>% 
  filter(Date < as.Date("2020-03-11")) %>% 
  createSimplePointsOnMap(lng_label = 'lon', lat_label = 'lat', 
                          radius = 2)
map

# plot after the storm:
map <- orig_df %>% 
  filter(Date > as.Date("2020-03-11")) %>% 
  createSimplePointsOnMap(lng_label = 'lon', lat_label = 'lat', 
                          radius = 2)
map

rm(orig_df, map)
