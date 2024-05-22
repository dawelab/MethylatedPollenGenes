#The link around maize pan genome is downloaded from maizegdb:
wget https://download.maizegdb.org/Pan-genes/Pan-Zea/pan-zea.v2.pan-genes_table.tsv.gz
#Process the file that it only contain geneID
gunzip pan-zea.v2.pan-genes_table_geneIDonly.tsv 
sed 's/_T0..//g' pan-zea.v2.pan-genes_table.tsv > pan-zea.v2.pan-genes_table_geneIDonly.tsv 
##Import this file into R for further process
