library(tidyverse)
library(matrixStats)
####Get the dataset from github
#Zm00001eb007510 is duplicated, remove one
B73_all <- read.csv("https://raw.githubusercontent.com/dawelab/Natural-methylation-epialleles-correlate-with-gene-expression-in-maize/main/Data/B73.all.csv")  %>% filter(pan != "pan_gene_50793")
#table(B73_all$epiallele)
#Redefine epiallele
B73_all$epiallele[B73_all$mCG <= .05 & B73_all$mCHG <= .05 & B73_all$cCG >=30 & B73_all$cCHG >= 30] <- "UM" 
B73_all$epiallele[B73_all$mCG >= .2 & B73_all$mCHG <= .05& B73_all$cCG >=30 & B73_all$cCHG >= 30] <- "gbM" 
B73_all$epiallele[B73_all$mCG >= .4 & B73_all$mCHG >= .4& B73_all$cCG >=30 & B73_all$cCHG >= 30] <- "teM"

#Pollen teM gene
pollen_teM_gene <- B73_all  %>% filter(epiallele == "teM") %>% filter(anther >= 10 ) %>%
  filter( embryo/anther < .1 & endosperm/anther < .1 & root/anther < .1 & shoot/anther < .1 &   base/anther < .1      & middle/anther < .1 & tip/anther < .1 &  ear/anther < .1   ) 

#write.csv(pollen_teM_gene,file)

##Filter the cores genes with expression tpm value greater than 10 in at least one tissue.

B73_core_express <- B73_all %>% filter(rowSums(B73_all[,14:23] < 10) != 10 &
                                class == "Core Gene" & 
                                  cCG >=30 & cCHG >= 30) 
