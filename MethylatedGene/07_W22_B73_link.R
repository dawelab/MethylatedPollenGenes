library(tidyverse)
pan_link <- read_tsv("/Users/yibingzeng/Desktop/MPG/pan-zea.v2.pan-genes_table_geneIDonly.tsv")
#The B73v5 geneID starts with Zm00001eb
#The W22 geneID starts with Zm00004b
df_pan <- NULL
for (i in 2:dim(pan_link)[2]) {
  temp <- data.frame(pan=pan_link$`#pangene`,
                     gene=unlist(pan_link[,i],use.names = F)) 
  df_pan <- rbind(df_pan,temp)
}
####Create dataframe for B73v5 with its panID, so as W22
df_pan %>% filter(gene!="NONE") %>% filter("Zm00001eb" %in% gene) %>%head()
df_B73 <- df_pan[grep("Zm00001eb",df_pan$gene),]
df_W22 <- df_pan[grep("Zm00004b",df_pan$gene),]
#split the geneID by ","
df_B73_split <- df_B73 %>%
  separate(gene, into = paste0("V", 1:14), sep = ",", fill = "right", extra = "merge")
df_W22_split <- df_W22 %>%
  separate(gene, into = paste0("V", 1:71), sep = ",", fill = "right", extra = "merge")
#Transform the data into dataframe formate with two columns, the first column contain panID
#And the second column contain geneID
##For B73
df_B73_pan_gene <- NULL
for (i in 2:dim(df_B73_split)[2]) {
  temp <- data.frame(pan=df_B73_split$pan,gene=unlist(df_B73_split[,i],use.names = F))
  df_B73_pan_gene <- rbind(df_B73_pan_gene,temp) %>% filter(!is.na(gene))
}
#For W22
df_W22_pan_gene <- NULL
for (i in 2:dim(df_W22_split)[2]) {
  temp <- data.frame(pan=df_W22_split$pan,W22=unlist(df_W22_split[,i],use.names = F))
  df_W22_pan_gene <- rbind(df_W22_pan_gene,temp) %>% filter(!is.na(W22))
}
#Merge B73 and W22 with pangene ID link
df <- merge(df_B73_pan_gene,df_W22_pan_gene,by="pan", all=T)
##Download the B73 pan gene class from Zeng et all (2023) github link
B73_all <- read.csv("https://raw.githubusercontent.com/dawelab/Natural-methylation-epialleles-correlate-with-gene-expression-in-maize/main/Data/B73.all.csv")
B73_core <- B73_all %>% filter(class == "Core Gene")
##Get the W22 gff3 for merging
W22_gff3 <- read.table("/Users/yibingzeng/Desktop/MPG/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_geneID.gff3")
names(W22_gff3)[1] <- "W22"
#All W22 core gene list
W22_B73_core <- merge(df,B73_core,by="gene",all.y=T) %>% filter(!is.na(W22)) %>% select(W22)
df_W22_core <- merge(W22_B73_core,W22_gff3,by="W22",all.x=T)[,-1]
write.table(df_W22_core,file = "/Users/yibingzeng/Desktop/MPG/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core.gff3",
          quote = F, row.names = F, col.names = F, sep = "\t")
# W22 pollen genes. You'll need to define this list in B73 first. Use the same method you used to define MPGs, except ignore methylation. This should be all core genes with pollen-specific expression. Then find the corresponding W22 genes.
B73_pollen_gene <- B73_core %>% filter(anther >= 10  & embryo/anther < .1 & root/anther < .1 & shoot/anther < .1 &   base/anther < .1      & middle/anther < .1 & tip/anther < .1 &  ear/anther < .1) %>% select(gene)
B73_pollen_gene_W22_link <- merge(B73_pollen_gene,df, by ="gene",all.x=T) %>% filter(!is.na(W22)) %>% select("W22")
df_W22_pollenGene <- merge(B73_pollen_gene_W22_link,W22_gff3, all.x=T)[,-1]
write.table(df_W22_pollenGene,file = "/Users/yibingzeng/Desktop/MPG/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen.gff3",
            quote = F, row.names = F, col.names = F, sep = "\t")
#W22 MPGs. This will be the subset of MPGs that are annotated in W22.
#Redefine the methylation status
B73_all$epiallele[B73_all$mCG <= .05 & B73_all$mCHG <= .05 & B73_all$cCG >=30 & B73_all$cCHG >= 30] <- "UM" 
B73_all$epiallele[B73_all$mCG >= .2 & B73_all$mCHG <= .05& B73_all$cCG >=30 & B73_all$cCHG >= 30] <- "gbM" 
B73_all$epiallele[B73_all$mCG >= .4 & B73_all$mCHG >= .4& B73_all$cCG >=30 & B73_all$cCHG >= 30] <- "teM"
#Pollen teM gene
pollen_teM_gene <- B73_all  %>% filter(epiallele == "teM") %>% filter(anther >= 10 ) %>%
  filter( embryo/anther < .1 & endosperm/anther < .1 & root/anther < .1 & shoot/anther < .1 &   base/anther < .1      & middle/anther < .1 & tip/anther < .1 &  ear/anther < .1   )  %>% select(gene)
B73_pollenTeM_gene_W22_link <- merge(pollen_teM_gene,df, by ="gene",all.x=T) %>% filter(!is.na(W22)) %>% select("W22")

df_W22_pollenTeMGene <- merge(B73_pollenTeM_gene_W22_link,W22_gff3, all.x=T)[,-1]
write.table(df_W22_pollenTeMGene,file = "/Users/yibingzeng/Desktop/MPG/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen_teM.gff3",
            quote = F, row.names = F, col.names = F, sep = "\t")
