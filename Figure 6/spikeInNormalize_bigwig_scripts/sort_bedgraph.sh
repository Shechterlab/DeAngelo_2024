#!/bin/bash

#SBATCH -p normal
#SBATCH --job-name=sort_bedgraph
#SBATCH --mail-type=NONE
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5gb
#SBATCH --time=24:00:00
#SBATCH --output=sorted_bedgraph.log


for file in `pwd`/*.bedgraph; do
    LC_COLLATE=C sort -k1,1 -k2,2n "$file" > "${file%.bedgraph}.sorted.bedgraph"
done
