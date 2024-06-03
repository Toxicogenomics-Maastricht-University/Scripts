#!/bin/bash
# Specify the text file containing SRA accession numbers
accession_file="SRR_Acc_List.txt"

# Define the directory where you want to save the downloaded files
download_directory="GSE168484"

# Create the download directory
mkdir -p "$download_directory"

# Check if fastq-dump is installed
if ! command -v fastq-dump &> /dev/null; then
    echo "fastq-dump is not installed. Please install it first."
    exit 1
fi

# Check if the accession file exists
if [ ! -f "$accession_file" ]; then
    echo "Accession file not found: $accession_file"
    exit 1
fi

# Loop through each line in the accession file and download the SRA datasets
while IFS= read -r accession; do
    accession=$(echo "$accession" | tr -d '\r')  # Remove carriage return if present
    echo "Downloading and converting $accession..."

    # Download and convert the SRA dataset into the specified download directory
    fastq-dump --split-files -O "$download_directory" "$accession"

    # Wait for 1 minute before deleting the .sra file
    sleep 60

    rm "/home/bbwanya/ncbi/public/sra/$accession.sra"
done < "$accession_file"

cd ${download_directory}
pigz *.fastq
