#!/bin/bash -e

# Create horizontla means for column, multi-fluid cases, consistent with
# horizontal means of other cases

# Calculate conditional averages and horizontal means for single fluid cases
./scripts/condition.sh .
./scripts/plothMeans.sh .

./scripts/heatTransport.sh .
mkdir -p plots
gmtPlot scripts/heatTransport.gmt

