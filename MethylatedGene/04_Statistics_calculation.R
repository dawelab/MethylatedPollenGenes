library(tidyverse)
####Get the dataset from github
#Zm00001eb007510 is duplicated, remove one %>% filter(gene != "pan_gene_50793" & pan != "pan_gene_29491")
B73_all <- read.csv("https://raw.githubusercontent.com/dawelab/Natural-methylation-epialleles-correlate-with-gene-expression-in-maize/main/Data/B73.all.csv")[-c(680,35011),]  
length(B73_all$gene[!is.na(B73_all$gene)])
length(B73_all$epiallele[!is.na(B73_all$epiallele)])
#table(B73_all$epiallele)
#Redefine epiallele
B73_all$epiallele[B73_all$mCG <= .05 & B73_all$mCHG <= .05 & B73_all$cCG >=30 & B73_all$cCHG >= 30] <- "UM" 
B73_all$epiallele[B73_all$mCG >= .2 & B73_all$mCHG <= .05& B73_all$cCG >=30 & B73_all$cCHG >= 30] <- "gbM" 
B73_all$epiallele[B73_all$mCG >= .4 & B73_all$mCHG >= .4& B73_all$cCG >=30 & B73_all$cCHG >= 30] <- "teM"
table(B73_all$epiallele,B73_all$class)
table(B73_all$epiallele[B73_all$class == "Core Gene"])
table(B73_all$epiallele[B73_all$class == "Core Gene" & B73_all$cCG >= 30 & B73_all$cCHG >= 30])

#Pollen teM gene
pollen_teM_gene <- B73_all  %>% filter(epiallele == "teM") %>% filter(anther >= 10 ) %>%
  filter( embryo/anther < .1 & endosperm/anther < .1 & root/anther < .1 & shoot/anther < .1 &   base/anther < .1      & middle/anther < .1 & tip/anther < .1 &  ear/anther < .1   ) 

#write.csv(pollen_teM_gene,file)

geneID_TEinter <- read.table("/Users/x/Desktop/Data/pollen/Zm-B73-REFERENCE-NAM-5.0.CDS_inter_TE.bed") 
geneID_TEinter <- geneID_TEinter$V4 %>% as.data.frame() %>% unique()
names(geneID_TEinter) <- "gene"
df_TE <- data.frame(gene = geneID_TEinter,
                    TE = "Y") %>% unique()
B73_all <- read.csv("https://raw.githubusercontent.com/dawelab/Natural-methylation-epialleles-correlate-with-gene-expression-in-maize/main/Data/B73.all.csv")  %>% filter(pan != "pan_gene_50793")
all_gene_set <- data.frame(gene=B73_all$gene)
df_TE <- merge(all_gene_set,df_TE,by="gene",all.x=T) %>% unique()
df_TE$TE[is.na(df_TE$TE)] <- "N"

DEG <- read.csv("/Users/x/Desktop/Data/pollen/DEGAnalysisNov29.csv") 
strongDEG <- DEG[DEG$class == "Strong DE",1] 
names(strongDEG) <- "gene"
df_strongDEG <- data.frame(gene=strongDEG,strongDEG = "Y")
df_DEG <- merge(all_gene_set,df_strongDEG,by="gene",all.x=T)
df_DEG$strongDEG[is.na(df_DEG$strongDEG)] <- "N"

#Merge the redefined epiallele matrix, TE(CDS), DEG dummy variable together.
df <- merge(B73_all,df_TE, by = "gene", all.x = T) %>% unique()
dim(df)#[,c("class","cCG","cCHG","gene","epiallele")]
df <- merge(df, df_DEG, by = "gene", all.x = T) %>% unique
dim(df)
table(df$epiallele[df$cCG>=30 & df$cCHG >= 30 & df$class == "Core Gene" & df$TE == "N"])

df %>% filter(class == "Core Gene" & TE == "Y") %>% dim()
df %>% filter(class == "Core Gene" & TE == "N")
df %>% filter(class == "Core Gene" & TE == "N" & (cCG<30 | cCHG< 30)) %>% dim()
df %>% filter(class == "Core Gene" & TE == "N"& cCG>=30 & cCHG >= 30) %>% select(epiallele) %>% table()

df %>% select(c("class","strongDEG")) %>% table()
df %>% filter(class == "Core Gene" & strongDEG == "Y" ) %>% dim() 
df %>% filter(class == "Core Gene" & strongDEG == "Y" & cCG>=30 & cCHG >= 30) %>% dim()  
df %>% filter(class == "Core Gene" & strongDEG == "Y" & (cCG<30 | cCHG< 30)) %>% dim()  
df %>% filter(class == "Core Gene" & strongDEG == "Y" & cCG>=30 & cCHG >= 30 & TE == "Y") %>% dim()  
df %>% filter(class == "Core Gene" & strongDEG == "Y" & cCG>=30 & cCHG >= 30 & TE == "N") %>% dim()  
df %>% filter(class == "Core Gene" & strongDEG == "Y" & cCG>=30 & cCHG >= 30 & TE == "N" & rowSums(df[,14:23] < 10) != 10) %>% dim()  
