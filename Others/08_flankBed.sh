#!/bin/bash
#SBATCH --job-name=gff2bed.sh
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --constraint=AMD
#SBATCH --time=24:00:00
#SBATCH --mem=8gb
#SBATCH --mail-user=gent.edu
#SBATCH --mail-type=BEGIN,END,NONE,FAIL,REQUEUE#SBATCH --mail-type=BEGIN,END,NONE,FAIL,REQUEUE
ml BEDOPS/2.4.41-foss-2021b
ml BEDTools/2.30.0-GCC-12.2.0

bedtools flank -l 600 -r 0 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_genes.upflank600.gff
bedtools flank -l 600 -r 0 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_pollen_genes.upflank600.gff
bedtools flank -l 600 -r 0 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen_teM-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_MPGs.upflank600.gff

bedtools flank -l 300 -r 0 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_genes.upflank300.gff
bedtools flank -l 300 -r 0 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_pollen_genes.upflank300.gff
bedtools flank -l 300 -r 0 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen_teM-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_MPGs.upflank300.gff

bedtools flank -l 100 -r 0 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_genes.upflank100.gff
bedtools flank -l 100 -r 0 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_pollen_genes.upflank100.gff
bedtools flank -l 100 -r 0 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen_teM-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_MPGs.upflank100.gff

bedtools flank -l 1 -r 0 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_genes.upflank1.gff
bedtools flank -l 1 -r 0 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_pollen_genes.upflank1.gff
bedtools flank -l 1 -r 0 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen_teM-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_MPGs.upflank1.gff

bedtools flank -l 0 -r 600 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_genes.downflank600.gff
bedtools flank -l 0 -r 600 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_pollen_genes.downflank600.gff
bedtools flank -l 0 -r 600 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen_teM-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_MPGs.downflank600.gff

bedtools flank -l 0 -r 300 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_genes.downflank300.gff
bedtools flank -l 0 -r 300 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_pollen_genes.downflank300.gff
bedtools flank -l 0 -r 300 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen_teM-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_MPGs.downflank300.gff

bedtools flank -l 0 -r 100 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_genes.downflank100.gff
bedtools flank -l 0 -r 100 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_pollen_genes.downflank100.gff
bedtools flank -l 0 -r 100 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen_teM-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_MPGs.downflank100.gff

bedtools flank -l 0 -r 1 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_genes.downflank1.gff
bedtools flank -l 0 -r 1 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_core_pollen_genes.downflank1.gff
bedtools flank -l 0 -r 1 -s -i ~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen_teM-2.gff -g /scratch/gent/genomes/W22-REFERENCE-NRGENE-2.0.fasta.fai > ~/references/W22_MPGs.downflank1.gff

gff2bed < ~/references/W22_MPGs.upflank100.gff > ~/references/W22_MPGs.upflank100.bed
sort -k 1,1 -k 2n,2 ~/references/W22_MPGs.upflank100.bed > ~/references/W22_MPGs.upflank100.10sort.bed
