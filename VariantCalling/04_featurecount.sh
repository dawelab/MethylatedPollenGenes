cd  /scratch/yz77862/Allim/readcount

gtf=/scratch/yz77862/Allim/reference/B73/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gtf
bam=/scratch/yz77862/Allim/gene_guide/B73/output_default/Q20/ERR2889294Aligned.sortedByCoord.out.bam_q20.bam
/home/yz77862/apps/subread-1.6.0-Linux-x86_64/bin/featureCounts  -a ${gtf} -o B73_exon_count.counts ${bam} -M -f -t exon -g gene_id 

gtf=/scratch/yz77862/Allim/reference/Ki11/Zm-Ki11-REFERENCE-NAM-1.0_Zm00030ab.1.gtf
bam=/scratch/yz77862/Allim/gene_guide/Kill/output_default/Q20/q20_filter_ERR2889294.bam
/home/yz77862/apps/subread-1.6.0-Linux-x86_64/bin/featureCounts  -a ${gtf} -o Ki11_exon_count.counts ${bam} -M -f -t exon -g gene_id 
