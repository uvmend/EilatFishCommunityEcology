pacman::p_load(tidyverse)
pacman::p_load(lubridate)

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
df$Date <- as.Date(df$Date, format = "%Y-%m-%d")
df$Depth <- as.numeric(df$Depth)
df$Amount <- as.numeric(df$Amount)
df$Length <- as.numeric(df$Length)

# spraed df:
df_wide <- df %>%
  group_by(across(Site_name:Species)) %>% 
  summarise(Amount = sum(Amount), C = first(C), 
            R = first(R), G = first(G), S = first(S), 
            SG = first(SG), A = first(A), B = first(B)) %>%  # coverage
  spread(Species, Amount, fill = 0)

# Save:
saveRDS(df_wide, "./Data/wide_fish_eilat.rds")

rm(df, df_wide, col, cols_to_remove)
gc()
