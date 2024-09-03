#!/bin/bash
#SBATCH --job-name=bed2fragreg
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --constraint=AMD
#SBATCH --time=2:00:00
#SBATCH --mem=20gb

ml CGmapTools/0.1.2-foss-2022a
#I=~/references/W22_B73_genes.gff  #Put in the the gff (anotation) files
#prefix=W22_B73_genes.gff  #Put in the name of you want for the output. Name the file!
I=~/references/Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_Core_pollen_teM-2.gff #Put in the the gff (anotation) files
prefix=W22_MPGs #Put in the name of you want for the output. Name the file!
let withingene=1500  #Put in the number about how deep you want to go into the gene
let bin=100    #Put in the number of bin size
let flank=3000  #Put in the number of the flanking region
let n=(${withingene}+${flank})/$bin

awk '$1>0'  ${I} > ${prefix}.bed
#Calculating the upstream

awk '$7=="+"' ${prefix}.bed | awk '{print $1,$4-'$flank',$4+'$withingene',"+"}' OFS="\t" > ${prefix}_forward.bed
awk '$7=="-"' ${prefix}.bed | awk '{print $1,$5+'$flank',$5-'$withingene',"-"}' OFS="\t" > ${prefix}_reverse.bed
cat  ${prefix}_forward.bed ${prefix}_reverse.bed | sort -b -k1,1 -k2,2n -k3,3n> ${prefix}_temp.bed
cgmaptools bed2fragreg -i ${prefix}_temp.bed -n $n -o ${prefix}_unsorted.bed
sort -b -k1,1 -k2,2n -k3,3n ${prefix}_unsorted.bed > ${prefix}_up.bed
rm ${prefix}_forward.bed ${prefix}_reverse.bed ${prefix}_temp.bed ${prefix}_unsorted.bed

#Calculating the downstream
awk '$7=="+"' ${prefix}.bed | awk '{print $1,$5-'$withingene',$5+'$flank',"+"}' OFS="\t" > ${prefix}_forward.bed
awk '$7=="-"' ${prefix}.bed |  awk '{print $1,$4+'$withingene',$4-'$flank',"-"}' OFS="\t" > ${prefix}_reverse.bed 
cat  ${prefix}_forward.bed ${prefix}_reverse.bed | sort -b -k1,1 -k2,2n -k3,3n> ${prefix}_temp.bed
cgmaptools bed2fragreg -i ${prefix}_temp.bed -n $n -o ${prefix}_unsorted.bed
sort -b -k1,1 -k2,2n -k3,3n ${prefix}_unsorted.bed > ${prefix}_down.bed
rm ${prefix}_forward.bed ${prefix}_reverse.bed ${prefix}_temp.bed ${prefix}_unsorted.bed ${prefix}.bed
