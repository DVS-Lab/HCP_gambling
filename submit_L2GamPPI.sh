#!/bin/bash
#add echo, sleep to run two sets of script so computer isn't overloaded
#echo "sleeping for one hour"
#sleep 1h
for subj in 100307 100408 101107 101309 101915; do
  bash L2_Gam_PPI.sh $subj &
  sleep 1s
done
