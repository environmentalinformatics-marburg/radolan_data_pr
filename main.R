# Author: Spaska Forteva
# Description: This function formats RADOLAN precipitation data for a database.
# Main script to loads the RADOLAN data, processes it, and writes the formatted data to CSV files for each plotID.
# Last change: 2024-07-05 Spaska Forteva

library(sp)
library(rgdal)
library(dplyr)
library(readr)
library(purrr)
library(stringr)

args <- commandArgs(trailingOnly = TRUE)

# Definiere die Parameter basierend auf den Argumenten
ftp_root <- args[1]
year <- as.integer(args[2])
monthEnd <- as.integer(args[3])
main_directory <- args[4]
monthStart <- as.integer(args[5])

if(monthStart=="" || monthStart == 0) {
  monthStart = 1
}
if(monthEnd=="" || monthEnd == 0) {
  print("Please write the content for month")
}  

# Definieren der Parameter für den Aufruf der Funktion
#ftp_root <- "ftp://opendata.dwd.de/climate_environment/CDC/"
#year = 2024
#monthEnd = 6
#main_directory <- "D:/radolan"
#monthStart = 6

############# Step 1 ###################
# Laden der Funktion aus dem Skript Skript1.R
source(file.path(main_directory, "00_downloadTheFiles.R"))
# Aufrufen der Funktion download_RADOLAN_files mit den Parametern
# Schleife über die Monate 1 bis 6
for (month in monthStart:monthEnd) {
  download_RADOLAN_files(ftp_root, year, month, main_directory)
}

############# Step 2 ###################
# Aufrufen des zweiten Skripts mit Parametern Skript2.R
source(file.path(main_directory, "01_extractRadolan.R"))
for (month in monthStart:monthEnd) {
  datapath = main_directory
  process_RADOLAN_data(datapath, year, month)
}
############# Step 3 ###################
# Aufrufen des zweiten Skripts mit Parametern Skript3.R
source(file.path(main_directory, "02_combineRadolan.R"))
outpath = main_directory
for (month in monthStart:monthEnd) {
  combine_RADOLAN_data(outpath, year, month)
}

############# Step 4 ###################
# Aufrufen des zweiten Skripts mit Parametern Skript4.R
source(file.path(main_directory, "04_reformat_for_DB.R"))
mainpath = main_directory
for (month in monthStart:monthEnd) {
  format_radolan_for_database(mainpath, year, month) 
}



base_dir <- file.path("D:/radolan/data_extracted/", year, monthEnd, "/")
stations <-""
# Funktion zum Ermitteln der Stationen aus den Dateinamen
get_stations <- function(base_dir) {
  files <- list.files(path = base_dir, recursive = TRUE, pattern = "\\.csv$", full.names = TRUE)
  stations <- unique(str_extract(basename(files), "^[^\\.]+"))
  return(stations)
}

# Liste der Monate
months <- sprintf("%02d", monthStart:monthEnd)

# Liste der Stationen automatisch generieren
stations <- get_stations(base_dir)

# Funktion zum Einlesen und Zusammenführen der CSV-Dateien pro Station
process_station <- function(station) {
  station_data <- map_dfr(months, function(month) {
    file_path <- file.path(base_dir, month, paste0(station, ".csv"))
    if (file.exists(file_path)) {
      read_csv(file_path)
    } else {
      NULL
    }
  })
  
  actual_data_url <- file.path("D:/radolan/data_extracted/", year, paste0(monthStart,"_",monthEnd))
  if (!dir.exists(actual_data_url)) {
    dir.create(actual_data_url)
    cat("Leerer Ordner erstellt:", actual_data_url, "\n")
  } else {
    cat("Ordner existiert bereits:", actual_data_url, "\n")
  }
  write_csv(station_data, file.path(actual_data_url, paste0(station, ".csv")))
}

# Verarbeite jede Station
walk(stations, process_station)


# Verarbeite jede Station
walk(stations, process_station)

