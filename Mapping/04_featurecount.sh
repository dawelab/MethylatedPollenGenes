list=/scratch/yz77862/pollen/merge_bam/list
mkdir -p /scratch/yz77862/shell/tpm/
while read GENOME;do
   OUT=/scratch/yz77862/shell/tpm/${GENOME}_count_TE.sh
    echo '#!/bin/bash'   >> ${OUT}  
    echo "#SBATCH --job-name=${GENOME}_self.count"   >> ${OUT} 
    echo "#SBATCH --partition=batch"  >> ${OUT}  
    echo "#SBATCH --nodes=1"  >> ${OUT}  
    echo "#SBATCH --ntasks=1"  >> ${OUT}  
    echo "#SBATCH --cpus-per-task=1"  >> ${OUT}  
    echo "#SBATCH --mem=45G"  >> ${OUT}  
    echo "#SBATCH --time=00:30:00"  >> ${OUT}  
    echo "#SBATCH --output=${GENOME}_self.out"  >> ${OUT}  
    echo "#SBATCH --error=${GENOME}_self.err"  >> ${OUT}  
    echo "cd /scratch/yz77862/pollen/merge_bam"  >> ${OUT} 
    echo " "  >> ${OUT} 
    echo "Bam=/scratch/yz77862/pollen/merge_bam/${GENOME}.merged.bam"  >> ${OUT}
    echo "gtf=/scratch/yz77862/pollen/Zm-B73-REFERENCE-NAM-5.0.TE.gtf"  >> ${OUT} 
    echo " "  >> ${OUT}  
    echo "/home/yz77862/apps/subread-1.6.0-Linux-x86_64/bin/featureCounts  -a \${gtf} -o /scratch/yz77862/pollen/count/${GENOME}.counts \${Bam} -M -f -t exon" >> ${OUT} 
    #sbatch ${OUT}
done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)
