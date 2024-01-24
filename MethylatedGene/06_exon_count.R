exon_count <- read.table("/Users/x/Desktop/Zm-B73-REFERENCE-NAM-5.0.1.canon.exon.gff3",)
df_exon_count <- as.data.frame(table(exon_count$V9))
names(df_exon_count) <- c("gene","exon_count")
