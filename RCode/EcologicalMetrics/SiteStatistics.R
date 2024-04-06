library(dtplyr)

orig_df <- readRDS("./Data/wide_fish_eilat.rds")
bf_storm_df <- orig_df %>% filter(Date < as.Date('2020-03-11'))
af_storm_df <- orig_df %>% filter(Date > as.Date('2020-03-11'))

colnames(orig_df)
unique(orig_df$Trans_type)
dim(orig_df %>% filter(Trans_type == "T"))
dim(orig_df %>% filter(Trans_type == "C"))

print_per_site_statistics <- function(df) {
  site_names = c()
  min_depth = c() 
  max_depth = c() 
  avg_depth = c()
  num_trans = c()
  min_date = c()
  max_date = c()
  
  for (site in unique(df$Site_name)) {
    site_df <- filter(df, Site_name == site)
    # take statictics on the criptic sites:
    site_df <- site_df %>% filter(Trans_type == "T")
    site_names <- append(site_names, site)
    num_trans <- append(num_trans, nrow(site_df))
    min_depth <- append(min_depth, min(site_df$Depth))
    max_depth <- append(max_depth, max(site_df$Depth))
    avg_depth <- append(avg_depth, mean(site_df$Depth))
    min_date <- append(min_date, min(site_df$Date))
    max_date <- append(max_date, max(site_df$Date))
  }
  print(data.frame(
    site_name = site_names,
    num_transects = num_trans,
    min_depth = min_depth,
    max_depth = max_depth,
    avg_depth = avg_depth,
    min_date = min_date,
    max_date = max_date
  ))
}

print(paste("Genera: "))
print_per_site_statistics(orig_df)

print(paste("Before: "))
print_per_site_statistics(bf_storm_df)

print(paste("After: "))
print_per_site_statistics(af_storm_df)



rm(orig_df, bf_storm_df, af_storm_df)
