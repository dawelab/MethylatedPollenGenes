ml BCFtools/1.18-GCC-12.3.0

for vcf in *.vcf; do
   bgzip -c "$vcf" > "$vcf.gz"
   bcftools index "$vcf.gz"
 done
  ## For the VCF file of B73 and KI11 F1 hybrid, it contains both B73 snps and Ki11 snps. To acquire Ki11 snps for reads filtering, that's how I did it:
  ## 1. I aligned B73 inbred to B73 reference genome and call the varaints.
  ## 2. I remove the varaints of B73 when mapped to B73
  cd /scratch/yz77862/Allim/gene_guide/B73/VCF
  bcftools isec -C   ERR2889293_B73_raw.vcf.gz ERR2889275_B73_raw.vcf.gz -w1 -o ERR2889293-ERR2889275_filtered.vcf

  bcftools isec -C   ERR2889302_B73_raw.vcf.gz ERR2889275_B73_raw.vcf.gz -w1 -o ERR2889302-ERR2889275_filtered.vcf

  

  ## For the VCF file of B73 and KI11 F1 hybrid, it contains both B73 snps and Ki11 snps. To acquire Ki11 snps for reads filtering, that's how I did it:
  ## 1. I aligned Ki11 inbred to Ki11 reference genome and call the varaints.
  ## 2. I remove the varaints of Ki11 when mapped to Ki11
 
  bcftools isec -C   ERR2889293_Ki11_raw.vcf.gz merged_Ki11.vcf -w1 -o ERR2889293-Ki11_filtered.vcf


  bcftools isec -C   ERR2889302_Ki11_raw.vcf.gz ERR2889275_Ki11_raw.vcf.gz -w1 -o ERR2889302-ERR2889275_filtered.vcf
