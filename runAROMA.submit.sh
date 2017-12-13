#!/bin/bash

BASEDIR=`pwd`
cd ..
MAINDATADIR=/s3/hcp
MAINOUTPUTDIR=`pwd`/Analysis
cd $BASEDIR

for subj in `cat sublist.txt`; do
  for run in LR RL; do
    #manage number of processes vs NCORES
    NCORES=30
    while [ $(ps -ef | grep -v grep | grep runAROMA.sh | wc -l) -ge $NCORES ]; do
      sleep 1m
    done
    bash runAROMA.sh $run $subj &
    #echo "running $run $subj"
    sleep 1
  done
done

#bash runL1Gam_all.submit.sh
