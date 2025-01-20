#!/bin/bash
for file in `pwd`/*.markdup.sorted.bedgraph; do
    mv $file ${file%.markdup.sorted.bedgraph}.sizefactoradjusted.bedgraph
done

