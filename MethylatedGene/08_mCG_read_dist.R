library("tidyverse")
setwd("/Users/yibingzeng/Desktop/MPG")
files <- list.files("/Users/yibingzeng/Desktop/MPG")[c(2:25,27:34,40:55,57:64)]
name <- gsub(".bam_sorted.bam","",files)
name <- gsub("_up600.meth","",name)
name <- gsub("-","_",name)
name <- gsub("J664_","",name)
name <- gsub("w1_EM","EM_rep1",name)
name <- gsub("w2_EM","EM_rep2",name)
name <- gsub("w3_EM","EM_rep3",name)
name <- gsub("w1_EN","EN_rep1",name)
name <- gsub("w2_EN","EN_rep2",name)
name <- gsub("w3_EN","EN_rep3",name)
name <- gsub("MP_1","MP_rep1",name)
name <- gsub("MP_2","MP_rep2",name)
name <- gsub("1_S1.W22.sorted.bam.","rep1.",name)
name <- gsub("2_S2.W22.sorted.bam.","rep2.",name)
name <- gsub("3_S3.W22.sorted.bam.","rep3.",name)

for (i in 1:length(files)) {
  assign(name[i],
         read.csv(files[i],sep = "\t") %>% select("mCG") %>% 
           mutate(tissue=strsplit(name[i],"_")[[1]][1]) %>%
           mutate(replicate = strsplit(strsplit(name[i],"_")[[1]][2],".",fixed = T)[[1]][1]) %>%
           mutate(gene = strsplit(strsplit(name[i],"_")[[1]][2],".",fixed = T)[[1]][2])
           )
}


df_methy <- get(name[1]) %>% filter(!is.na(mCG)) 
for (i in 2:length(name)) {
  
  df_methy <- rbind(df_methy,get(name[i])%>% filter(!is.na(mCG)) )
}
sample_size <- c(table(df_methy$tissue,df_methy$gene))

df_methy$x <- NULL
df_methy$x[df_methy$tissue=="EM" & df_methy$gene =="AGP"] <- sample(1:34)[1:sample_size[1]]
df_methy$x[df_methy$tissue=="EN" & df_methy$gene =="AGP"] <- sample(1:34)[1:sample_size[2]]
df_methy$x[df_methy$tissue=="J500s" & df_methy$gene =="AGP"] <- sample(1:34)[1:sample_size[3]]
df_methy$x[df_methy$tissue=="leaf" & df_methy$gene =="AGP"] <- sample(1:34)[1:sample_size[4]]
df_methy$x[df_methy$tissue=="MP" & df_methy$gene =="AGP"] <- sample(1:34)[1:sample_size[5]]

df_methy$x[df_methy$tissue=="EM" & df_methy$gene =="exp1"] <- sample(1:34)[1:sample_size[6]]
df_methy$x[df_methy$tissue=="EN" & df_methy$gene =="exp1"] <- sample(1:34)[1:sample_size[7]]
df_methy$x[df_methy$tissue=="J500s" & df_methy$gene =="exp1"] <- sample(1:34)[1:sample_size[8]]
df_methy$x[df_methy$tissue=="leaf" & df_methy$gene =="exp1"] <- sample(1:34)[1:sample_size[9]]
df_methy$x[df_methy$tissue=="MP" & df_methy$gene =="exp1"] <- sample(1:34)[1:sample_size[10]]

df_methy$x[df_methy$tissue=="EM" & df_methy$gene =="PME"] <- sample(1:34)[1:sample_size[11]]
df_methy$x[df_methy$tissue=="EN" & df_methy$gene =="PME"] <- sample(1:34)[1:sample_size[12]]
df_methy$x[df_methy$tissue=="J500s" & df_methy$gene =="PME"] <- sample(1:34)[1:sample_size[13]]
df_methy$x[df_methy$tissue=="leaf" & df_methy$gene =="PME"] <- sample(1:34)[1:sample_size[14]]
df_methy$x[df_methy$tissue=="MP" & df_methy$gene =="PME"] <- sample(1:34)[1:sample_size[15]]

df_methy$x[df_methy$tissue=="EM" & df_methy$gene =="polygal"] <- sample(1:34)[1:sample_size[16]]
df_methy$x[df_methy$tissue=="EN" & df_methy$gene =="polygal"] <- sample(1:34)[1:sample_size[17]]
df_methy$x[df_methy$tissue=="J500s" & df_methy$gene =="polygal"] <- sample(1:34)[1:sample_size[18]]
df_methy$x[df_methy$tissue=="leaf" & df_methy$gene =="polygal"] <- sample(1:34)[1:sample_size[19]]
df_methy$x[df_methy$tissue=="MP" & df_methy$gene =="polygal"] <- sample(1:34)[1:sample_size[20]]


df_methy$tissue[df_methy$tissue=="MP"] <- "pollen"
df_methy$tissue[df_methy$tissue=="EN"] <- "endosperm"
df_methy$tissue[df_methy$tissue=="EM"] <- "embryo"
df_methy$tissue[df_methy$tissue=="leaf"] <- "leaf"
df_methy$tissue[df_methy$tissue=="J500s"] <- "tassel"

df_methy$gene[df_methy$gene=="AGP"] <- "AGP-like"
df_methy$gene[df_methy$gene=="exp1"] <- "expansin"
df_methy$gene[df_methy$gene=="polygal"] <- "polygalacturonase"

  
df_methy$tissue <- factor(df_methy$tissue,levels=c("pollen","endosperm","embryo","leaf","tassel"))
df_methy$gene <- factor(df_methy$gene,levels=c("AGP-like","expansin","polygalacturonase","PME"))


df_methy  %>% ggplot(aes(x= x, y=mCG,color=replicate)) +
  geom_point(size=0.5)  +
  facet_grid(gene~tissue,scales = "free_x") +
  theme_bw() +xlab("") +
  theme(legend.position = "None") +
  scale_y_continuous(breaks = c(0,0.5,1.0)) +
  theme(axis.text.x=element_blank(),
        axis.ticks.x = element_blank())
  
(tab1 <- table(df_methy$tissue,df_methy$gene))
(tab2 <- table(df_methy$tissue[df_methy$mCG<=0.2],df_methy$gene[df_methy$mCG<=0.2]))
tab2/tab1
#Test the p=1/3 under binomial distribution

rowSums(tab1)
rowSums(tab2)

prop.test(21,63,p=1/3,alternative = "less") #MP #0.5
prop.test(37,78,p=1/3,alternative = "less") #EN # 0.9942
prop.test(1,76,p=1/3,alternative = "less") #EM # 3.327e-09
prop.test(5,53,p=1/3,alternative = "less") #leaf # 0.0001962
prop.test(2,36,p=1/3,alternative = "less") #tassel  0.0003915
