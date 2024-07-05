#!/bin/bash

# R Skript ausführen und Fehler in error.log speichern
Rscript "/path/to/radolan/main.R" "ftp://opendata.dwd.de/climate_environment/CDC/" 2024 6 "/path/to/radolan" 6 2> "/path/to/radolan/error.log"
