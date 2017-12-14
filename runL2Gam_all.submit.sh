#!/bin/bash

NCORES=30

for subj in `cat sublist.txt`; do
  #manages number of processes by comparing with NCORES
  while [ $(ps -ef | grep -v grep | grep L2_Gam_Act.sh | wc -l) -ge $NCORES ]; do
    sleep 1m
  done
  bash L2_Gam_Act.sh $subj &
done

for subj in `cat sublist.txt`; do
  #manages number of processes by comparing with NCORES
  while [ $(ps -ef | grep -v grep | grep L2_Gam_PPI.sh | wc -l) -ge $NCORES ]; do
    sleep 1m
  done
  bash L2_Gam_PPI.sh $subj &
done

#hyden's version included comparison with DMN (network PPI)
#excluding for this round of analyses bc of time constraint
#for subj in `cat sublist.txt`; do
    #Manages the number of jobs and cores
    #while [ $(ps -ef | grep -v grep | grep L2_Gam_nPPI.sh | wc -l) -ge $NCORES ]; do
        #sleep 1m
    #done
    #bash L2_Gam_nPPI.sh $subj &
#done
