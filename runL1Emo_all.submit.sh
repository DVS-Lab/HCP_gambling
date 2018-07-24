#!/bin/bash

#L1_Emo_Act $subj $run
for subj in `cat sublist450.txt`; do
  for run in LR RL; do
    #manages number of processes compared to NCORES
    NCORES=28
    while [ $(ps -ef | grep -v grep | grep L1_Emo_Act | wc -l) -ge $NCORES ]; do
       sleep 1m
    done
    bash L1_Emo_Act $run $subj &
  done
done

#L1_Emo_PPI $subj $run
#for subj in `cat sublist175`; do
  #for run in LR RL; do
    #manages number of processes compared to NCORES
    #NCORES=28
    #while [ $(ps -ef | grep -v grep | grep L1_Emo_PPI.sh | wc -l) -ge $NCORES ]; do
       #sleep 1m
    #done
    #bash L1_Emo_PPI.sh $run $subj &
  #done
#done

#L1_Emo_nPPI $subj $run
#for subj in `cat sublist175`; do
  #for run in RL LR; do
    #Manages the number of jobs and cores
    #NCORES=28
    #while [ $(ps -ef | grep -v grep | grep L1_Emo_nPPI.sh | wc -l) -ge $NCORES ]; do
       #sleep 1m
    #done
    #bash L1_Emo_nPPI.sh $run $subj &
  #done
