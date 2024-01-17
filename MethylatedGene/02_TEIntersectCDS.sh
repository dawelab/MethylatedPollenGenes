cd ${working_dir}
ml BEDTools
#Make the gene bed file for CDS
gene_cds=
#Make the TE bed file
TE=
bedtools intersect -wa -wb -a ${gene_cds} -b ${TE} | cut -f | uniq > gene_interectTE.bed
