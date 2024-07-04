# radolan
Radolan Data Processing Automation
This project involves the automation of Radolan data processing using R scripts, executed monthly via Windows Task Scheduler. The goal is to download, extract, combine, and reformat Radolan data for further analysis and storage. Below are the detailed steps involved in the process:

1. Downloading Radolan Files
The script initiates by downloading Radolan files from the DWD FTP server. The download parameters, such as the FTP root directory, year, and main directory path, are provided via command line arguments.

Function: download_RADOLAN_files
Source Script: 00_downloadTheFiles.R
Parameters:

ftp_root: The root URL of the FTP server.
year: The year for which data is being downloaded.
month: The month for which data is being downloaded.
main_directory: The local directory where downloaded files will be stored.
2. Extracting Radolan Data
After downloading, the script processes and extracts the Radolan data. This involves reading the raw files and extracting relevant information for analysis.

Function: process_RADOLAN_data
Source Script: 01_extractRadolan.R
Parameters:

datapath: The path to the downloaded Radolan data.
year: The year of the data.
month: The month of the data.
3. Combining Radolan Data
The next step combines the extracted data from multiple files into a coherent dataset. This combined dataset is then ready for further analysis.

Function: combine_RADOLAN_data
Source Script: 02_combineRadolan.R
Parameters:

RadolanPath: The path to the directory containing the extracted Radolan results.
outpath: The output directory where the combined data will be saved.
4. Reformatting Data for Database Storage
Finally, the script reformats the combined Radolan data to a structure suitable for database storage. This step ensures that the data is organized and can be efficiently queried from a database.

Function: format_radolan_for_database
Source Script: 04_reformat_for_DB.R
Parameters:

main_directory: The main directory containing the combined Radolan data.
Automation via Windows Task Scheduler
To ensure that the data processing is performed automatically each month, a batch script (run_RADOLAN.bat) is created to execute the R script (run_RADOLAN.R) with the required parameters. The Task Scheduler in Windows is used to run this batch script on a monthly schedule.

Setup Requirements for Running main.R
To execute or start main.R, ensure the following directory structure and files are present locally. For security reasons, these files are not uploaded to GitHub. For questions, please contact the script author or refer to the DFG project Exploratorien.
Ensure the Plots directory contains the necessary shape_file.shp for plot information and a validationData directory with required CSV files for plotting purposes.
