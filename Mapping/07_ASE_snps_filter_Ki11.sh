list=/scratch/yz77862/Allim/B73v5_Ki11/list

while read INPUT; do

    OUT=/scratch/yz77862/Allim/gene_guide/shell/${INPUT}_Ki11_VCF.sh

    echo '#!/bin/bash'  > "${OUT}"
    echo "#SBATCH --job-name=${INPUT}_mapping"   >> "${OUT}"
    echo "#SBATCH --partition=batch"   >> "${OUT}"
    echo "#SBATCH --nodes=1"   >> "${OUT}"
    echo "#SBATCH --ntasks=1"   >> "${OUT}"
    echo "#SBATCH --cpus-per-task=18"   >> "${OUT}"
    echo "#SBATCH --mem=200G"   >> "${OUT}"
    echo "#SBATCH --time=02:00:00"   >> "${OUT}"
    echo "#SBATCH --output=${INPUT}_B73_VCF.out"   >> "${OUT}"
    echo "#SBATCH --error=${INPUT}_B73_VCF_bam.err"   >> "${OUT}"
    echo ""  >> "${OUT}"

    echo "ml BCFtools/1.6-foss-2022a" >> "${OUT}"
    echo "ml GATK/4.2.0.0-GCCcore-10.2.0" >> "${OUT}"  # Use 'ml' not 'module spider' for loading
    echo "BAM=/scratch/yz77862/Allim/gene_guide/Kill/round2/${INPUT}_round-2Aligned.sortedByCoord.out.bam"  >> "${OUT}"
    echo "ref=/scratch/yz77862/Allim/reference/Ki11/Zm-Ki11-REFERENCE-NAM-1.0.fa"  >> "${OUT}"
    echo "cd /scratch/yz77862/Allim/gene_guide/Kill/VCF" >> "${OUT}"

    echo "bcftools mpileup -Ou -f \$ref \$BAM | bcftools call -mv -Oz -o ${INPUT}_B73_raw.vcf.gz"  >> "${OUT}"
    echo "gatk IndexFeatureFile -I ${INPUT}_B73_raw.vcf.gz" >> "${OUT}"

    echo "gatk VariantFiltration \\" >> "${OUT}"
    echo " -R \$ref \\" >> "${OUT}" 
    echo " -V ${INPUT}_Ki11_raw.vcf.gz \\" >> "${OUT}"
    echo " --filter-expression \"QD < 2.0\" --filter-name \"QD2\" \\" >> "${OUT}" 
    echo " --filter-expression \"QUAL < 60.0\" --filter-name \"QUAL60\" \\" >> "${OUT}"
    echo " --filter-expression \"SOR > 3.0\" --filter-name \"SOR3\" \\" >> "${OUT}"
    echo " --filter-expression \"FS > 60.0\" --filter-name \"FS60\" \\" >> "${OUT}"
    echo " --filter-expression \"MQ < 40.0\" --filter-name \"MQ40\" \\" >> "${OUT}"
    echo " --filter-expression \"MQRankSum < -12.5\" --filter-name \"MQRS\" \\" >> "${OUT}"
    echo " --filter-expression \"ReadPosRankSum < -8.0\" --filter-name \"RPRS\" \\" >> "${OUT}"
    echo " -O ${INPUT}_filtered_snps_Ki11.vcf" >> "${OUT}"

done < <(cut -f1,2 "${list}" | grep -v 'skip' | sort -u)
