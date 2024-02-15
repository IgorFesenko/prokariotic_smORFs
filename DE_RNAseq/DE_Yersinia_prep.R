if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
#BiocManager::install("edgeR")

rm(list=ls())

setwd('DE_RNAseq')

library(edgeR)  
#install.packages("ggplot2")  # Install 'ggplot2' package (if not installed)
library(ggplot2)
library(dplyr)

################################################
fc <- read.table('Yersinia_FeatureCounts_DE', sep='\t', header=TRUE)
colnames(fc)
dim(fc)

#Filtering based values from other table
table_for_filter <- read.table('CoverageDE.csv', sep=',', header=TRUE)
head(table_for_filter)
dim(table_for_filter)

# Column name in fc to be used for filtering
filter_column_name <- "Geneid"

# Extract the values to be used for filtering from table2
filter_values <- table_for_filter$attr


# Filter out rows in table1 that match the values from table2
filtered_fc <- fc %>% filter(!get(filter_column_name) %in% filter_values)

#filtered_fc <- fc %>% filter(!.data[[filter_column_name]] %in% filter_values)

# Print the filtered table
head(filtered_fc)
dim(filtered_fc)



colnames(filtered_fc) <-  sub('.trimmed.bam','',colnames(filtered_fc))
colnames(filtered_fc) <-  sub('X.data.fesenkoi2.RNAseqDE.','',colnames(filtered_fc))
colnames(filtered_fc)

filt_fc <- filtered_fc[,-c(2,3,4,5,6)]
row.names(filt_fc) <- filt_fc$Geneid
filt_fc$Geneid <- NULL

#rename columns
# Rename columns using colnames function
colnames(filt_fc) <- c("AceticAcid1", "AceticAcid2", "AceticAcid3", 
                       "BileSalt1", "BileSalt2", "BileSalt3",
                       "Control1", "Control2","Control3",
                       "dipyridryl1", "dipyridryl2", "dipyridryl3",
                       "OxygenDepr1",  "OxygenDepr2", "OxygenDepr3",
                       "RemovalNutr1", "RemovalNutr2", "RemovalNutr3",
                       "Spermin1", "Spermin2", "Spermin3",
                       "NaCl1", "NaCl2", "NaCl3",
                       "H2O2_1", "H2O2_2", "H2O2_3",
                       "StatPhase1", "StatPhase2", "StatPhase3",
                       "41C_1", "41C_2", "41C_3",
                       "Ca2depletion1", "Ca2depletion2", "Ca2depletion3") 
head(filt_fc)

saveRDS(filt_fc,'countsYersinia.Rdata') # save counts

###########################################
edger = DGEList(filt_fc) # создаем объект edgeR хранящий каунты
edger = calcNormFactors(edger,method='TMM')
edger$samples

# get TMM-norm cpms
cpm = cpm(edger)
write.csv(cpm, file = "cpm_values_Yersinia.csv", row.names = TRUE)
