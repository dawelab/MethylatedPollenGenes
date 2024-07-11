setwd("/Users/yibingzeng/Desktop/MPG/single_read")
files <- list.files()[-c(seq(3,33,3),35,38,40)]
name <- gsub("_S..W22.sorted.bam.W22_core_genes.upflank100.meth","_core",files)
name <- gsub("_S..W22.sorted.bam.W22_mMPGs.upflank100.meth","",name)
name <- gsub("s_","s_rep",name)
name <- gsub("J664-","",name)
name <- gsub(".bam_sorted.bam.W22_core_genes.upflank100.meth","_core",name)
name <- gsub(".bam_sorted.bam.W22_mMPGs.upflank100.meth","",name)
name <- gsub(".bam_","",name)
name <- gsub("_1_S1.W22.","_rep1",name);name <- gsub("_2_S2.W22.","_rep2",name);name <- gsub("_3_S3.W22.","_rep3",name)
name <- gsub("MP-1","MP_rep1",name);name <- gsub("MP-2","MP_rep2",name)
name <- gsub("w1-EM","EM-rep1",name);name <- gsub("w2-EM","EM-rep2",name);name <- gsub("w3-EM","EM-rep3",name)
name <- gsub("w1-EN","EN-rep1",name);name <- gsub("w2-EN","EN-rep2",name);name <- gsub("w3-EN","EN-rep3",name)
(name <- gsub("-","_",name))
for (i in 1:length(name)) {
  assign(name[i],
         read.csv(files[i],sep = "\t") %>% select(mCG) %>%
           mutate(tissue=strsplit(name[i],"_")[[1]][1]) %>% 
           mutate(replicate = strsplit(strsplit(name[i],"_")[[1]][2],".",fixed = T)[[1]]) %>% 
           mutate(core=strsplit(strsplit(name[i],"_")[[1]][3],".",fixed = T))
         )
}

df_methy <- get(name[1]) %>% filter(!is.na(mCG)) 
for (i in 2:length(name)) {
  
  df_methy <- rbind(df_methy,get(name[i])%>% filter(!is.na(mCG)) )
}
df_methy$core[is.na(df_methy$core)] <- "non_core"

df_methy$tissue[df_methy$tissue=="EM"] = "embryo"
df_methy$tissue[df_methy$tissue=="EN"] = "endosperm"
df_methy$tissue[df_methy$tissue=="J500s"] = "tassel"
df_methy$tissue[df_methy$tissue=="MP"] = "pollen"

df_methy_core <- df_methy %>% filter(core == "core")
df_methy_MPG <- df_methy %>% filter(core == "non_core")

df_methy_core %>% ggplot() +
  geom_histogram(bins = 10,aes(x=mCG,
    y = ..density..),
                 colour = 1, fill = "black",
    position="identity") +
  scale_x_continuous(breaks=c(0,1)) +
  scale_y_continuous(breaks = c(0,2,4,6),labels = c("0%","20%","40%","60%")) +
  facet_grid(~ tissue) +
  theme_classic() +  theme(text = element_text(size=15)) +
  ylab("percent of reads")

###Replace with real name
#EM embryo EN endosperm J500s tassel MP: pollen
df_methy_MPG %>% ggplot() +
  geom_histogram(bins = 10,aes(x=mCG,
                               y = ..density..),
                 colour = 1, fill = "black",
                 position="identity") +
  scale_x_continuous(breaks=c(0,1)) +
  scale_y_continuous(breaks = c(0,2,4,6),labels = c("0%","20%","40%","60%")) +
  facet_grid(~ tissue) +
  theme_classic() +
  theme(text = element_text(size=15)) +
  ylab("percent of reads")

#Use leaf as the control, test the idea whether are they different than leaf
#Two-Sided Kolmogorov-Smirnov-Test
install.packages("dgof")
library("dgof")
leaf_embryo = ks.test(df_methy_MPG$mCG[df_methy_MPG$tissue=="leaf"],
        df_methy_MPG$mCG[df_methy_MPG$tissue=="embryo"])$p.value

leaf_endosperm = ks.test(df_methy_MPG$mCG[df_methy_MPG$tissue=="leaf"],
        df_methy_MPG$mCG[df_methy_MPG$tissue=="endosperm"])$p.value

leaf_pollen = ks.test(df_methy_MPG$mCG[df_methy_MPG$tissue=="leaf"],
        df_methy_MPG$mCG[df_methy_MPG$tissue=="pollen"])$p.value

leaf_tassel=ks.test(df_methy_MPG$mCG[df_methy_MPG$tissue=="leaf"],
        df_methy_MPG$mCG[df_methy_MPG$tissue=="tassel"])$p.value
data.frame(leaf_embryo,leaf_endosperm,leaf_pollen,leaf_tassel)

