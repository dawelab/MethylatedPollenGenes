ml BCFtools/1.18-GCC-12.3.0

for vcf in *.vcf; do
   bgzip -c "$vcf" > "$vcf.gz"
   bcftools index "$vcf.gz"
 done
  ## For the VCF file of B73 and KI11 F1 hybrid, it contains both B73 snps and Ki11 snps. To acquire Ki11 snps for reads filtering, that's how I did it:
  ## 1. I aligned B73 inbred to B73 reference genome and call the varaints.
  ## 2. I remove the varaints of B73 when mapped to B73
  bcftools isec -C   ERR2889294_B73_raw.vcf.gz ERR2889272_B73_raw.vcf.gz -w1 -o ERR2889294-ERR2889272_filtered.vcf

  ##In F1 bam file, filter any reads specific to ERR2889294-ERR2889272_filtered.vcf

  bcftools query -f '%CHROM\t%POS\t%REF\n'  ERR2889294-ERR2889272_filtered.vcf  > ERR2889294-ERR2889272_filtered_sites.txt 


ml bam-readcount
cd /scratch/yz77862/Allim/gene_guide/B73/output_default
ref=/scratch/yz77862/Allim/reference/B73/Zm-B73-REFERENCE-NAM-5.0.fa
bam-readcount -f ${ref} -l ERR2889294-ERR2889272_filtered_sites.txt ERR2889294Aligned.sortedByCoord.out.bam > ERR2889294-ERR2889272_filtered_sites_readcounts.txt
