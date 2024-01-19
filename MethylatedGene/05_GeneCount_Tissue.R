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
