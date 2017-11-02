#!/bin/bash
task=GAMBLING
for run in LR RL; do
  for subj in 100307 100408 101107 101309 101915; do
    bash runAROMA.sh $subj $task $run &
    sleep 1s
  done
  sleep 2h
done
