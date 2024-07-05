# Author: Hanna Mayer
# Description: This function formats RADOLAN precipitation data for a database.
# It loads the RADOLAN data, processes it, and writes the formatted data to CSV files for each plotID.
# Last change: 2024-07-05 Spaska Forteva

# Load necessary libraries
#rm(list=ls())

# Define the function
format_radolan_for_database <- function(mainpath, year, month) {
  # Set the path for extracted data
  out_directory <- file.path(mainpath, "data_extracted")
  
  # Erstelle den Ordner, falls er nicht existiert
  if (!dir.exists(out_directory)) {
    dir.create(out_directory)
    cat("Leerer Ordner erstellt:", out_directory, "\n")
  } else {
    cat("Ordner existiert bereits:", out_directory, "\n")
  }
  # Set the path for extracted data
  out_directory <- file.path(out_directory, year)
  
  # Erstelle den Ordner, falls er nicht existiert
  if (!dir.exists(out_directory)) {
    dir.create(out_directory)
    cat("Leerer Ordner erstellt:", out_directory, "\n")
  } else {
    cat("Ordner existiert bereits:", out_directory, "\n")
  }
  
  # Set the path for extracted data
  out_directory <- file.path(out_directory, month)
  
  # Erstelle den Ordner, falls er nicht existiert
  if (!dir.exists(out_directory)) {
    dir.create(out_directory)
    cat("Leerer Ordner erstellt:", out_directory, "\n")
  } else {
    cat("Ordner existiert bereits:", out_directory, "\n")
  }
  
  # Load the RADOLAN data
  radolan_file <-file.path(mainpath,paste0(year, month, "_radolan_melt.RData"))

  tryCatch({
    load(radolan_file)
  }, error = function(e) {
    stop(paste("Error: The file 'radolan_melt.RData' could not be found in the specified path:", mainpath))
  })
  
  # Rename columns for clarity
  names(radolan) <- c("datetime", "plotID", "precipitation_radolan")
  
  # Format plotID and datetime
  radolan$plotID <- paste0(substr(radolan$plotID, 1, 3), sprintf("%02d", as.numeric(substr(radolan$plotID, 4, 5))))
  radolan$datetime <- format(as.POSIXlt(radolan$datetime), "%Y-%m-%dT%H:%M")
  
  # Loop through each unique plotID and write data to CSV files
  for (i in unique(radolan$plotID)) {
    print(i)
    subs <- radolan[radolan$plotID == i, c(1, 3)]
    write.csv(subs, file.path(out_directory, paste0(i, ".csv")), row.names = FALSE, quote = FALSE)
  }
}

# Example usage
#mainpath <- "D:/radolan/Radolan"
#format_radolan_for_database(mainpath)
