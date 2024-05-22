library(tidyverse)
library(ggExtra) 
####Get the dataset from github
B73_all <- read.csv("https://raw.githubusercontent.com/dawelab/Natural-methylation-epialleles-correlate-with-gene-expression-in-maize/main/Data/B73.all.csv")  %>% filter(pan != "pan_gene_50793")
table(B73_all$epiallele)
#Zm00001eb007510 is duplicated, remove one
B73_all %>% filter( class == "Core Gene") %>% dim()
B73_all %>% filter( class == "Core Gene" &  (cCG < 30 | cCHG < 30)) %>% dim()
B73_all %>% filter( class == "Core Gene" & pan != "pan_gene_50793") %>% dim()
B73_all$epiallele[B73_all$mCG <= .05 & B73_all$mCHG <= .05 & B73_all$cCG >=30 & B73_all$cCHG >= 30] <- "UM" 
B73_all$epiallele[B73_all$mCG >= .2 & B73_all$mCHG <= .05& B73_all$cCG >=30 & B73_all$cCHG >= 30] <- "gbM" 
B73_all$epiallele[B73_all$mCG >= .4 & B73_all$mCHG >= .4& B73_all$cCG >=30 & B73_all$cCHG >= 30] <- "teM"
table(B73_all$epiallele)
B73_all  %>% filter(epiallele == "teM") %>% filter(anther >= 10 ) %>%
  filter( embryo/anther < .1 & endosperm/anther < .1 & root/anther < .1 & shoot/anther < .1 &   base/anther < .1      & middle/anther < .1 & tip/anther < .1 &  ear/anther < .1   ) 

B73_cov <- B73_all %>% filter( class == "Core Gene" &   cCG >=30 & cCHG >= 30)

B73_cov$epiallele[B73_cov$mCG <= .05 & B73_cov$mCHG <= .05] <- "UM" 
B73_cov$epiallele[B73_cov$mCG >= .2 & B73_cov$mCHG <= .05] <- "gbM" 
B73_cov$epiallele[B73_cov$mCG >= .4 & B73_cov$mCHG >= .4] <- "teM" 
table(B73_cov$epiallele)

all_geneset <- B73_all %>% select(gene)
###Select the geneIDs that are not totally silent  & select core genes & redefine the cCG and cCHG
B73_core_express <- B73_all %>% filter(rowSums(B73_all[,14:23] < 10) != 10 &
                                class == "Core Gene" & 
                                  cCG >=30 & cCHG >= 30) 
B73_core_express <- B73_core_express[-385,]
###The genes' CDS regions that are intersect with TEs
geneID_TEinter <- read.table("/Users/x/Desktop/Data/pollen/Zm-B73-REFERENCE-NAM-5.0.CDS_inter_TE.bed") %>% select(V4) %>% unique()
names(geneID_TEinter) <- "gene"
TE_free_gene <- setdiff(all_geneset,geneID_TEinter) 
df_TE <- data.frame(gene = geneID_TEinter,
                    TE = "Y")
###
B73_all_TE <- merge(B73_all,df_TE ,all.x = T)
B73_all_TE$TE[is.na(B73_all_TE$TE)] <- "N" 
B73_all_TE2 <- B73_all_TE %>% filter(pan != "pan_gene_50793" & class == "Core Gene" &  cCG >=30 & cCHG >= 30 & TE == "N") 

B73_all_TE2$epiallele[B73_all_TE2$mCG <= .05 & B73_all_TE2$mCHG <= .05] <- "UM" 
B73_all_TE2$epiallele[B73_all_TE2$mCG >= .2 & B73_all_TE2$mCHG <= .05] <- "gbM" 
B73_all_TE2$epiallele[B73_all_TE2$mCG >= .4 & B73_all_TE2$mCHG >= .4] <- "teM" 
table(B73_all_TE2$epiallele)

B73_all_TE %>% filter(pan != "pan_gene_50793" & class == "Core Gene" &  (cCG <30 | cCHG < 30) & TE == "N") %>% dim 

B73_all %>% filter(pan != "pan_gene_50793", class == "Core Gene" &  (cCG < 30 | cCHG < 30)) %>% dim()





##### combine the gene set with earlier filters and TE free
df_filter <- merge(TE_free_gene,B73_core_express,all = F)
####Extract the strongDEG from JIG Nov 29th 
DEG <- read.csv("/Users/x/Desktop/Data/pollen/DEGAnalysisNov29.csv") 
strongDEG <- DEG %>% filter(class == "Strong DE") %>% select(X)
names(strongDEG) <- "gene"
df_strongDEG <- data.frame(strongDEG,strongDEG = "Y")
#####The number of genes that are core genes intersecting with TEs
#Zm00001eb007510
##1. All core genes (58 genes among them)
##2.All 58 genes
B73_core <- B73_all %>% filter(class == "Core Gene" ) 
B73_core <- B73_core[-546,]
dim(B73_core)
##The core gene number is 28.291
df_geneID_TEinter <- data.frame(geneID_TEinter,TE="Y") 
df_core <- data.frame(gene=B73_core[,"gene"])
df_core_TE <- merge(
  df_core,df_geneID_TEinter, all.x = T
)
df_core_TE$TE[is.na(df_core_TE$TE)] <- "N"
table(df_core_TE$TE)
df_core_TE_strongDEG <- merge(df_core_TE,df_strongDEG,by="gene",all.x = T)
df_core_TE_strongDEG$strongDEG[is.na(df_core_TE_strongDEG$strongDEG)] <- "N"
##3122 out of 28291 overlaped TEs
df_strongDEG_TE <- merge(df_strongDEG, df_geneID_TEinter,all.x = T,
                         by = "gene")
df_strongDEG_TE$TE[is.na(df_strongDEG_TE$TE)] <- "N"
table(df_strongDEG_TE$TE)

df_strongDEG_TE %>% filter(TE=="Y")
#3 out of 58 (55 cores) are overlapped with TEs 
##Combine to the final tidy data frame


df3 <- merge(df_strongDEG_TE,B73_all,by = "gene",  all.x = T)
df3 %>% filter(class == "Core Gene") %>% dim()
df3 %>% filter(class == "Core Gene" & (cCG >=30 & cCHG >= 30)) %>% dim()
df3 %>% filter(class == "Core Gene" & (cCG >=30 & cCHG >= 30) & TE ==  "N") %>% dim()
df3 %>% filter(class == "Core Gene" & (cCG >=30 & cCHG >= 30) & TE ==  "N" & rowSums(df3[,15:24] < 10) != 10) %>% dim()


table(df3$class,df3$strongDEG)
df <- merge(df_filter,df_strongDEG,all.x =T)
df$strongDEG[is.na(df$strongDEG)] <- "N"
table(df$epiallele)
df$epiallele[df$mCG>=0.4 & df$mCHG >= 0.4] <- "teM"
df$epiallele[df$mCG <=0.05 & df$mCHG <= 0.05] <- "UM"
df$epiallele[df$mCG >=0.2 & df$mCHG <= 0.05] <- "gbM"

table(df$epiallele)
df$strongDEG = factor(df$strongDEG,levels = c("N","Y"))
######The nonstrongDEGs should grey and strongDEGs should be red
##Make the axis text all black
weak <- df[df$strongDEG=="N",]
strong <- df[df$strongDEG=="Y",]
f1 <- ggplot(weak,aes(x = mCG, y = mCHG, color = strongDEG)) + 
  geom_point(size =1) +
  geom_point(data = weak,aes(x=mCG,y=mCHG,color=strongDEG),size = 1) +
  theme_bw()   +
  xlab("CG methylation") +
  ylab("CHG methylation")+
  scale_color_manual(values=c("grey","red"),
                     aesthetics = c( "fill","colour")) +
  theme(plot.title = element_text(hjust = 0.5),
        text = element_text(size = 10),
        legend.position = "none",
        legend.key = element_rect(fill = "transparent"),
        panel.grid.major = element_line(colour = NA),
        panel.grid.minor = element_blank()
        )+ 
  scale_y_continuous(breaks = c(0,0.2,0.4,0.6,0.8,1.0),limits = c(0,1))  +
  scale_x_continuous(breaks = seq(0,1,0.2),limits = c(0,1))  


(f1 =  ggMarginal(f1, type = "histogram", groupColour = TRUE, 
                  groupFill = TRUE,bins=41)) 
########Make the highest expressed tissue type

df_express <- as.matrix(df[,14:23])
highest_tissue <- c()
for (i in 1:dim(df_express)[1]) {
  highest_tissue <- c(highest_tissue,names(which.max(df_express[i,])))
}
df$high <- highest_tissue
table(df$high)
######Estimate the functional teM in the gene set
table(df$epiallele,df$strongDEG)

##Check if the 5 UM and gbM genes are teM in NAM founders
target_gene <- weak %>% filter(epiallele  %in% c("UM","gbM") & strongDEG == "Y")%>% select(c("pan","gene","copy","epiallele"))

####
epi_matrix <- read_rds("/Users/x/Downloads/epi_matrix_final.rds")
epi_matrix[epi_matrix$pan=="pan_gene_3088",]

NAM = c("B73","B97","CML103","CML228","CML247","CML277","CML322","CML333","CML52",
        "CML69","HP301","Il14H","Ki11","Ki3","Ky21","M162W","M37W","Mo18W","Ms71",
        "NC350","NC358","Oh43","Oh7B","P39","Tx303","Tzi8")
path="https://raw.githubusercontent.com/dawelab/Natural-methylation-epialleles-correlate-with-gene-expression-in-maize/main/Data/"
for (i in 1:length(NAM)) {
  assign(
    paste0(NAM[i],"_all"),
    read.csv(paste0(path,NAM[i],".all.csv"))
  )
} 

df_all <- data.frame(merge(
  target_gene,
  get(paste0(NAM[1],"_all")),
  by = "pan", all.x = T
) %>% select(c("pan","epiallele","mCG","cCG","mCHG","cCHG")),
NAM = NAM[i]) 

for (i in 2:26) {
  data <- data.frame(merge(
    target_gene,
    get(paste0(NAM[i],"_all")),
    by = "pan", all.x = T
  ) %>% select(c("pan","epiallele","mCG","cCG","mCHG","cCHG")),
  NAM = NAM[i])
  df_all <- rbind(df_all,
                  data)
}
table(df_all$pan,df_all$epiallele)

df_redefine <- df_all
df_redefine$epiallele[df_redefine$mCG<=0.05 & df_redefine$mCHG <= 0.05 & df_redefine$cCG>=30 & df_redefine$cCHG>=30] <- "UM"
df_redefine$epiallele[df_redefine$mCG>=0.2 & df_redefine$mCHG <= 0.05 & df_redefine$cCG>=30 & df_redefine$cCHG>=30] <- "gbM"
cbind(table(df_redefine$pan,df_redefine$epiallele),c(1,1,2,1,2))

##The line plot with TE-free core gene just 10 tissues
TPM_cutoff <- 1:1000
tissue <- names(table(df$high))
express_count <- data.frame(TPM=numeric(),
                            tissue = character(),
                            counts = numeric())

for (i in 1:10) {
  for (j in 1:length(TPM_cutoff)) {
    counts <- df %>% filter(epiallele=="teM") %>% summarise(sum(get(tissue[i]) > TPM_cutoff[j])) %>% unlist(use.names = F)
    temp <- data.frame(TPM=TPM_cutoff[j],
                       tissue = tissue[i],
                       counts = counts)
    express_count <- rbind(express_count,temp)
  }
}
express_count$tissue <- factor(express_count$tissue,
                               levels = tissue[c(1,9,5,4,3,7,8,2,6,10)])
                              # levels = tissue[c(10,6,2,8,7,3,4,5,9,1)])

express_count %>% filter(TPM <=200) %>%  ggplot(aes(x=TPM,y=counts,color = tissue)) +
  geom_line() +
  theme_classic() +
  theme(text = element_text(size=16,color = "black")) +
  scale_x_continuous(breaks = c(0,100,200))

##The number of the genes that 
express_count %>% filter(TPM==100) %>% 
  ggplot(aes(y=tissue,x=counts)) +
  geom_histogram(stat="identity") + theme_classic()  +
  theme(text = element_text(size = 16))  + xlab("") + ylab("")# +
   #coor_flip()
