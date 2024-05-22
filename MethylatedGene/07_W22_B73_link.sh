#The link around maize pan genome is downloaded from maizegdb:
wget https://download.maizegdb.org/Pan-genes/Pan-Zea/pan-zea.v2.pan-genes_table.tsv.gz
#Process the file that it only contain geneID
gunzip pan-zea.v2.pan-genes_table_geneIDonly.tsv 
sed 's/_T0..//g' pan-zea.v2.pan-genes_table.tsv > pan-zea.v2.pan-genes_table_geneIDonly.tsv 
##Import this file into R for further process

##Create a data set with the first column of W22 gff3 as geneID for merging
grep -v "^#" Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1.gff3 |awk '$3!="chromosome"'  > W22.gff3
grep -v "^#" Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1.gff3 |awk '$3!="chromosome"' | cut -f1 -d ';'| sed 's/ID=//g' | sed 's/_T0..//g' | sed 's/Parent=//g' | awk '{print $9}' > W22_geneID
paste W22_geneID W22.gff3 > Zm-W22-REFERENCE-NRGENE-2.0_Zm00004b.1_geneID.gff3
