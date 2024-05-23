cd /scratch/yz77862/pollen
##For genes
ml Cufflinks

#To make the variable for the gtf files
gff=/scratch/yz77862/B73v5_genome/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gff3
sed 's/chr//g' ${gff} | gffread -T -o Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gtf

##ForTEs
#The TE data is downloaded from maizegdb B73v5 file
#Make the TE avalible gtf file for mapping 
gunzip Zm-B73-REFERENCE-NAM-5.0.TE.gff3.gz

for i in Gypsy Copia LINE helitron Mutator Harbinger Mariner hAT CACTA;do 
awk '{print $1,$2,"exon",$4,$5,$6,$7,$8,"transcript_id ""\""$3"\""}' OFS="\t"  Zm-B73-REFERENCE-NAM-5.0.TE.gff3 | grep ${i} > Zm-B73-REFERENCE-NAM-5.0.TE.${i}.gtf
done
