pacman::p_load(vegan)
pacman::p_load(tidyverse)
pacman::p_load(plotrix)
pacman::p_load(rareNMtests)
pacman::p_load(mobr)

# load data:
orig_df <- readRDS("./Data/wide_fish_eilat.rds")

# make data table into data frame:
orig_df <- orig_df %>% ungroup()
orig_df <- as.data.frame(orig_df)

first_species_col = 12

df <- orig_df
#plot richness based on year:
df %>% 
  mutate(richness = rowSums(df[first_species_col:length(df)] > 0)) %>% 
  ggplot() +
  aes(x = year, y = richness) +
  stat_summary(geom = "bar", fun.data = mean_se, fill="lightblue") +
  stat_summary(geom = "errorbar", fun.data = mean_se, position = "dodge", width = 0.3) +
  xlab("Year") +
  ylab("Mean Richness") +
  ggtitle("Yearly Mean Richness")

#plot richness based on year:
df %>% 
  mutate(richness = rowSums(df[first_species_col:length(df)] > 0)) %>% 
  ggplot() +
  aes(x = month, y = richness) +
  stat_summary(geom = "bar", fun.data = mean_se, fill="lightblue") +
  stat_summary(geom = "errorbar", fun.data = mean_se, position = "dodge", width = 0.3) +
  xlab("Month") +
  ylab("Mean Richness")+
  ggtitle("Monthly Mean Richness")


df$year_month <- paste(year(df$Date), month(df$Date, label=TRUE), sep = "-")
df %>% 
  mutate(richness = rowSums(df[first_species_col:length(df)] > 0)) %>% 
  ggplot() +
  aes(x = year_month, y = richness, fill=year) +
  stat_summary(geom = "bar", fun.data = mean_se, fill="lightblue") +
  stat_summary(geom = "errorbar", fun.data = mean_se, position = "dodge", width = 0.3) +
  xlab("Date") +
  ylab("Mean Richness")+
  ggtitle("Mean Richness by date")

# create species matrix:
sp_matrix <- orig_df[,first_species_col:length(orig_df)]
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
