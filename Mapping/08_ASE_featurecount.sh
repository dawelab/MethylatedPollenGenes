#!/bin/bash
#SBATCH --job-name=featurecount              
#SBATCH --partition=batch                                           
#SBATCH --ntasks=1                                                  
#SBATCH --cpus-per-task=4                                      
#SBATCH --mem=200gb                                                    
#SBATCH --time=10:00:00                                           
#SBATCH --output=featurecount.out                          
#SBATCH --error=featurecount.err


cd /scratch/yz77862/Allim/gene_guide/round2
gtf=/scratch/yz77862/Allim/reference/B73v5_Ki11/Zm-B73-Ki11.gtf
/home/yz77862/apps/subread-1.6.0-Linux-x86_64/bin/featureCounts  -a ${gtf} -o B73_KI11_repci_exon_count.counts ERR2889292_round-2Aligned.sortedByCoord.out.bam ERR2889293_round-2Aligned.sortedByCoord.out.bam ERR2889298_round-2Aligned.sortedByCoord.out.bam ERR2889302_round-2Aligned.sortedByCoord.out.bam ERR2889303_round-2Aligned.sortedByCoord.out.bam -M -f -t exon -g gene_id 

