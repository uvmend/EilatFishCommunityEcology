pacman::p_load(tidyverse)
# pacman::p_load(lubridate)
source("./RCode/DataHandling/Time.R")
source("./RCode/DataHandling/SurveyCorrection.R")

## load the data:
df = read.csv("./Data/EilatFishSurveysOnlyTransNoJuv.csv")

# remove unconfidence observations:
df <- df %>% filter(Confidence < 2)

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
# cols:
# "C" - coral, 
# "R" - Rock, 
# "G" - Gravel, 
# "S" - sand, 
# "SG" - sea grass, 
# "A" - artificial, 
# "B" - bolder
cols_to_remove <- c("X", "X.1", "survey_method", "juv_sub_transect", "observer_num_juv", 
                    "A1_size", "A2_size", "A3_size", "K1_size", "K2_size", 
                    "K3_size", "Habitat", "Photos", "Logger", "a", "b", 
                    "convertion_method", "Sub_site", "Transect", 
                    "observer_num_adults", "Object", "Description", "Notes",
                    "Time_start", "Time_end", "A")

for (col in colnames(df))
{
  if (length(unique(df[[col]])) == 1)
  {
    cols_to_remove <- c(cols_to_remove, col)
  }
}

df <- df[, !names(df) %in% cols_to_remove]
colnames(df)

# rename columns to better understand them:
df <- df %>% rename(c(coral_cover = "C", rock_cover = "R", gravel_cover = "G", 
                      sand_cover = "S", sea_grass_cover = "SG", bolder = "B"))

# make sure all cols are in the right format
# df$year <- as.numeric(df$year)
# df$month <- as.numeric(df$month)
df$lat <- as.numeric(df$lat)
df$lon <- as.numeric(df$lon)
df$Date <- as.Date(df$Date, format = "%Y-%m-%d")
df$Depth <- as.numeric(df$Depth)
df$Amount <- as.numeric(df$Amount)
df$Length <- as.numeric(df$Length)

# Add Seasons column:
df$season <-  sapply(df$Date, calcSeasonName)
df <- df %>% relocate(season, .after=month)

# cryptic correction
df$Amount <- mapply(makeCrypticCorrection, df$Trans_type, df$Amount)

# check for nones:
cols_with_na <- colnames(df)[colSums(is.na(df)) > 0]
print(paste("Cols with NA: ", cols_with_na))


# spraed df:
df_wide <- df %>%
  group_by(across(Site_name:Species)) %>% 
  summarise(Amount = sum(Amount), coral_cover = first(coral_cover), 
            rock_cover = first(rock_cover), gravel_cover = first(gravel_cover), 
            sand_cover = first(sand_cover), sea_grass_cover = first(sea_grass_cover), 
            bolder = first(bolder)) %>%  # coverage
  spread(Species, Amount, fill = 0)



# Save:
saveRDS(df_wide, "./Data/wide_fish_eilat.rds")

rm(df, df_wide, col, cols_to_remove, cols_with_na)
gc()
