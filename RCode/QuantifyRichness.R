pacman::p_load(vegan)
pacman::p_load(tidyverse)
pacman::p_load(plotrix)
pacman::p_load(rareNMtests)
pacman::p_load(mobr)

# load data:
orig_df <- readRDS("./EilatFishCommunityEcology/Data/wide_fish_eilat.rds")

# make data table into data frame:
orig_df <- orig_df %>% ungroup()
orig_df <- as.data.frame(orig_df)

first_species_col = 12

df <- orig_df
#plot richness based on year:
yearly_reachness_plot <- df %>% 
  mutate(richness = rowSums(df[first_species_col:length(df)] > 0)) %>% 
  ggplot() +
  aes(x = year, y = richness) +
  stat_summary(geom = "bar", fun.data = mean_se, fill="lightblue") +
  stat_summary(geom = "errorbar", fun.data = mean_se, position = "dodge", width = 0.3) +
  xlab("Year") +
  ylab("Mean Richness") +
  ggtitle("Yearly Mean Richness")

yearly_reachness_plot

#plot richness based on year:
MonthsNames <- c("january", "february", "march", "april", "may", "june", "july",     
                 "august", "september", "october", "november", "december")
month_df <- df %>% arrange(month, MonthsNames)
monthly_reachness_plot <- df %>% 
  mutate(richness = rowSums(df[first_species_col:length(df)] > 0)) %>% 
  ggplot() +
  aes(x = month, y = richness) +
  stat_summary(geom = "bar", fun.data = mean_se, fill="lightblue") +
  stat_summary(geom = "errorbar", fun.data = mean_se, position = "dodge", width = 0.3) +
  xlab("Month") +
  ylab("Mean Richness")+
  ggtitle("Monthly Mean Richness")

monthly_reachness_plot

## TODO: make the months in order
df$month_number <- match(df$month, MonthsNames)
# year month:
df$year_month <- paste(df$year, df$month_number, sep = ".")
monthly_reachness_plot <- df %>% 
  mutate(richness = rowSums(df[first_species_col:length(df)] > 0)) %>% 
  ggplot() +
  aes(x = year_month, y = richness) +
  stat_summary(geom = "bar", fun.data = mean_se, fill="lightblue") +
  stat_summary(geom = "errorbar", fun.data = mean_se, position = "dodge", width = 0.3) +
  xlab("Month") +
  ylab("Mean Richness")+
  ggtitle("Monthly Mean Richness")

monthly_reachness_plot

# create species matrix:
sp_matrix <- orig_df[,first_species_col:length(orig_df)]
?rarefy
raremax <- 1#sp_matrix %>% rowSums() %>% min()

sp_matrix %>% 
  mutate(abundance = rowSums(.)) %>% 
  ggplot() +
  aes(x = abundance) + 
  geom_histogram() +
  scale_x_log10() +
  ggtitle("Species Abundance")

clear_df <-  orig_df %>% 
  mutate(abundance = rowSums(orig_df[first_species_col:length(orig_df)])) %>% 
  filter(abundance > 10) %>% 
  mutate(abundance = NULL)

sp_matrix <- clear_df[first_species_col:length(clear_df)]
raremax <- sp_matrix %>% rowSums() %>% min()

# rareification:
oneSampleRare <- rarefaction.individual(sp_matrix[1,], method="sample-size", q=0)
ggplot(data = oneSampleRare, aes(x = `sample-size`, y = `Hill (q=0)`)) +
  geom_line()+
  xlab("Richness") + 
  ylab("Individual") +
  ggtitle("Rareification curve")
