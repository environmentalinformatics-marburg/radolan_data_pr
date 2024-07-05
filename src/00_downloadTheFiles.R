# Skript1.R
# Author: Hanna Mayer
# Description: This script downloads historical RADOLAN files from an FTP server.
# The FTP server URL and the output directory are passed as parameters.
# Last change: 2024-07-05 Spaska Forteva


download_RADOLAN_files <- function(ftp_root, year, month, out_directory) {
  # Define the base URL to the RADOLAN files
  base_url <- paste0(ftp_root, "/grids_germany/hourly/radolan/recent/asc/")
  
  # Check if the 'remotes' package is installed, and install it if necessary
  if (!requireNamespace("remotes", quietly = TRUE)) {
    install.packages("remotes", repos = "https://cloud.r-project.org")
  }
  
  # Install the KWB package 'kwb.dwd' from GitHub
  remotes::install_github("KWB-R/kwb.dwd")
  
  # Generate a sequence of dates for the given month
  dates <- seq(as.Date(paste0(year, "-", sprintf("%02d", month), "-01")), 
               as.Date(paste0(year, "-", sprintf("%02d", month), "-", days_in_month(month))), by="day")
  
  # Create the URLs based on the dates
  urls <- paste0(base_url, "RW-", format(dates, "%Y%m%d"), ".tar.gz")
  
  out_directory <- file.path(out_directory,year,month)
  
  # Check if the out_directory exists, if not, create it
  if (!dir.exists(out_directory)) {
    dir.create(out_directory, recursive = TRUE)
  }
  
  # Download the files
  sapply(urls, function(url) {
    file <- file.path(out_directory, basename(url))
    print(paste0("Downloading: ", url))
    download.file(url, file)
  })
  
  
  # Liste aller PDF-Dateien im Verzeichnis
  pdf_files <- list.files(out_directory, pattern = "\\.pdf$", full.names = TRUE)
  
  # Lösche jede PDF-Datei
  for (file in pdf_files) {
    file.remove(file)
  }
  
}

# Helper function to get the number of days in a given month
days_in_month <- function(month) {
  if (month %in% c(1, 3, 5, 7, 8, 10, 12)) {
    return(31)
  } else if (month %in% c(4, 6, 9, 11)) {
    return(30)
  } else if (month == 2) {
    return(28) # For simplicity, ignoring leap years
  }
}

# Beispielaufruf der Funktion mit Parametern
# ftp_root <- "ftp://opendata.dwd.de/climate_environment/CDC/"
# out_directory <- "D:/radolan/2024/"
# download_RADOLAN_files(ftp_root, out_directory)


#remotes::install_github("kwb-r/kwb.dwd")


# Install kwb.dwd from GitHub
#remotes::install_github("kwb-r/kwb.dwd")

# Install the current development version
#remotes::install_github("kwb-r/kwb.dwd@dev")



# Define the root path to DWD's FTP server
#ftp_root <- "ftp://opendata.dwd.de/climate_environment/CDC/"

# Define the URL to the historical RADOLAN files
#url <- paste0(ftp_root, "/grids_germany/hourly/radolan/recent/asc/")

# List all historical RADOLAN files
#urls <- kwb.dwd::list_url(url, recursive = TRUE)