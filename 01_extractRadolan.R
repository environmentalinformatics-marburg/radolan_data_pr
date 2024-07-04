# Skript2.R
# Author: Hanna Mayer
# Description: Function to process RADOLAN data
# The FTP server URL and the output directory are passed as parameters.
# Last change: 2024-07-01 Spaska Forteva

process_RADOLAN_data <- function(datapath, year, month) {
  # Clear workspace and load required libraries
  rm(list=ls())
  library(rgdal)
  library(raster)
  
  # Define paths for data and results based on datapath
  tmppath <- file.path(datapath, "tmp")
  shppath <- file.path(datapath, "Plots")
  resultpath <-file.path(datapath, "results")
  out_directory <- file.path(datapath, year, month)
  
  # Erstelle den Ordner, falls er nicht existiert
  if (!dir.exists(resultpath)) {
    dir.create(resultpath)
    cat("Leerer Ordner erstellt:", resultpath, "\n")
  } else {
    cat("Ordner existiert bereits:", resultpath, "\n")
  }
  
  # Erstelle den Ordner, falls er nicht existiert
  if (!dir.exists(tmppath)) {
    dir.create(tmppath)
    cat("Leerer Ordner erstellt:", tmppath, "\n")
  } else {
    cat("Ordner existiert bereits:", tmppath, "\n")
  }
  
  # Set temporary directory for raster operations
  rasterOptions(tmpdir=tmppath)
  
  # Read polygons from shapefile, transform coordinate system, and create SpatialPointsDataFrame
  plotPolygons <- readOGR(file.path(shppath, "all_eps_updated_utm32N.shp"))
  plotPolygons <- spTransform(plotPolygons, "+proj=stere +lat_0=90.0 +lon_0=10.0 +lat_ts=60.0 +a=6370040 +b=6370040 +units=m")
  plots <- SpatialPointsDataFrame(coords = coordinates(plotPolygons), data = data.frame(name=plotPolygons$EP), proj4string = plotPolygons@proj4string)
  
  # Display summary of SpatialPointsDataFrame
  print(plots)
  
  # Extract .tar files
  files <- list.files(out_directory, pattern=".tar", full.names = TRUE)
  lapply(files, untar, exdir=out_directory)
  

  
  # Extract .tar.gz files
  files <- list.files(out_directory, pattern="*.tar.gz", full.names = TRUE)
  lapply(files, untar, exdir=out_directory)
  
  # Extract .asc files and extract data for each raster
  files <- list.files(out_directory, pattern=".asc", full.names = TRUE)
  results <- vector("list", length(files))
  for (i in 1:length(files)){
    file <- raster(files[i])
    projection(file) <- "+proj=stere +lat_0=90.0 +lon_0=10.0 +lat_ts=60.0 +a=6370040 +b=6370040 +units=m"
    results[[i]] <- extract(file, plots, df=FALSE)
  }
  
  # Combine results into a data frame
  results <- data.frame(do.call("rbind", results))
  names(results) <- plots$name
  
  # Extract date from file names and add as a column in results
  results$Date <- strptime(substr(files, nchar(files)-16, nchar(files)-4), format="%Y%m%d-%H%M")
  
  # Save results as .RData file
  save(results, file=file.path(resultpath, paste0("RADOLAN_extracted_", year, ".RData")))
  
  # Print completion message
  print(paste0("Year ", year, " processing complete..."))
}

