setwd()
geneTE_list <- read.table("geneID_TEinter.txt")
geneID_TEinter <- geneTE_list %>% as.data.frame()
names(geneID_TEinter) <- "gene"
TE_free_gene <- setdiff(all_geneset,geneID_TEinter) 
df_TE <- data.frame(gene = geneID_TEinter,
                    TE = "Y")
B73_all <- read.csv("https://raw.githubusercontent.com/dawelab/Natural-methylation-epialleles-correlate-with-gene-expression-in-maize/main/Data/B73.all.csv")  %>% filter(pan != "pan_gene_50793")
all_gene_set <- data.frame(gene=B73_all$gene)
df_TE <- merge(all_gene_set,df_TE,by="gene",all.x=T)
df_TE$TE[is.na(df_TE$TE)] <- "N"

DEG <- read.csv("/Users/x/Desktop/Data/pollen/DEGAnalysisNov29.csv") 
strongDEG <- DEG[DEG$class == "Strong DE",1] 
names(strongDEG) <- "gene"
df_strongDEG <- data.frame(gene=strongDEG,strongDEG = "Y")
df_DEG <- merge(all_gene_set,df_strongDEG,by="gene",all.x=T)
df_DEG$strongDEG[is.na(df_DEG$strongDEG)] <- "N"
