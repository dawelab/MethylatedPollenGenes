list=/scratch/yz77862/Allim/B73v5_Ki11/list
while read INPUT; do

OUT=/scratch/yz77862/Allim/gene_guide/shell/${INPUT}_trim.sh
    echo '#!/bin/bash'  >> ${OUT} 
    echo "#SBATCH --job-name=${INPUT}_mapping"   >> ${OUT}            
    echo "#SBATCH --partition=batch"   >> ${OUT} 
    echo "#SBATCH --nodes=1"   >> ${OUT}                  
    echo "#SBATCH --ntasks=1"   >> ${OUT}              
    echo "#SBATCH --cpus-per-task=18"   >> ${OUT}          
    echo "#SBATCH --mem=80G"   >> ${OUT}                  
    echo "#SBATCH --time=010:00:00"   >> ${OUT}             
    echo "#SBATCH --output=${INPUT}_com_bam.out"   >> ${OUT}         
    echo "#SBATCH --error=${INPUT}_com_bam.err"   >> ${OUT}         
    echo " "  >> ${OUT}  
    echo "ml Trim_Galore" >> ${OUT}  
    echo "cd /scratch/yz77862/Allim/B73v5_Ki11" >> ${OUT}
    echo " "  >> ${OUT}
    echo "read1=/scratch/yz77862/Allim/B73v5_Ki11/${INPUT}_1.fastq.gz"  >> ${OUT}  
    echo "read2=/scratch/yz77862/Allim/B73v5_Ki11/${INPUT}_2.fastq.gz"  >> ${OUT}  
    echo "output_directory=/scratch/yz77862/Allim/B73v5_Ki11/trim "  >> ${OUT}  
    echo "trim_galore --paired --fastqc --illumina -o /${output_directory} \${read1} \${read2}"  >> ${OUT}    
done < <(cut -f1,2 ${list} | grep -v 'skip' | sort -u)
