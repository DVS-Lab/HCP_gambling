#!/bin/bash
#echo "sleeping for one hour"
#sleep 1h
task=GAMBLING
for run in LR RL; do
  for subj in 100307 100408 101107 101309 101915; do
    bash L1_Gam_PPI.sh $subj $task $run &
    sleep 1s
  done
  sleep 45m
done
