#!/usr/bin/perl

my @files = <*.bam>;
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
	    print out "samtools index $file\n";
	    print out "samtools view -h $file 3:54977761-54978260 -o $file.exp1_up600.sam\n";  
	    print out "samtools view -h $file 3:86636030-86636529 -o $file.polygal_up500.sam\n"; 
	    print out "samtools view -h $file 7:133721487-133721986 -o $file.AGP-like_up500.sam\n";
	    print out "samtools view -h $file 5:152375179-152375678 -o $file.PME_up500.sam\n";   
 	    print out "samtools view -h $file 9:16361514-16362013 -o $file.exp2_up500.sam\n";
	    print out "samtools view -h $file 3:54977661-54978260 -o $file.exp1_up500.sam\n";   
	    print out "samtools view -h $file 3:86636030-86636629 -o $file.polygal_up600.sam\n"; 
	    print out "samtools view -h $file 7:133679456-133680055  -o $file.AGP-like_up600.sam\n";
	    print out "samtools view -h $file 5:152375079-152375678 -o $file.PME_up600.sam\n";   
 	    print out "samtools view -h $file 9:16361514-16362113 -o $file.exp2_up600.sam\n";   
		print "sbatch $file.sh\n";
    	system "sbatch $file.sh";		
		close(out);	
}
