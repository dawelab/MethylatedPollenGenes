list=/scratch/yz77862/Allim/B73v5_Ki11/list

while read INPUT; do

    OUT=/scratch/yz77862/Allim/gene_guide/shell/${INPUT}_com.sh

    echo '#!/bin/bash'  >> "${OUT}"
    echo "#SBATCH --job-name=${INPUT}_mapping"   >> "${OUT}"
    echo "#SBATCH --partition=batch"   >> "${OUT}"
    echo "#SBATCH --nodes=1"   >> "${OUT}"
    echo "#SBATCH --ntasks=1"   >> "${OUT}"
    echo "#SBATCH --cpus-per-task=18"   >> "${OUT}"
    echo "#SBATCH --mem=200G"   >> "${OUT}"
    echo "#SBATCH --time=018:00:00"   >> "${OUT}"
    echo "#SBATCH --output=${INPUT}_com_bam.out"   >> "${OUT}"
    echo "#SBATCH --error=${INPUT}_com_bam.err"   >> "${OUT}"
    echo ""  >> "${OUT}"

    echo "ml STAR/2.7.10b-GCC-11.3.0" >> "${OUT}"
    echo "cd /scratch/yz77862/Allim/gene_guide/output_default" >> "${OUT}"
    echo ""  >> "${OUT}"

    echo "index=/scratch/yz77862/Allim/reference/B73v5_Ki11/STAR"  >> "${OUT}"
    echo "read1=/scratch/yz77862/Allim/B73v5_Ki11/trim/${INPUT}_1_val_1.fq.gz"  >> "${OUT}"
    echo "read2=/scratch/yz77862/Allim/B73v5_Ki11/trim/${INPUT}_2_val_2.fq.gz"  >> "${OUT}"
    echo " "  >> "${OUT}"
    
    echo "STAR --genomeDir \${index} \\" >> "${OUT}"
    echo "--runThreadN 6 \\" >> "${OUT}"
    echo "--readFilesIn \${read1} \${read2} \\" >> "${OUT}"
    echo "--readFilesCommand zcat \\" >> "${OUT}"
    echo "--outSAMtype BAM SortedByCoordinate \\" >> "${OUT}"
    echo "--outSAMunmapped Within \\" >> "${OUT}"
    echo "--outSAMattributes Standard \\" >> "${OUT}"
    echo "--outFileNamePrefix ${INPUT}" >> "${OUT}"

done < <(cut -f1,2 "${list}" | grep -v 'skip' | sort -u)

