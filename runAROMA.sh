#!/bin/bash

BASEDIR=`pwd`
cd ..
MAINDATADIR=`pwd`/Data
MAINOUTPUTDIR=`pwd`/Analysis
cd $BASEDIR

#bash runAROMA.sh $subj $run
#insert task when testing without wrapper
task=GAMBLING
run=$1
subj=$2

#make paths to reflect lab directory
DATADIR=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}
OUTPUTDIR=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}

mkdir -p $OUTPUTDIR
OUTPUT=${OUTPUTDIR}/smoothing

#check AROMA output, comment out sanity check before running full dataset
#SANITY CHECK to avoid redoing
if [ -e ${OUTPUT}.feat/ICA_AROMA/denoised_func_data_nonaggr.nii.gz ]; then
  echo "runAROMA has been run"
  exit
else
  #echo "re-running $subj on run $run"
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

#create variables for ICA AROMA (splitmotion)
myinput=${OUTPUT}.feat/filtered_func_data.nii.gz
myoutput=${OUTPUT}.feat/ICA_AROMA
mcfile=${OUTPUTDIR}/motion_6col.txt
rawmotion=${DATADIR}/Movement_Regressors.txt

#deleting any preexisting files
rm -rf $myoutput

#run python
python splitmotion.py $rawmotion $mcfile

#running AROMA
python ${BASEDIR}/ICA-AROMA-master/ICA_AROMA_Nonormalizing.py -in $myinput -out $myoutput -mc $mcfile

#deleting temp file? check this
#rm -rf /tmp/hcp-openaccess/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/tfMRI_${task}_${run}.nii.gz
