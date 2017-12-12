#!/bin/bash

NCORES=28

for LIST in "Gam_Act 2" "Gam_PPI 7"; do
  set -- $LIST
  TYPE=$1
  NCOPES=$2

  #this is COPENUM in Hyden's files for L3 but it's same as C in L2_Gam_Act.sh file
  for C in `seq $NCOPES`; do
    echo $TYPE $C
    #manages the number of jobs and cores at any given time so you're always using to the max NCORES
    #compile non-matching processes and count how many there are
    #compare count to NCORES and if greater then sleep for 1m
    while [ $(ps -ef | grep -v grep | grep L3_Gam_all.sh | wc -l) -ge $NCORES ]; do
      sleep 1m
    done
    bash L3_Gam_all.sh $TYPE $C &
  done
done
