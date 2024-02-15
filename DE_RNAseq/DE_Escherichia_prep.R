if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
#BiocManager::install("edgeR")
#install.packages("dplyr")


rm(list=ls())

setwd('/Users/fesenkoi2/Library/CloudStorage/OneDrive-Personal/SmORFs/raw_tables/DE_RNAseq')

library(edgeR)  # загрузка библиотеки
library(dplyr)
library(ggplot2)
# Загружаем данные по каунтам после featureCounts
fc <- read.table('Escherichia_FeatureCounts_DE', sep='\t', header=TRUE)
colnames(fc)
head(fc)
dim(fc)

#Filtering based values from other table
table_for_filter <- read.table('CoverageDE_combined_0.5below.csv', sep=',', header=TRUE)
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



# имена колонок содержать ".bam", уберем:
colnames(filtered_fc) <-  sub('.trimmed.bam','',colnames(filtered_fc))
colnames(filtered_fc) <-  sub('X.data.fesenkoi2.RNAseqDE.','',colnames(filtered_fc))
colnames(filtered_fc)

# оставляем нужные столбцы
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
                       "ProlongedGrowth1", "ProlongedGrowth2", "ProlongedGrowth3") 
head(filt_fc)



# Сохраняем промежуточные данные
saveRDS(filt_fc,'countsEscherichia.Rdata') # save counts

## Предварительный анализ данных для MDS PCA
# Нормализуем данные
edger = DGEList(filt_fc) # создаем объект edgeR хранящий каунты
# нормируем методом RLE
edger = calcNormFactors(edger,method='TMM')
edger$samples
edger$dispersion # смотрим на дисперсию


# get TMM-norm cpms
cpm = cpm(edger) # посчитаем cpm с учетом TMM нормировки
write.csv(cpm, file = "cpm_values_Escherichia.csv", row.names = TRUE) #выводим таблицу

########## ANALYSIS OF FILTRATION THRESHOLD ##############

# genes without expression
table(apply(filt_fc,1,mean) == 0)

# genes having coverage above 10 reads
table(apply(filt_fc,1,mean) >= 10) 

## LOOK AT LOG2CPM VALUES
# Calculate the log2 CPM values
log2_CPM <- cpm(edger, log = TRUE)

# Calculate the average log2 CPM values
avg_log2_CPM <- rowMeans(log2_CPM)

p <- ggplot(data.frame(avg_log2_CPM), aes(x = avg_log2_CPM)) +
  geom_histogram(binwidth = 0.5, fill = "blue", color = "black") +
  labs(title = "Distribution of Average log2 CPM",
       x = "Average log2 CPM",
       y = "Frequency")
p + geom_vline(xintercept = 2, linetype = "dashed", color = "red")

#Filtertion based on CPM values
keep <- rowSums(cpm(edger) > 0.5) >= 3
table(keep)

## TRUE: 4716

