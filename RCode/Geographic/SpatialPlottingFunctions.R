## file with functions for plotting on map

pacman::p_load(leaflet)
# pacman::p_load(sf)

createSimplePointsOnMap <- function(df, lng_label, lat_label, radius=5, labels=NULL) {
  if (is.null(labels)) {
    m <- leaflet() %>%
      addTiles() %>%
      addCircleMarkers(lng = df[[lng_label]], lat = df[[lat_label]], 
                       radius = radius, stroke = FALSE, fillOpacity = 0.7)
  } else {
    m <- leaflet() %>%
      addTiles() %>%
      addCircleMarkers(lng = df[[lng_label]], lat = df[[lat_label]], 
                       radius = radius, stroke = FALSE, fillOpacity = 0.7,
                       label = df[[labels]], 
                       labelOptions = labelOptions(noHide = T, opacity = 0.5,,
                                                   direction = "bottom", 
                                                   textOnly = T, 
                                                   style = list(
                                                     "color" = "blue"
                                                   )))
  }
  
}
