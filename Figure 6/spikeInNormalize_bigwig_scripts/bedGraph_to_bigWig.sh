#!/bin/bash

#SBATCH -p normal
#SBATCH --job-name=bgToBW
#SBATCH --mail-type=NONE
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5gb
#SBATCH --time=24:00:00
#SBATCH --output=bgToBW.log

# Activate Conda environment
source /gs/gsfs0/hpc01/rhel8/apps/conda3/bin/activate

conda activate ucsc-bedgraphtobigwig

# Paths
chrom_sizes="/gs/gsfs0/users/shechter-lab/data/NGS/stds/hs-dm/chromsizes.txt"
bedgraph_dir="/gs/gsfs0/shared-lab/shechter-lab/data/NGS/rna-seq/2024-05_A549_PRMT5i-fractionation/nextflow_hg38dm6_results/bedgraph_sf"
output_dir="$bedgraph_dir/bw"

# Create output directory
mkdir -p "$output_dir"

# Loop through each bedgraph file and convert it
for bedgraph_file in "$bedgraph_dir"/*.sorted.bedgraph; do
    output_file="${output_dir}/$(basename "${bedgraph_file%.sorted.bedgraph}.bigwig")"
    echo "Converting $bedgraph_file to $output_file"
    bedGraphToBigWig "$bedgraph_file" "$chrom_sizes" "$output_file"
done
