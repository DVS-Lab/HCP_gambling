#!/bin/bash

NCORES=28

#for subj in `cat sublist187.txt`; do
  #manages number of processes by comparing with NCORES
  #while [ $(ps -ef | grep -v grep | grep L2_Gam_Act.sh | wc -l) -ge #$NCORES ]; do
    #sleep 1m
  #done
  #bash L2_Gam_Act.sh $subj &
#done

#for subj in `cat sublist187.txt`; do
  #manages number of processes by comparing with NCORES
  #while [ $(ps -ef | grep -v grep | grep L2_Gam_PPI.sh | wc -l) -ge $NCORES ]; do
    #sleep 1m
  #done
  #bash L2_Gam_PPI.sh $subj &
#done

#hyden's version included comparison with DMN and ECN (network PPI)
#excluded for December round of analyses bc of time constraint
#double check this code because I changed it for EMOTION
for subj in `cat sublist187.txt`; do
    #Manages the number of jobs and cores
    while [ $(ps -ef | grep -v grep | grep L2_Gam_nPPI_netTC | wc -l) -ge $NCORES ]; do
        sleep 1m
    done
    bash L2_Gam_nPPI_netTC $subj &
done
