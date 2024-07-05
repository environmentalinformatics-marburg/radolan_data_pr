# Author: Spaska Forteva
# Description: This function formats RADOLAN precipitation data for a database.
# Main script to load RADOLAN data, process it, and write formatted data to CSV files for each plotID.
# Last change: 2024-07-05 Spaska Forteva

library(sp)
library(rgdal)
library(dplyr)
library(readr)
library(purrr)
library(stringr)

args <- commandArgs(trailingOnly = TRUE)

# Define parameters based on arguments
ftp_root <- args[1]
year <- as.integer(args[2])
monthEnd <- as.integer(args[3])
main_directory <- args[4]
monthStart <- as.integer(args[5])

if (monthStart == "" || monthStart == 0) {
  monthStart = 1
}
if (monthEnd == "" || monthEnd == 0) {
  monthEnd <- month(Sys.Date()) - 1
  if (monthEnd < 1) {
    monthEnd <- 12
  }
}

# Define parameters for function call
#ftp_root <- "ftp://opendata.dwd.de/climate_environment/CDC/"
#year = 2024
#monthEnd = 6
#main_directory <- "D:/radolan"
#monthStart = 6

############# Step 1 ###################
# Load function from script Skript1.R
source(file.path(main_directory, "src", "00_downloadTheFiles.R"))
# Call download_RADOLAN_files function with parameters
# Loop over months 1 to 6
for (month in monthStart:monthEnd) {
  download_RADOLAN_files(ftp_root, year, month, main_directory)
}

############# Step 2 ###################
# Call second script with parameters Skript2.R
source(file.path(main_directory, "src", "01_extractRadolan.R"))
for (month in monthStart:monthEnd) {
  datapath = main_directory
  process_RADOLAN_data(datapath, year, month)
}

############# Step 3 ###################
# Call third script with parameters Skript3.R
source(file.path(main_directory, "src", "02_combineRadolan.R"))
outpath = main_directory
for (month in monthStart:monthEnd) {
  combine_RADOLAN_data(outpath, year, month)
}

############# Step 4 ###################
# Call fourth script with parameters Skript4.R
source(file.path(main_directory, "src", "04_reformat_for_DB.R"))
mainpath = main_directory
for (month in monthStart:monthEnd) {
  format_radolan_for_database(mainpath, year, month) 
}

base_dir <- file.path(main_directory, "data_extracted/", year, monthEnd, "/")

# Function to determine stations from file names
get_stations <- function(base_dir) {
  files <- list.files(path = base_dir, recursive = TRUE, pattern = "\\.csv$", full.names = TRUE)
  stations <- unique(str_extract(basename(files), "^[^\\.]+"))
  return(stations)
}

# List of months
months <- sprintf("%02d", monthStart:monthEnd)

# Automatically generate list of stations
stations <- get_stations(base_dir)

# Function to read and merge CSV files per station
process_station <- function(station) {
  station_data <- map_dfr(months, function(month) {
    file_path <- file.path(base_dir, month, paste0(station, ".csv"))
    if (file.exists(file_path)) {
      read_csv(file_path)
    } else {
      NULL
    }
  })
  
  actual_data_url <- file.path(main_directory, "data_extracted/", year, paste0(monthStart, "_", monthEnd))
  if (!dir.exists(actual_data_url)) {
    dir.create(actual_data_url)
    cat("Created empty directory:", actual_data_url, "\n")
  } else {
    cat("Directory already exists:", actual_data_url, "\n")
  }
  write_csv(station_data, file.path(actual_data_url, paste0(station, ".csv")))
}

# Process each station
walk(stations, process_station)
