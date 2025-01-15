#!/bin/bash
#SBATCH --job-name=SRA                   
#SBATCH --partition=highmem_p                           
#SBATCH --ntasks=1                                                  
#SBATCH --cpus-per-task=30
#SBATCH --mem=30gb                                                    
#SBATCH --time=060:00:00                                          
#SBATCH --output=download_sra.out                       
#SBATCH --error=download_sra.err

OUTPUT_DIR=/scratch/yz77862/Allim/data

ml SRA-Toolkit/3.0.3-gompi-2022a
cd /scratch/yz77862/Allim/data

# Create the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# List of SRA accessions and sample names
SRA_LIST=(
    "SRR1020271 Ki11xB73_MN_1"
    "SRR1020270 B73xOh43_MN_1"
    "SRR1020275 Ki11xMo17_MN_1"
    "SRR1020283 M017xKi11_MN_1"
    "SRR1020269 B73xKi11_MN_1"
    "SRR1020281 Oh43xMo17_MN_1"
    "SRR1020285 Mo17xOh43_MN_1"
    "SRR1020284 Oh43xB73_MN_1"
    "SRR1016214 Ki11xMo17_MN_2"
    "SRR1016217 Mo17xKi11_MN_2"
    "SRR1016213 Ki11xB73_MN_2"
    "SRR1016026 B73xKi11_MN_2"
    "SRR1016225 Oh43xMo17_MN_2"
    "SRR1016209 B73xOh43_MN_2"
    "SRR1016223 Oh43xB73_MN_2"
    "SRR1016220 Mo17xOh43_MN_2"
)

# Loop through the SRA accessions and download each
for ITEM in "${SRA_LIST[@]}"; do
    # Split the ITEM into SRA_ID and SAMPLE_NAME
    SRA_ID=$(echo "$ITEM" | awk '{print $1}')
    SAMPLE_NAME=$(echo "$ITEM" | awk '{print $2}')
    
    # Download the SRA file
    prefetch "$SRA_ID" --output-directory "$OUTPUT_DIR"

    # Convert SRA to FASTQ format and rename files with sample names
    fastq-dump --split-files --gzip -O "$OUTPUT_DIR" "$OUTPUT_DIR/$SRA_ID.sra"

    # Rename FASTQ files with sample names
    if [ -f "$OUTPUT_DIR/${SRA_ID}_1.fastq.gz" ]; then
        mv "$OUTPUT_DIR/${SRA_ID}_1.fastq.gz" "$OUTPUT_DIR/${SAMPLE_NAME}_1.fastq.gz"
    fi
    if [ -f "$OUTPUT_DIR/${SRA_ID}_2.fastq.gz" ]; then
        mv "$OUTPUT_DIR/${SRA_ID}_2.fastq.gz" "$OUTPUT_DIR/${SAMPLE_NAME}_2.fastq.gz"
    fi
done
