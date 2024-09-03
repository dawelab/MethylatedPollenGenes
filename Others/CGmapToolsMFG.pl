#!/usr/bin/perl

my @files = <MP*.CGmap.gz>;
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
		
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_core_genes_up.bed -c 1 -x CG > $file.W22_core_genes.CG.up.mfg\n";
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_core_genes_up.bed -c 1 -x CHG > $file.W22_core_genes.CHG.up.mfg\n";
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_core_genes_up.bed -c 1 -x CHH > $file.W22_core_genes.CHH.up.mfg\n";

		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_core_pollen_genes_up.bed -c 1 -x CG > $file.W22_core_pollen_genes.CG.up.mfg\n";
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_core_pollen_genes_up.bed -c 1 -x CHG > $file.W22_core_pollen_genes.CHG.up.mfg\n";
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_core_pollen_genes_up.bed -c 1 -x CHH > $file.W22_core_pollen_genes.CHH.up.mfg\n";

		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_MPGs_up.bed -c 1 -x CG > $file.W22_MPGs.CG.up.mfg\n";
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_MPGs_up.bed -c 1 -x CHG > $file.W22_MPGs.CHG.up.mfg\n";
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_MPGs_up.bed -c 1 -x CHH > $file.W22_MPGs.CHH.up.mfg\n";

		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_core_genes_down.bed -c 1 -x CG > $file.W22_core_genes.CG.down.mfg\n";
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_core_genes_down.bed -c 1 -x CHG > $file.W22_core_genes.CHG.down.mfg\n";
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_core_genes_down.bed -c 1 -x CHH > $file.W22_core_genes.CHH.down.mfg\n";

		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_core_pollen_genes_down.bed -c 1 -x CG > $file.W22_core_pollen_genes.CG.down.mfg\n";
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_core_pollen_genes_down.bed -c 1 -x CHG > $file.W22_core_pollen_genes.CHG.down.mfg\n";
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_core_pollen_genes_down.bed -c 1 -x CHH > $file.W22_core_pollen_genes.CHH.down.mfg\n";

		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_MPGs_down.bed -c 1 -x CG > $file.W22_MPGs.CG.down.mfg\n";
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_MPGs_down.bed -c 1 -x CHG > $file.W22_MPGs.CHG.down.mfg\n";
		print out "gunzip -c $file | cgmaptools mfg -r /home/gent/references/W22_MPGs_down.bed -c 1 -x CHH > $file.W22_MPGs.CHH.down.mfg\n";


	    print "sbatch $file.sh\n";
        system "sbatch $file.sh";
}