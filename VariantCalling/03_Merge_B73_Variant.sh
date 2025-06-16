ml BCFtools/1.18-GCC-12.3.0

for vcf in *.vcf; do
   bgzip -c "$vcf" > "$vcf.gz"
   bcftools index "$vcf.gz"
 done

 ##This is a list of variants when using B73 samples mapped to B73 reference genome, should be considered as noise
bcftools merge ERR28892{72..81}_B73_raw.vcf.gz -Oz -o merged_B73.vcf.gz

##This is a list of variants when using Ki11 samples mapped to Ki11 reference genome, should be considered as noise
