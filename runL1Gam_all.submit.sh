#!/bin/bash

#L1_Gam_Act $subj $run
for subj in `cat sublist450.txt`; do
  for run in LR RL; do
    #manages number of processes compared to NCORES
    NCORES=28
    while [ $(ps -ef | grep -v grep | grep L1_Gam_Act.sh | wc -l) -ge $NCORES ]; do
       sleep 1m
    done
    bash L1_Gam_Act.sh $run $subj &
  done
done

#L1_Gam_PPI $subj $run
#for subj in `cat sublist450.txt`; do
  #for run in LR RL; do
    #manages number of processes compared to NCORES
    #NCORES=28
    #while [ $(ps -ef | grep -v grep | grep L1_Gam_PPI.sh | wc -l) -ge $NCORES ]; do
       #sleep 1m
    #done
    #bash L1_Gam_PPI.sh $run $subj &
  #done
#done

#L1_Gam_nPPI $subj $run
#for subj in `cat sublist450.txt`; do
  #for run in RL LR; do
    #Manages the number of jobs and cores
    #NCORES=28
    #while [ $(ps -ef | grep -v grep | grep runL1Gam_nPPI_netTC | wc -l) -ge $NCORES ]; do
       #sleep 1m
    #done
    #bash runL1Gam_nPPI_netTC $run $subj &
  #done
#done
