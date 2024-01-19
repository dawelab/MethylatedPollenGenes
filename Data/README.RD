This repository provides a data file containing genes with panID, excluding gene annotations in the scaffold (scaf). Please note the following details:

Excluded Genes: Two genes, namely pan_gene_50793 and pan_gene_29491, have been excluded. The exclusion criteria include instances where the same gene has two panIDs or belongs to different pan classes.

Epiallele Status: Our definition of epialleles differs from Zeng (2023). Genes with 30 informative CG and CHG sites are excluded from ambiguous gene status and are categorized as UM (Unmethylated), gbM (CG Methylation), or teM (CHG Methylation) accordingly.

Index Length (CDS): The column named "index length(CDS)" indicates the cumulative length of coding sequences (CDS) for each gene.

TE (CDS) Indicator: The column named "index TE(CDS)" specifies whether the CDS of a gene overlaps with Transposable Elements (TE) or not.

If you are using R to process the data, you can load the it by
```
df <- read.csv("https://raw.githubusercontent.com/dawelab/MethylatedPollenGenes/main/Data/df_RedefineEpailele.csv?token=GHSAT0AAAAAACMFLIBV6626YZVHUFEQ3QOGZNKT7RQ")

```
