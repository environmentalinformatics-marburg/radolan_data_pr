# Script3.R
# Author: Hanna Mayer
# Date: 14.01.2018
# Description: This function processes historical RADOLAN files stored in .RData format
#              from a specified directory, converts numerical values to original units,
#              saves results as CSV and melted data as .RData, and returns a summary of actions taken.
# Last change: 2024-07-01 Spaska Forteva

# Function to process RADOLAN data and generate CSV and melted data
combine_RADOLAN_data <- function(RadolanPath, outpath) {
  # Clear workspace and load required libraries
  rm(list=ls())
  library(reshape2)
  
  print(RadolanPath)
  # Define paths and variables
  #RadolanPath <- "D:/radolan/results/"
  #outpath <- "D:/radolan/"
  
  # List all .RData files in RadolanPath
  files <- list.files(RadolanPath, pattern=".RData$")
  setwd(RadolanPath)
  
  # Initialize an empty list to store results
  result <- list()
  
  # Loop through each .RData file, load data, and extract relevant columns
  for (i in 1:length(files)) {
    tmp <- get(load(files[i]))
    result[[i]] <- data.frame(tmp$Date, tmp[, -which(names(tmp) == "Date")])
  }
  
  # Combine results into a single data frame
  results <- data.frame(do.call("rbind", result))
  names(results) <- c("Date", gsub("\\s*\\([^\\)]+\\)", "", names(tmp[, -which(names(tmp) == "Date")])))
  
  # Convert numerical values (except Date) to original units (divide by 10 in this case)
  results[, 2:ncol(results)] <- results[, 2:ncol(results)] / 10
  
  # Write results to CSV file
  write.csv(results, file = paste0(outpath, "Radolan.csv"))
  
  # Read CSV file back into radolan dataframe
  radolan <- read.csv(paste0(outpath, "Radolan.csv"))
  
  # Convert Date column to datetime format
  radolan$Date <- strptime(radolan$Date, format = "%Y-%m-%d %H:%M")
  
  # Round Date column to nearest hour and format
  radolan$Date <- format(round(radolan$Date, units = "hours"), format = "%Y-%m-%d %H:%M")
  
  # Melt data frame to long format
  radolan <- melt(radolan[, 2:ncol(radolan)], id.vars = c("Date"))
  
  # Save melted data to .RData file
  save(radolan, file = paste0(outpath, "/radolan_melt.RData"))
}


