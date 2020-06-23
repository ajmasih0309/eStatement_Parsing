# Loading Libraries
library(pdftools) # for parsing & cleaning pdfs
library(tidyverse) # for tidying things

# Reading pdf files
current.pdf <- pdf_text("./PDFs/Sample_apr_2020.pdf") %>% 
  read_lines()

### Following steps can be modified to meet the parsing strategy of the pdfs you are dealing with.

# creating Start & End line indices for Statement Part
start.statement <- grep("PREVIOUS BALANCE", current.pdf) + 1 # can be setup to match any text which marks the beginning of tabular structure of Statement
end.statement <- grep("NEW BALANCE", current.pdf) - 1 # can be setup to match any text which marks the ending of tabular structure of Statement

# Selecting Statement Part
statement <- current.pdf[start.statement:end.statement]

# Preparing Data into tibble
statement.cleaned <- statement %>% 
  str_squish() %>% # Removing extra white spaces
  str_split(" ", n = 2) %>%  # n columns to be split at first " "
  unlist() %>% # unnesting into single chr vector
  matrix(ncol = 2, byrow = TRUE) %>%  # ncol should match with n from str_split operation
  as_tibble() # Column auto naming, V1 will be first column

# Cleaning Up data & saving in csv file
statement.cleaned %>% 
  mutate(Date = as.Date(paste0("20",substr(V1, 5, 6),"-",substr(V1, 3, 4),"-", substr(V1, 1, 2))), # In Sample file date is in ddmmyy format
         # The amt part is matched for amt with CR and removed for new column (DR can also be configured in regex, if it is contained in statement)
         Description = trimws(gsub("\\d*,*\\d+\\.\\d{2}[CR]*", "", V2)),
         # The amt part is matched for amt with CR and copied in new column (DR can also be configured in regex, if it is contained in statement) 
         Amt = trimws(str_extract(V2, "\\d*,*\\d+\\.\\d{2}[CR]*")),
         # Separating & Cleaning Credited Amount
         Credit = trimws(gsub("[A-Z,]", "", str_extract(Amt, ".*CR"))),
         # Separating & Cleaning Debited Amount
         Debit = trimws(gsub("[,]", "",if_else(is.na(Credit), Amt, NULL)))) %>% 
  type_convert() %>% 
  mutate(Credit = replace_na(Credit, 0),
         Debit = replace_na(Debit, 0)) %>% 
  select(-V1, -V2) %>%
  write_csv("All_Transactions.csv",
            append = FALSE # append = FALSE for 1st File, TRUE for 2nd file onward
            ) 
