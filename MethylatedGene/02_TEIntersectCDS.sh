cd ${working_dir}
$output_dir
ml BEDTools
#Make the gene bed file for CDS
#The gene annotation file is downloaded from maizegdb
awk '$3=="CDS"' Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gff3 | cut -f1 -d ';' | sed 's/ID=//g' | sed 's/_P...//g' | awk '{print $1,$4,$5,$9}' OFS="\t" | sort -b -k1,1 -k2,2n -k3,3n > Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gene.bed
gene_cds=${working_dir}/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gene.bed
#Make the TE bed file
awk '{print $1,$4,$5,$3}' OFS="\t" Zm-B73-REFERENCE-NAM-5.0.TE.gff3 | grep -v "#" > Zm-B73-REFERENCE-NAM-5.0.TE.bed
TE=${working_dir}
bedtools intersect -wa -wb -a ${gene_cds} -b ${TE} | cut -f | uniq > gene_interectTE.bed
