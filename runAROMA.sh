#!/bin/bash

#run dos2unix recursively
#find . -type f -print0 | xargs -0 dos2unix

#testing to begin running EMOTION task
task=EMOTION
run=$1
subj=$2

BASEDIR=`pwd`
cd ..
MAINDATADIR=/s3/hcp
MAINOUTPUTDIR=`pwd`/Analysis
cd $BASEDIR

#make paths to reflect lab directory
DATADIR=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}
OUTPUTDIR=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}

mkdir -p $OUTPUTDIR
OUTPUT=${OUTPUTDIR}/smoothing

#check AROMA output, comment out sanity check before running full dataset
#SANITY CHECK to avoid redoing
#force removal of feat folder with -f flag
if [ -e ${OUTPUT}.feat/ICA_AROMA/denoised_func_data_nonaggr.nii.gz ]; then
  echo "runAROMA has been run for $run $subj"
  exit
else
  echo "re-running $subj on run $run"
  rm -rf ${OUTPUT}.feat
fi

DATA=${DATADIR}/tfMRI_${task}_${run}.nii.gz
NVOLUMES=`fslnvols ${DATA}`

#find and replace: run feat for smoothing
ITEMPLATE=${BASEDIR}/templates/prep_aroma.fsf
OTEMPLATE=${OUTPUTDIR}/Prep_Aroma.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
<$ITEMPLATE> ${OTEMPLATE}

#runs feat
feat ${OTEMPLATE}

#set input and output for bet
inputmask=${OUTPUT}.feat/mean_func.nii.gz
aromamask=${OUTPUT}.feat/betmask

#run bet to create mask instead of using default feat output
bet $inputmask $aromamask -f 0.3 -n -m -R

#create variables for ICA AROMA (splitmotion)
myinput=${OUTPUT}.feat/filtered_func_data.nii.gz
myoutput=${OUTPUT}.feat/ICA_AROMA
mcfile=${OUTPUTDIR}/motion_6col.txt
rawmotion=${DATADIR}/Movement_Regressors.txt

#deleting any preexisting files
#rm -rf $myoutput

#motion regressors for each subject
python splitmotion.py $rawmotion $mcfile

#running AROMA
#add -m flag that uses mask.nii.gz from bet output
python ${BASEDIR}/ICA-AROMA-master/ICA_AROMA_Nonormalizing.py -in $myinput -out $myoutput -mc $mcfile -m ${aromamask}_mask.nii.gz
