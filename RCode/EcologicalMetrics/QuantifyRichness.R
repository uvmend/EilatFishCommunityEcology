library(tidyverse)

plotRarefactionCurves <- function(df, title="") {
  ### Function to plot a rarification dataframe with expected names
  p <- df %>% 
    ggplot(aes(x=Individuals, y=Richness, color = Survey))+
    geom_line(size = 1.5) +
    ggtitle(title) +
    theme_minimal() +
    theme(plot.title = element_text(size=18, hjust = 0.5))
  return(p)
}

calcIndividualBasedRarefactionCategory <- function(df, category) {
  ind_based_rare<-list()
  
  for (i in unique(df[[category]])) {
    filtered_df <- df[df[[category]] == i,]
    sp_matrix <- filtered_df[,2:ncol(filtered_df)]
    
    rarefaction <- rarefaction.individual(sp_matrix, method = "sample-size", q = 0)
    rarefaction[[category]] <- i
    ind_based_rare[[i]]<- rarefaction
  }
  
  ind_based_rare<-bind_rows(ind_based_rare)
  
  colnames(ind_based_rare)<-c("Individuals","Richness","Survey")
  return(ind_based_rare)
}

calcSampleBasedRarefactionCategory <- function(df, category, q=0) {
  sample_based_rare <- list()
  
  for (i in unique(df[[category]])) {
    filtered_df <- df[df[[category]] == i,]
    sp_matrix <- filtered_df[,first_species_col:ncol(filtered_df)]
    
    rarefaction_df <- rarefaction.sample(sp_matrix, method = "sample-size", q = 1)
    rarefaction_df[[category]] <- as.character(i)
    sample_based_rare[[i]] <- rarefaction_df
  }
  sample_based_rare<-bind_rows(sample_based_rare)
  
  colnames(sample_based_rare)<- c("Individuals", "Richness","Survey")#c("Samples","Richness","Survey")
  
  return(sample_based_rare)  
}

calcCovrageRarefactinoCategory <- function(df, category, q=0) {
  coverage_based_rare<-list()
  
  for (i in unique(df[[category]])) {
    filtered_df <- df[df[[category]] == i,]
    sp_matrix <- filtered_df[,first_species_col:ncol(filtered_df)]
    
    rarefaction <- rarefaction.sample(sp_matrix, method = "coverage", q = 0)
    
    rarefaction[[category]] <- i
    rarefaction[[category]] <- as.character(i)
    coverage_based_rare[[i]]<- rarefaction
  }
  coverage_based_rare<-bind_rows(coverage_based_rare)
  
  colnames(coverage_based_rare) <- c("Individuals", "Richness","Survey")#c("Samples","Richness","Survey")
  return(coverage_based_rare)
}