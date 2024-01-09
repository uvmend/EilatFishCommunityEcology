
#df = read.csv("./Data/EilatFishSurveysFullData.csv")
#transects_df = subset(df, df$survey_method == "Transects")
#no_juv_trans_df = subset(transects_df, transects_df$Trans_type != "J")
#write.csv(no_juv_trans_df, "./Data/EilatFishSurveysOnlyTransNoJuv.csv")

#colnames(df)
#unique(no_juv_trans_df$Habitat)
#head(no_juv_trans_df)
pacman::p_load(tidyverse)
pacman::p_load(patchwork)
source('./RCode/PlottingFunctions/SpatialPlottingFunctions.R')

df = read.csv("./Data/EilatFishSurveysOnlyTransNoJuv.csv")
df$Date <- as.Date(df$Date, "%Y-%m-%d")


colnames(df)

loc_df <- df %>% drop_na('lon')

# locations:
m <- createSimplePointsOnMap(loc_df, lng_label = 'lon', lat_label = 'lat', radius = 2)
m

# depths:
ggplot(data = loc_df, mapping = aes(x = Depth, fill = Country)) + 
  geom_histogram() +
  ggtitle("Depth Of Transect", )


length(unique(loc_df$Species))
length(unique(loc_df$lat))

ggplot(data = loc_df, mapping = aes(x = Date)) + 
  geom_histogram() + 
  ggtitle("Days of survey") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

unique(df$year)
unique(df$month)
unique(df$Date)
unique(df$Habitat)
unique(df$Time_start)
unique(df$Site_name)

unique(df$Species)
length(unique(df$Time_start))

ggplot(data = df, mapping = aes(x = Date, y = Amount, color = Species)) + 
  geom_point()

df$year
as.yearmon(paste(loc_df$year, loc_df$month), "%Y, %m")

df$month_number = month(df$Date)

df <- df %>% 
            group_by(Date) %>% 
            mutate(unique_types = n_distinct(Species))
ggplot(data = df, mapping = aes(x = Date, y = unique_types)) + 
  geom_point() + 
  # geom_line() +
  ggtitle("Number of species vs date") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

class(df$year)
df$year <- as.character(df$year)
df$month <- month.abb[df$month_number]
ggplot(data = df, mapping = aes(x = month, y = unique_types, color = year)) + 
  geom_boxplot(alpha=0.5) +
  geom_point(alpha=0.5) + 
  scale_x_discrete(limits = month.abb)
  ggtitle("Number of species vs date") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
  
  
for (spec in df$Species){
  spec_df <- filter(df, Species == spec)
  print(
    ggplot(data = spec_df, mapping = aes(x = month, y = Amount, color = year)) + 
      geom_violin() + 
      geom_point(alpha = 0.5) + 
      scale_x_discrete(limits = month.abb) + 
      ggtitle(paste(spec, " distribution accross year")) + 
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
  )
}
  
