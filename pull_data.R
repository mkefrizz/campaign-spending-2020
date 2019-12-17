
# Load Libraries

library(dplyr)
library(politicaldata)
library(maps)
library(sqldf)
library(stringr)

# Get FEC Expenditures data
temp <- tempfile()
download.file("https://www.fec.gov/files/bulk-downloads/2020/oppexp20.zip",temp)
oppexp <- read.table(unz(temp, "oppexp.txt"), header=FALSE, sep="|", fill=TRUE)
unlink(temp)
remove(temp)

oppexp_head <- read.csv("https://www.fec.gov/files/bulk-downloads/data_dictionaries/oppexp_header_file.csv")

names(oppexp) <- names(oppexp_head) %>% tolower()
names(oppexp)[26] <- "none"

# Load FEC Candidate lookup

temp <-tempfile()
download.file("https://www.fec.gov/files/bulk-downloads/2020/cn20.zip",temp)
cand <- read.table(unz(temp, "cn.txt"), header=FALSE, sep="|", fill=TRUE)
cand_head <- read.csv("https://www.fec.gov/files/bulk-downloads/data_dictionaries/cn_header_file.csv")
names(cand) <- names(cand_head) %>% tolower()
unlink(temp)
remove(temp)

# Load FEC committee lookup

temp <-tempfile()
download.file("https://www.fec.gov/files/bulk-downloads/2020/cm20.zip",temp)
comm <- read.table(unz(temp, "cm.txt"), header=FALSE, sep="|", fill=TRUE)
comm_head <- read.csv("https://www.fec.gov/files/bulk-downloads/data_dictionaries/cm_header_file.csv")
names(comm) <- names(comm_head) %>% tolower()
unlink(temp)
remove(temp)

full <- inner_join(inner_join(oppexp, comm,by = "cmte_id"), cand, by="cand_id")

# Subset for presidential candidates only
pres <- full %>% filter(cand_office == "P")
