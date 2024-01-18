setwd()
geneTE_list <- read.table("gene.intersect")
geneID_TEinter <- geneID_TEinter$V4 %>% unique() 
names(geneID_TEinter) <- "gene"
TE_free_gene <- setdiff(all_geneset,geneID_TEinter) 
df_TE <- data.frame(gene = geneID_TEinter,
                    TE = "Y")
all_gene_set <- 

setdiff <- 


df_TE <- data.frame()
