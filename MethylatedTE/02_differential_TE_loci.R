library(DESeq2)
library(tidyverse)
df <- ##Load the read count from feature count 
DESeqTE <- function(df){
  location <- paste0(df[,2],"_",
                     df[,3],"_",
                     df[,4])
  
  JIG <- df[,7:33]
  
  rownames(JIG) <- paste0("p_",1:length(location))
  
  colData <- data.frame(row.names = colnames(JIG),meta)
  
  dds <- DESeqDataSetFromMatrix(JIG, DataFrame(meta), design= ~ meta )
  
  dds <- DESeq(dds)
  
  resultsNames(dds)
  
  res <- results(dds)
  
  summary(res)
  
  num <- as.numeric(table(res$padj<0.05)[2])
  res <- res[order(res$padj),]
  
  diff_gene_deseq2 <-subset(res,padj < 0.05 & (log2FoldChange > 1 | log2FoldChange < -1))
  
  diff_gene_deseq2 <- row.names(diff_gene_deseq2)
  
  resdata <-  merge(as.data.frame(res),
                    as.data.frame(counts(dds,normalize=TRUE)),
                    by="row.names",
                    sort=FALSE
  )
  
  det_index <- as.numeric(gsub("p_","",resdata$Row.names[1:num]))
  return(df[det_index,])
}
  
Gypsy_DET <- DESeqTE(Gypsy.counts)
CACTA_DET <- DESeqTE(CACTA.counts)
Copia_DET <- DESeqTE(Copia.counts)
Harbinger_DET <- DESeqTE(Harbinger.counts)
hAT_DET <- DESeqTE(hAT.counts)
helitron_DET <- DESeqTE(helitron.counts)
LINE_DET <- DESeqTE(LINE.counts)
Mariner_DET <- DESeqTE(Mariner.counts)
Mutator_DET <- DESeqTE(Mutator.counts)
gene_DET <- DESeqTE(gene)

Gypsy_DET$Geneid <- "Gypsy"
CACTA_DET$Geneid <- "CACTA"
Copia_DET$Geneid <- "Copia"
Harbinger_DET$Geneid <- "Harbinger"
hAT_DET$Geneid <- "hAT"
helitron_DET$Geneid <- "helitron"
Mariner_DET$Geneid <- "Mariner"
Mutator_DET$Geneid <- "Mutator"

df_DEQ  <- rbind(Gypsy_DET,CACTA_DET,Copia_DET,Harbinger_DET,hAT_DET,
      helitron_DET,Mariner_DET,Mutator_DET,gene_DET) 

write.csv(df_DEQ,file = "/Users/x/Desktop/DE_superfamilies_gene.csv")
