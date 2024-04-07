
df <- readRDS("./Data/wide_fish_eilat.rds")

na_df <- df[is.na(df$C), ]
no_nan_df <- df[!(is.na(df$C)),]

euclidian_distance <- function(x1, y1, z1, x2, y2, z2) {
  return(sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2))
}

min_dists <- numeric(nrow(na_df))

for (i in 1:nrow(na_df)) {
  dists <- numeric(nrow(no_nan_df))
  for (j in 1:nrow(no_nan_df)) {
    dists[j] <- euclidian_distance(na_df[i, 'lon'], na_df[i, 'lat'], na_df[i, 'Depth'],
                                   no_nan_df[j, 'lon'], no_nan_df[j, 'lat'], no_nan_df[j, 'Depth'])
  }
  min_dists[i] <- min(unlist(dists))
}

print(min_dists)
print(sort(min_dists))