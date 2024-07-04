# Laden der erforderlichen Bibliotheken, z.B. 'sp' und 'rgdal'
library(sp)
library(rgdal)

args <- commandArgs(trailingOnly = TRUE)

# Definiere die Parameter basierend auf den Argumenten
ftp_root <- args[1]
year <- as.integer(args[2])
month <- as.integer(args[3])
main_directory <- args[4]

# Definieren der Parameter für den Aufruf der Funktion
#ftp_root <- "ftp://opendata.dwd.de/climate_environment/CDC/"
#year = 2024
#month = 6
#main_directory <- "D:/radolan"

############# Step 1 ###################
# Laden der Funktion aus dem Skript Skript1.R
source(file.path(main_directory, "00_downloadTheFiles.R"))
# Aufrufen der Funktion download_RADOLAN_files mit den Parametern
# Schleife über die Monate 1 bis 6
for (month in 1:month) {
  download_RADOLAN_files(ftp_root, year, month, main_directory)
}

############# Step 2 ###################
# Aufrufen des zweiten Skripts mit Parametern Skript2.R
source(file.path(main_directory, "01_extractRadolan.R"))
# datapath <- "D:/radolan"
process_RADOLAN_data(main_directory, year, month)

############# Step 3 ###################
# Aufrufen des zweiten Skripts mit Parametern Skript3.R
source(file.path(main_directory, "02_combineRadolan.R"))
# Define paths and variables
RadolanPath <-file.path(main_directory, "results")
combine_RADOLAN_data(RadolanPath, main_directory)

############# Step 4 ###################
# Aufrufen des zweiten Skripts mit Parametern Skript4.R
source(file.path(main_directory, "04_reformat_for_DB.R"))
format_radolan_for_database(main_directory) 
