library(edgeR) 
rm(list=ls())
setwd('DE_RNAseq')


counts <-  readRDS('countsYersinia.Rdata')
head(counts)


################# DE ANALYSIS ##############

# genes without expression
table(apply(counts,1,mean) == 0)

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

edger <-  DGEList(counts = counts) 

keep <- rowSums(cpm(edger) > 0.5) >= 3
table(keep)
edger <- edger[keep, , keep.lib.sizes=FALSE]

edger = calcNormFactors(edger,method='TMM')
edger$samples

design <- model.matrix(~0+conditions, data = meta)
design

saveRDS(design,'designYersinia.Rdata') 


# biological coefficient of variation (BCV)
edger <-  estimateDisp(edger,design)
plotBCV(edger)
edger$common.dispersion

plotMDS(edger)

# fit GLM model
glm <-  glmFit(edger,design)
#plotQLDisp(glm)

############################################### CALCULATING DE GENES ###################################################



#### Analysin all datasets ############

condit <- c("conditions41C", "conditionsAceticAcid","conditionsBileSalt","conditionsdipyridryl","conditionsH2O2","conditionsNaCl",
            "conditionsOxygenDepr","conditionsRemovalNutr","conditionsSpermin","conditionsCa2depletion","conditionsStatPhase")


for (cond in condit) {
  # Code to be executed in each iteration
  x <- paste(cond, "conditionsControl", sep = "-")
  print(x)
  con <- makeContrasts(contrasts=x, levels=design)
  glf <- glmLRT(glm, contrast=con)
  
  #summary statistics
  print(summary(decideTests(glf)))
  # calculate FDR
  glf$table$FDR <- p.adjust(glf$table$PValue, method="BH")
  name <- paste("Yersinia_DEtest_", cond, ".csv",sep = "")
  write.csv(glf$table, file = name, row.names = TRUE)
}

for (cond in condit) {
  # Code to be executed in each iteration
  x <- paste(cond, "conditionsControl", sep = "-")
  print(x)
  con <- makeContrasts(contrasts=x, levels=design)
  tr <- glmTreat(glm, contrast=con, lfc=log2(1.5))
  tab <- topTags(tr,n=Inf, adjust.method = "BH")
  keep <- tab$table$FDR < 0.05
  tr_filtered <- tab[keep,]
  #summary statistics
  print(summary(decideTests(tr)))
  # calculate FDR
  #tr$table$FDR <- p.adjust(tr$table$PValue, method="BH")
  name <- paste("Yersinia_DEtestFC_", cond, ".csv",sep = "")
  write.csv(tr_filtered$table, file = name, row.names = TRUE)
  
}
