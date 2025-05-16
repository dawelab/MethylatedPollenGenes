#!/bin/bash
#SBATCH --job-name=B73_Ki11_mix_mapping
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=18
#SBATCH --mem=400G
#SBATCH --time=024:00:00
#SBATCH --output=B73_Ki11_mix_com_bam.out
#SBATCH --error=B73_Ki11_mix_com_bam.err


ml STAR/2.7.10b-GCC-11.3.0
cd /scratch/yz77862/Allim/gene_guide/output_default

index=/scratch/yz77862/Allim/reference/B73v5_Ki11/STAR
read1=/scratch/yz77862/Allim/mix_B73_Ki11/mix_R1.fastq.gz
read2=/scratch/yz77862/Allim/mix_B73_Ki11/mix_R2.fastq.gz
 
    
STAR --genomeDir ${index} \
--runThreadN 6 \
--readFilesIn ${read1} ${read2} \
--readFilesCommand zcat \
--outSAMtype BAM SortedByCoordinate \
--outSAMunmapped Within \
--outSAMattributes Standard \
--outFileNamePrefix B73_Ki11_mix
