# Script3.R
# Author: Hanna Mayer
# Date: 14.01.2018
# Description: This function processes historical RADOLAN files stored in .RData format
#              from a specified directory, converts numerical values to original units,
#              saves results as CSV and melted data as .RData, and returns a summary of actions taken.
# Last change: 2024-07-05 Spaska Forteva

# Function to process RADOLAN data and generate CSV and melted data
combine_RADOLAN_data <- function(outpath, year, month) {
  # Clear workspace and load required libraries
  rm(list=ls())
  library(reshape2)

  RadolanPath <- file.path(outpath, "results")
  
  # List all .RData files in RadolanPath
  files <- list.files(RadolanPath, pattern=paste0(year, month,".RData$"))
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
  write.csv(results, file = file.path(outpath, "Radolan.csv"))
  
  # Read CSV file back into radolan dataframe
  radolan <- read.csv(file.path(outpath, "Radolan.csv"))
  
  # Convert Date column to datetime format
  radolan$Date <- strptime(radolan$Date, format = "%Y-%m-%d %H:%M")
  
  # Round Date column to nearest hour and format
  radolan$Date <- format(round(radolan$Date, units = "hours"), format = "%Y-%m-%d %H:%M")
  
  # Melt data frame to long format
  radolan <- melt(radolan[, 2:ncol(radolan)], id.vars = c("Date"))
  
  # Save melted data to .RData file
  save(radolan, file = file.path(outpath, paste0(year, month,"_radolan_melt.RData")))
}


