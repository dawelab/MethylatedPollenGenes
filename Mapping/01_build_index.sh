#!/bin/bash
#SBATCH --job-name=index_star
#SBATCH --partition=highmem_p
#SBATCH --ntasks=1 
#SBATCH --mem=180G
#SBATCH --time=8:00:00
#SBATCH --export=NONE
#SBATCH --output=B73_Index_star.out
#SBATCH --error=B73_Index_star.err

ml STAR/2.7.2b-GCC-8.3.0
work_dir=
cd ${work_dir}

mkdir -p /scratch/yz77862/index/${Founder}/STAR
output_dir=/scratch/yz77862/pollen/pollen/STAR
genome=/scratch/yz77862/pollen/Zm-B73-REFERENCE-NAM-5.0.fa

STAR \
     --runThreadN 8 \
     --runMode genomeGenerate \
     --genomeDir ${output_dir} \
     --genomeFastaFiles ${genome} 
