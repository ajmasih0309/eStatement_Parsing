# eStatement Parsing
Parsing Data from PDFs &amp; data preparation from eStatement for analysis

Steps for Extracting all statement in one csv & creating dashboard:
1. Download all pdf statements from email or online banking portal.
2. Open PDF in Google Chrome & create a copy using Print to PDF option.
3. For First PDF file, Use the code to extract cleaned data in csv file along with headers
4. For following PDF files, repeat step 2 & 3 with append = TRUE
5. Export csv into excel using get data --> csv file option.
6. Modify dashboard as per your need.
7. Repeat step 1 to 4 for new month's statement & refresh your excel workbook to populate new data. 
