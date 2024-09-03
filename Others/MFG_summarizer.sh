#!/bin/bash
#SBATCH --job-name=closest
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --constraint=AMD
#SBATCH --time=2:00:00
#SBATCH --mem=10gb
#SBATCH --mail-user=gent.edu
#SBATCH --mail-type=BEGIN,END,NONE,FAIL,REQUEUE#SBATCH --mail-type=BEGIN,END,NONE,FAIL,REQUEUE

grep 'total_ave_mC' *W22_core_genes.CHH.up.mfg | sed 's/'.CGmap.gz.W22_core_genes.CHH.up.mfg:total_ave_mC'//g' > CHH_up_W22_core_genes_mfg_summary.txt
grep 'total_ave_mC' *W22_core_genes.CHG.up.mfg | sed 's/'.CGmap.gz.W22_core_genes.CHG.up.mfg:total_ave_mC'//g' > CHG_up_W22_core_genes_mfg_summary.txt
grep 'total_ave_mC' *W22_core_genes.CG.up.mfg | sed 's/'.CGmap.gz.W22_core_genes.CG.up.mfg:total_ave_mC'//g' > CG_up_W22_core_genes_mfg_summary.txt

grep 'total_ave_mC' *W22_core_pollen_genes.CHH.up.mfg | sed 's/'.CGmap.gz.W22_core_pollen_genes.CHH.up.mfg:total_ave_mC'//g' > CHH_up_W22_core_pollen_genes_mfg_summary.txt
grep 'total_ave_mC' *W22_core_pollen_genes.CHG.up.mfg | sed 's/'.CGmap.gz.W22_core_pollen_genes.CHG.up.mfg:total_ave_mC'//g' > CHG_up_W22_core_pollen_genes_mfg_summary.txt
grep 'total_ave_mC' *W22_core_pollen_genes.CG.up.mfg | sed 's/'.CGmap.gz.W22_core_pollen_genes.CG.up.mfg:total_ave_mC'//g' > CG_up_W22_core_pollen_genes_mfg_summary.txt

grep 'total_ave_mC' *W22_MPGs.CHH.up.mfg | sed 's/'.CGmap.gz.W22_MPGs.CHH.up.mfg:total_ave_mC'//g' > CHH_up_W22_MPGs_mfg_summary.txt
grep 'total_ave_mC' *W22_MPGs.CHG.up.mfg | sed 's/'.CGmap.gz.W22_MPGs.CHG.up.mfg:total_ave_mC'//g' > CHG_up_W22_MPGs_mfg_summary.txt
grep 'total_ave_mC' *W22_MPGs.CG.up.mfg | sed 's/'.CGmap.gz.W22_MPGs.CG.up.mfg:total_ave_mC'//g' > CG_up_W22_MPGs_mfg_summary.txt

grep 'total_ave_mC' *W22_core_genes.CHH.down.mfg | sed 's/'.CGmap.gz.W22_core_genes.CHH.down.mfg:total_ave_mC'//g' > CHH_down_W22_core_genes_mfg_summary.txt
grep 'total_ave_mC' *W22_core_genes.CHG.down.mfg | sed 's/'.CGmap.gz.W22_core_genes.CHG.down.mfg:total_ave_mC'//g' > CHG_down_W22_core_genes_mfg_summary.txt
grep 'total_ave_mC' *W22_core_genes.CG.down.mfg | sed 's/'.CGmap.gz.W22_core_genes.CG.down.mfg:total_ave_mC'//g' > CG_down_W22_core_genes_mfg_summary.txt

grep 'total_ave_mC' *W22_core_pollen_genes.CHH.down.mfg | sed 's/'.CGmap.gz.W22_core_pollen_genes.CHH.down.mfg:total_ave_mC'//g' > CHH_down_W22_core_pollen_genes_mfg_summary.txt
grep 'total_ave_mC' *W22_core_pollen_genes.CHG.down.mfg | sed 's/'.CGmap.gz.W22_core_pollen_genes.CHG.down.mfg:total_ave_mC'//g' > CHG_down_W22_core_pollen_genes_mfg_summary.txt
grep 'total_ave_mC' *W22_core_pollen_genes.CG.down.mfg | sed 's/'.CGmap.gz.W22_core_pollen_genes.CG.down.mfg:total_ave_mC'//g' > CG_down_W22_core_pollen_genes_mfg_summary.txt

grep 'total_ave_mC' *W22_MPGs.CHH.down.mfg | sed 's/'.CGmap.gz.W22_MPGs.CHH.down.mfg:total_ave_mC'//g' > CHH_down_W22_MPGs_mfg_summary.txt
grep 'total_ave_mC' *W22_MPGs.CHG.down.mfg | sed 's/'.CGmap.gz.W22_MPGs.CHG.down.mfg:total_ave_mC'//g' > CHG_down_W22_MPGs_mfg_summary.txt
grep 'total_ave_mC' *W22_MPGs.CG.down.mfg | sed 's/'.CGmap.gz.W22_MPGs.CG.down.mfg:total_ave_mC'//g' > CG_down_W22_MPGs_mfg_summary.txt
