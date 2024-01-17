mkdir -p /scratch/yz77862/pollen_mRNA/gene_guide
mkdir -p /scratch/yz77862/pollen_mRNA/gene_guide/shell
mkdir -p /scratch/yz77862/pollen_mRNA/gene_guide/round1
mkdir -p /scratch/yz77862/pollen_mRNA/gene_guide/round2


list=/scratch/yz77862/pollen_mRNA/list
while read INPUT; do

OUT=/scratch/yz77862/pollen_mRNA/gene_guide/shell/${INPUT}.sh
    echo '#!/bin/bash'  >> ${OUT} 
    echo "#SBATCH --job-name=${INPUT}_mapping"   >> ${OUT}            
    echo "#SBATCH --partition=batch"   >> ${OUT} 
    echo "#SBATCH --nodes=1"   >> ${OUT}                  
    echo "#SBATCH --ntasks=1"   >> ${OUT}              
    echo "#SBATCH --cpus-per-task=18"   >> ${OUT}          
    echo "#SBATCH --mem=80G"   >> ${OUT}                  
    echo "#SBATCH --time=010:00:00"   >> ${OUT}             
    echo "#SBATCH --output=${INPUT}_fq_bam.out"   >> ${OUT}         
    echo "#SBATCH --error=${INPUT}_fq_bam.err"   >> ${OUT}         
    echo " "  >> ${OUT}  
    echo "ml STAR/2.7.10b-GCC-11.3.0" >> ${OUT}  
    echo "cd /scratch/yz77862/pollen_mRNA/gene_guide/round1" >> ${OUT}
    echo " "  >> ${OUT}
    echo "thread=18"  >> ${OUT}  
    echo "index=/scratch/yz77862/B73v5_genome/STAR"  >> ${OUT}  
    echo "read=/scratch/yz77862/pollen_mRNA/${INPUT}.fastq"  >> ${OUT}  
    echo " "  >> ${OUT}  
    echo "STAR \\"  >> ${OUT}    
    echo "--runMode alignReads \\"  >> ${OUT}  
    echo "--genomeDir \${index}  \\"  >> ${OUT}  
    echo "--twopassMode Basic  \\"  >> ${OUT}  
    echo "​--runThreadN \$thread \\"  >> ${OUT}  
    echo "--readFilesIn \${read} \\"  >> ${OUT}  
    echo "--outSAMtype None \\"  >> ${OUT}  
    echo "--outFileNamePrefix ${INPUT} \\"  >> ${OUT}  
    echo "--outFilterScoreMin 50 \\" >> ${OUT}  
    echo "--outFilterMultimapNmax 10000" >> ${OUT}  
    echo " "  >> ${OUT}
    echo "cd /scratch/yz77862/pollen_mRNA/gene_guide/round2"  >> ${OUT}
    echo " " >> ${OUT}
    echo "SJ=/scratch/yz77862/pollen_mRNA/gene_guide/round1/${INPUT}_STARpass1/SJ.out.tab"  >> ${OUT}
    echo "STAR \\"  >> ${OUT}
    echo "--genomeDir \${index} \\"  >> ${OUT}
    echo "--runThreadN \${thread} \\"  >> ${OUT}
    echo "--sjdbFileChrStartEnd \${SJ} \\"  >> ${OUT}
    echo "--runMode alignReads \\"  >> ${OUT}
    echo "--readFilesIn \${read} \\"  >> ${OUT}
    echo "--outSAMattributes All \\"  >> ${OUT}
    echo "--outSAMmapqUnique 10 \\"  >> ${OUT}
    echo "--outFilterMismatchNmax 3 \\"  >> ${OUT}
    echo "--outFileNamePrefix ${INPUT}_round-2 \\"  >> ${OUT}
    echo "--outBAMsortingThreadN 4 \\"  >> ${OUT}
    echo "--outSAMtype BAM SortedByCoordinate \\"  >> ${OUT}
    echo "--outFilterScoreMin 50 \\" >> ${OUT}  
    echo "--outFilterMultimapNmax 10000 \\" >> ${OUT}  
    echo "--outWigType bedGraph read1_5p"  >> ${OUT}
    sbatch ${OUT}
done < <(cut -f1,2 ${list} | grep -v 'skip' | sort -u)
