# Radolan Data Processing - Automated Processing and Analysis of Climate Data

### Project Description

This project involves the automation of Radolan data processing using R scripts. It is possible to execute it monthly via Windows Task Scheduler (see the `run_RADOLAN_Win.bat`), or directly with `run_RADOLAN_Win` for Windows and `run_RADOLAN_Lin` for Ubuntu. Please do not forget to edit these run files to provide the actual data for the parameters such as the FTP root directory, year, start month, main directory path and,end month. The goal is to download, extract, combine, and reformat Radolan data for further analysis and storage. Below are the detailed steps involved in the process:

 ### Steps Involved in the Process
  
1. **Download Data:**
  - Connect to the FTP server of the DWD.
  - Download the required Radolan data files for the specified period.

2. **Extract Data:**
  - Extract the downloaded data files to a local directory.

3. **Combine Data:**
  - Merge the extracted data files into a single dataset for the specified period.

4. **Reformat Data:**
  - Convert the combined dataset into a suitable format(csv) for further analysis and storage.
  - 
### Author

The original project was created by Hanna Mayer
- **GitHub:** [https://github.com/orgs/environmentalinformatics-marburg/people/HannaMeyer] 
### Extensions and Improvements

The project was extended and improved by:

- **Name:** Spaska Forteva
- **GitHub:** [https://github.com/orgs/environmentalinformatics-marburg/people/sforteva] 

