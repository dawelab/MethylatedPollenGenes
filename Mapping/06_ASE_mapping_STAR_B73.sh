list=/scratch/yz77862/Allim/B73v5_Ki11/list
while read INPUT; do

OUT=/scratch/yz77862/Allim/gene_guide/shell/${INPUT}_B73.sh
    echo '#!/bin/bash'  >> ${OUT} 
    echo "#SBATCH --job-name=${INPUT}_mapping"   >> ${OUT}            
    echo "#SBATCH --partition=batch"   >> ${OUT} 
    echo "#SBATCH --nodes=1"   >> ${OUT}                  
    echo "#SBATCH --ntasks=1"   >> ${OUT}              
    echo "#SBATCH --cpus-per-task=18"   >> ${OUT}          
    echo "#SBATCH --mem=200G"   >> ${OUT}                  
    echo "#SBATCH --time=018:00:00"   >> ${OUT}             
    echo "#SBATCH --output=${INPUT}_B73_bam.out"   >> ${OUT}         
    echo "#SBATCH --error=${INPUT}_B73_bam.err"   >> ${OUT}         
    echo " "  >> ${OUT}  
    echo "ml STAR/2.7.10b-GCC-11.3.0" >> ${OUT}  
    echo "cd /scratch/yz77862/Allim/gene_guide/B73/round1" >> ${OUT}
    echo " "  >> ${OUT}
    echo "thread=18"  >> ${OUT}  
    echo "index=/scratch/yz77862/Allim/reference/B73/STAR"  >> ${OUT}  
    echo "read1=/scratch/yz77862/Allim/B73v5_Ki11/trim/${INPUT}_1_val_1.fq.gz"  >> ${OUT}  
    echo "read2=/scratch/yz77862/Allim/B73v5_Ki11/trim/${INPUT}_2_val_2.fq.gz"  >> ${OUT}  
    echo " "  >> ${OUT}  
    echo "STAR \\"  >> "${OUT}"
    echo "--runMode alignReads \\"  >> "${OUT}"
    echo "--genomeDir \${index} \\"  >> "${OUT}"
    echo "--twopassMode Basic \\"  >> "${OUT}"
    echo "--runThreadN \${thread} \\"  >> "${OUT}"
    echo "--readFilesCommand zcat \\"  >> "${OUT}"
    echo "--readFilesIn \${read1} \${read2} \\"  >> "${OUT}"
    echo "--outSAMtype None \\"  >> "${OUT}"   # If you want no output SAM, otherwise set to BAM Unsorted
    echo "--outFileNamePrefix ${INPUT} \\"  >> "${OUT}"
    echo "--outFilterScoreMin 50 \\" >> "${OUT}"
    echo "--outFilterMultimapNmax 10000" >> "${OUT}"
    echo " "  >> ${OUT}
    echo "cd /scratch/yz77862/Allim/gene_guide/B73/round2"  >> ${OUT}
    
    echo " " >> ${OUT}
 # 2nd STAR run
    echo "SJ=/scratch/yz77862/Allim/gene_guide/B73/round1/${INPUT}_STARpass1/SJ.out.tab"  >> "${OUT}"
    echo "STAR \\"  >> "${OUT}"
    echo "--genomeDir \${index} \\"  >> "${OUT}"
    echo "--runThreadN \${thread} \\"  >> "${OUT}"
    echo "--readFilesCommand zcat \\"  >> "${OUT}"
    echo "--sjdbFileChrStartEnd \${SJ} \\"  >> "${OUT}"
    echo "--runMode alignReads \\"  >> "${OUT}"
    echo "--readFilesIn \${read1} \${read2} \\"  >> "${OUT}"
    echo "--outSAMattributes All \\"  >> "${OUT}"
    echo "--outSAMmapqUnique 10 \\"  >> "${OUT}"
    echo "--outFilterMismatchNmax 3 \\"  >> "${OUT}"
    echo "--outFileNamePrefix ${INPUT}_round-2 \\"  >> "${OUT}"
    echo "--outBAMsortingThreadN 4 \\"  >> "${OUT}"
    echo "--outSAMtype BAM SortedByCoordinate \\"  >> "${OUT}"
    echo "--outFilterScoreMin 50 \\" >> "${OUT}"
    echo "--outFilterMultimapNmax 10000 \\" >> "${OUT}"
    echo "--outWigType bedGraph read1_5p"  >> "${OUT}"
done < <(cut -f1,2 ${list} | grep -v 'skip' | sort -u)
