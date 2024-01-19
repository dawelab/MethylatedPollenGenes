setwd("/Users/x/Desktop/Data/pollen/single_cell_read_count")
library(matrixStats)
library(tidyverse)
files <- list.files()[-10]
name <- gsub(".bed","",files)
name[10] <- "gene"
for (i in 1:length(files)) {
  assign(name[i], read.csv(files[i], sep = "\t", header = T))
}

for (i in 1:length(files)) {
assign(paste0(name[i],".sum"),
       colSums(get(name[i])[,7:33]))
}

df_sum <- cbind(CACTA.counts.sum,Copia.counts.sum,Gypsy.counts.sum,Harbinger.counts.sum,
      hAT.counts.sum,helitron.counts.sum,LINE.counts.sum,Mariner.counts.sum,
      Mutator.counts.sum,gene.sum)
colnames(df_sum) <- gsub(".sum","",colnames(df_sum))
ratio_TE_gene <- df_sum[,1:9]/df_sum[,10]
meta <- factor(c("control","dm","dm","control","control",
                 "control","control","dm","control","dm",
                 "control","control","control","control","dm",
                 "dm","control","control","control","control",
                 "control","control","control","control","control",
                 "control","dm"))
tidy_TE_gene <- data.frame(ratio = c(ratio_TE_gene),
                           sample = rep(rownames(ratio_TE_gene),9),
                           superfamily = rep(colnames(ratio_TE_gene),each = 27),
                             group = rep(meta,9))
tidy_TE_gene$group <- factor(tidy_TE_gene$group,levels = c("control","dm"))
tidy_TE_gene$superfamily <- gsub(".counts","",tidy_TE_gene$superfamily)
tidy_TE_gene$sample <- gsub("JG_Pollen_S5_L004_dT.","",tidy_TE_gene$sample)


#tidy_TE_gene <- tidy_TE_gene[tidy_TE_gene$superfamily!="Gypsy",]
ggplot(tidy_TE_gene, aes( superfamily, sample, fill= log10(ratio))) + geom_tile() +
  theme(axis.text.x = element_text(angle = 90)) +
  theme(axis.text.y = element_text(color = c("black","red","red","black","black",
                                              "black","black","red","black","red",
                                              "black","black","black","black","red",
                                              "red","black","black","black","black",
                                              "black","black","black","black","black",
                                              "black","red" )))
