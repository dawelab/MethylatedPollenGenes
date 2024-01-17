cd /scratch/yz77862/pollen

#The TE data is downloaded from maizegdb B73v5 file
#Make the TE avalible gtf file for mapping 
gunzip Zm-B73-REFERENCE-NAM-5.0.TE.gff3.gz

for i in Gypsy Copia LINE helitron Mutator Harbinger Mariner hAT CACTA;do 
awk '{print $1,$2,"exon",$4,$5,$6,$7,$8,"transcript_id ""\""$3"\""}' OFS="\t"  Zm-B73-REFERENCE-NAM-5.0.TE.gff3 | grep ${i} > Zm-B73-REFERENCE-NAM-5.0.TE.${i}.gtf
done
