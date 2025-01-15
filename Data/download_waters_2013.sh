

# Output directory for the downloaded data
OUTPUT_DIR="/your/output/directory"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# List of SRA accessions and sample names
DATA_LIST=(
    "SRR1016026 B73xKi11_1"
    "SRR1016209 B73xOh43_MN_1"
    "SRR1016213 Ki11xB73_1"
    "SRR1016214 Ki11xMo17_1"
    "SRR1016217 Mo17xKi11_1"
    "SRR1016220 Mo17xOh43_1"
    "SRR1016223 Oh43xB73_MN_1"
    "SRR1016225 Oh43xMo17_1"
    "SRR1020269 B73xKi11_2"
    "SRR1020270 B73xOh43_MN_2"
    "SRR1020271 Ki11xB73_2"
    "SRR1020275 Ki11xMo17_2"
    "SRR1020281 Mo17xKi11_2"
    "SRR1020283 Mo17xOh43_2"
    "SRR1020284 Oh43xB73_MN_2"
    "SRR1020285 Oh43xMo17_2"
    "SRR11509903 PH207xW22_1"
    "SRR11509904 B73xPH207_3"
    "SRR11509905 B73xPH207_2"
    "SRR11509906 B73xPH207_1"
    "SRR11509907 PH207xB73_3"
    "SRR11509908 PH207xB73_2"
    "SRR11509909 PH207xB73_1"
    "SRR11509910 B73xW22_3"
    "SRR11509911 W22xPH207_3"
    "SRR11509912 W22xPH207_2"
    "SRR11509913 W22xPH207_1"
    "SRR11509914 W22xB73_3"
    "SRR11509915 W22xB73_2"
    "SRR11509916 W22xB73_1"
    "SRR11509917 PH207xW22_3"
    "SRR11509918 PH207xW22_2"
    "SRR11509919 B73xW22_2"
    "SRR11509920 B73xW22_1"
    "SRR1038408 B73xMo17_15DAP"
    "SRR1038409 Mo17xB73_15DAP"
    "SRR1038406 B73xMo17_10DAP"
    "SRR1038407 Mo17xB73_10DAP"
)

# Loop through the data list and process each entry
for ITEM in "${DATA_LIST[@]}"; do
    # Extract the SRA ID and sample name
    SRA_ID=$(echo "$ITEM" | awk '{print $1}')
    SAMPLE_NAME=$(echo "$ITEM" | awk '{print $2}')
    
    echo "Processing $SRA_ID ($SAMPLE_NAME)..."

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

    echo "Completed $SRA_ID ($SAMPLE_NAME)."
done

echo "All downloads and conversions are complete!"
