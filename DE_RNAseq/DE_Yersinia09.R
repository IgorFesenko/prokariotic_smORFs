#### DE ANALYSIS ####


rm(list=ls())
setwd('/Users/fesenkoi2/Library/CloudStorage/OneDrive-Personal/SmORFs/raw_tables/DE_RNAseq')


library(edgeR) 

# загружаем данные которые сохранили в прошлый раз
counts <-  readRDS('countsYersinia09.Rdata')
head(counts)


################# DE ANALYSIS ##############

# genes without expression
table(apply(counts,1,mean) == 0)

#задаем метаданные для образцов
meta <-  data.frame(conditions=c("AceticAcid", "AceticAcid", "AceticAcid", 
                                 "BileSalt", "BileSalt", "BileSalt",
                                 "Control", "Control","Control",
                                 "dipyridryl", "dipyridryl", "dipyridryl",
                                 "OxygenDepr",  "OxygenDepr", "OxygenDepr",
                                 "RemovalNutr", "RemovalNutr", "RemovalNutr",
                                 "Spermin", "Spermin", "Spermin",
                                 "NaCl", "NaCl", "NaCl",
                                 "H2O2", "H2O2", "H2O2",
                                 "StatPhase", "StatPhase", "StatPhase",
                                 "41C", "41C", "41C",
                                 "Ca2depletion", "Ca2depletion", "Ca2depletion")) 
rownames(meta) = colnames(counts)
table(meta)
meta

## Загружаем данные в edgeR и нормализуем
edger <-  DGEList(counts = counts) # создаем объект edgeR хранящий каунты

#фильтруем по покрытию
#keep <- filterByExpr(edger)
keep <- rowSums(cpm(edger) > 0.5) >= 3
#fc10 = fc[apply(fc,1,mean) >= 10,]
table(keep)
edger <- edger[keep, , keep.lib.sizes=FALSE]

#fc10 = fc[apply(fc,1,mean) >= 10,]
#table(apply(edger,1,mean) >= 10) 


# нормируем методом TMM
edger = calcNormFactors(edger,method='TMM')
edger$samples

#cpm = cpm(edger) # посчитаем cpm с учетом TMM нормировки
#write.csv(cpm, file = "cpm_values_test.csv", row.names = TRUE) #выводим таблицу

#создаем матрицу дизайна

design <- model.matrix(~0+conditions, data = meta)
design

# Сохраняем промежуточные данные
#saveRDS(design,'designEscherichia.Rdata') 


# biological coefficient of variation (BCV)
# рисуем зависимость биологической вариабельности от средней экспрессии, 
#немного падает с ростом экпсрессии
edger <-  estimateDisp(edger,design)
plotBCV(edger)
edger$common.dispersion

plotMDS(edger)

############################################### CALCULATING DE GENES ###################################################

# fit GLM model
glm <-  glmFit(edger,design)

#### Analysing all datasets ############

condit <- c("conditions41C", "conditionsAceticAcid","conditionsBileSalt","conditionsdipyridryl","conditionsH2O2","conditionsNaCl",
            "conditionsOxygenDepr","conditionsRemovalNutr","conditionsSpermin","conditionsCa2depletion","conditionsStatPhase")


# Creating table for DE analysis with glmTreat function (calculating FDR and FC)

for (cond in condit) {
  # Code to be executed in each iteration
  x <- paste(cond, "conditionsControl", sep = "-")
  print(x)
  con <- makeContrasts(contrasts=x, levels=design)
  #glf <- glmLRT(glm, contrast=con)
  tr <- glmTreat(glm, contrast=con, lfc=log2(1.5))
  tab <- topTags(tr,n=Inf, adjust.method = "BH")
  keep <- tab$table$FDR < 0.05
  tr_filtered <- tab[keep,]
  #summary statistics
  print(summary(decideTests(tr)))
  # calculate FDR
  #tr$table$FDR <- p.adjust(tr$table$PValue, method="BH")
  name <- paste("Yersinia_DEFCcov09_", cond, ".csv",sep = "")
  write.csv(tr_filtered$table, file = name, row.names = TRUE)
  
}


