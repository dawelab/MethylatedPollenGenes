##The method to make gene annotation file is described in Zeng et al 2023.
awk '$3=="exon"' Zm-B73-REFERENCE-NAM-5.0.1.canon.gff3 | cut -f1 -d ';' | sed 's/Parent=//g' | sed 's/_T0..//g' > Zm-B73-REFERENCE-NAM-5.0.1.canon.exon.gff3
