#!/usr/bin/perl

my @files = <w3-EN*.CGmap.gz>;
for my $file (@files) {
    open out, '>', "$file.sh";
        print out "#!/bin/bash\n";
        print out "#SBATCH --job-name=$file\n";
        print out "#SBATCH --partition=batch\n";        
        print out "#SBATCH --ntasks=1\n";
        print out "#SBATCH --nodes=1\n";
        print out "#SBATCH --ntasks-per-node=1\n";
		print out "#SBATCH --constraint=AMD\n";
        print out "#SBATCH --time=100:00:00\n";
        print out "#SBATCH --mem=10gb\n";
		print out "module load CGmapTools/0.1.2-foss-2022a\n";
		print out "gunzip -c $file | grep CHH | grep CC > $file.CCH\n";
		print out "gzip $file.CCH\n";		
		print "sbatch $file.sh\n";
        system "sbatch $file.sh";
}
