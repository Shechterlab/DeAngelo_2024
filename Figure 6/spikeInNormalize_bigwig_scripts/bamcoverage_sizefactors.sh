#!/bin/bash

#SBATCH -p normal      #partition/queue name
#SBATCH --job-name=bamcoverage    # Job name
#SBATCH --mail-type=NONE    # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=1      # Run on a single CPU
#SBATCH --cpus-per-task=40      # Number of CPU cores per task
#SBATCH --mem=40gb      # Job memory request
#SBATCH --time=24:00:00              # Time limit hrs:min:sec
#SBATCH --output=bamcoverage.log      # Standard output and error log

.  /gs/gsfs0/hpc01/rhel8/apps/conda3/bin/activate

conda activate deeptools

#Path to the directory containing BAM files
bam_directory="/gs/gsfs0/users/shechter-lab/data/NGS/rna-seq/2024-05_A549_PRMT5i-fractionation/nextflow_hg38dm6_results/star_salmon"

#Path to the text file containing size factors
sizefactor_file="/gs/gsfs0/users/shechter-lab/data/NGS/rna-seq/2024-05_A549_PRMT5i-fractionation/nextflow_hg38dm6_results/bedgraph_sf/sizefactors.txt"

#Loop through each BAM file in the directory
for bam_file in "$bam_directory"/*.bam; do

    #Extract the BAM filename (without path)
    bam_filename=$(basename "$bam_file")

    #Use awk to extract the size factor corresponding to the BAM file

    sizefactor=$(awk -v bam="$bam_filename" '
        NR == 1 { for (i = 1; i <= NF; i++) filenames[i] = $i }
        NR == 2 { for (i = 1; i <= NF; i++) if (filenames[i] == bam) print $i }
    ' "$sizefactor_file")

    #Check if size factor was found
    if [ -n "$sizefactor" ]; then
        bamCoverage -b $bam_file -o `pwd`/${bam_filename%.bam}.bedgraph -of bedgraph -bs 1 -p 40 -v --scaleFactor $sizefactor
    else
        echo "Size factor not found for $bam_filename"
    fi

done

conda deactivate
