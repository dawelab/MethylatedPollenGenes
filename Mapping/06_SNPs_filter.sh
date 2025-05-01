#!/bin/bash
#SBATCH --job-name=filter
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=18
#SBATCH --mem=200G
#SBATCH --time=010:00:00
#SBATCH --output=q20_com_filter.out
#SBATCH --error=q20_com_filter_bam.err

ml SAMtools
cd /scratch/yz77862/Allim/gene_guide/output_default

for i in *bam;do
samtools view -q 20 -o /scratch/yz77862/Allim/gene_guide/output_default/Q20/${i}_q20.bam ${i}

cd /scratch/yz77862/Allim/gene_guide/output_default/Q20
gtf=/scratch/yz77862/Allim/reference/B73v5_Ki11/Zm-B73-Ki11.gtf
/home/yz77862/apps/subread-1.6.0-Linux-x86_64/bin/featureCounts -a ${gtf} -o B73_KI11_repci_exon_count.counts *bam -M -f -t exon -g gene_id 
