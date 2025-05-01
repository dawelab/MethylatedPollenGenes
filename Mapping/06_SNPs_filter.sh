#!/bin/bash
#SBATCH --job-name=${INPUT}_mapping
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=18
#SBATCH --mem=200G
#SBATCH --time=010:00:00
#SBATCH --output=q20_com_VCF.out
#SBATCH --error=q20_com_VCF_bam.err

ml SAMtools
cd /scratch/yz77862/Allim/gene_guide/output_default

