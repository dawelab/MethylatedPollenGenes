#!/usr/bin/perl

my @files = <*sorted.bam>;
for my $file (@files) {
    open out, '>', "$file.sh";
        print out "#!/bin/bash\n";
        print out "#SBATCH --job-name=$file\n";
        print out "#SBATCH --partition=batch\n";        
        print out "#SBATCH --ntasks=1\n";
        print out "#SBATCH --nodes=1\n";
        print out "#SBATCH --ntasks-per-node=1\n";
		print out "#SBATCH --constraint=AMD\n";
        print out "#SBATCH --time=12:00:00\n";
        print out "#SBATCH --mem=10gb\n";
		print out "module load SAMtools/1.17-GCC-12.2.0\n";
		print out "module load BEDTools/2.30.0-GCC-12.2.0\n";		
	    #print out "samtools index $file\n";
 	    print out "bedtools intersect -a $file -b ~/references/W22_MPGs.upflank100.gff > $file.W22_MPGs.upflank100.bam\n"; 
  		print out "samtools view -h $file.W22_MPGs.upflank100.bam -o $file.W22_MPGs.upflank100.sam\n";

 	    print out "bedtools intersect -a $file -b ~/references/W22_core_genes.upflank100.gff > $file.W22_core_genes.upflank100.bam\n"; 
  		print out "samtools view -h $file.W22_core_genes.upflank100.bam -o $file.W22_core_genes.upflank100.sam\n";
  
 	    print out "bedtools intersect -a $file -b ~/references/W22_mMPGs.upflank100.bed > $file.W22_mMPGs.upflank100.bam\n"; 
  		print out "samtools view -h $file.W22_mMPGs.upflank100.bam -o $file.W22_mMPGs.upflank100.sam\n";
   		  				 		 			
		print "sbatch $file.sh\n";
    	system "sbatch $file.sh";		
		close(out);	
}
