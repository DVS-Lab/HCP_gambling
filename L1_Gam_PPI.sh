#!/bin/bash

task=GAMBLING
run=$1
subj=$2

BASEDIR=`pwd`
cd ..
MAINDATADIR=/s3/hcp
MAINOUTPUTDIR=`pwd`/Analysis
cd $BASEDIR

OUTPUT=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_PPI
DATA=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_Act.feat/filtered_func_data.nii.gz
NVOLUMES=`fslnvols ${DATA}`

#checking L1 output
#comment out sanity check when running full dataset
#SANITY CHECK
#if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
  #echo "L1_Gam_PPI has been run for $subj $run"
  #exit
#else
  #rm -rf ${OUTPUT}.feat
#fi

#EV files
EVLOSS=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/EVs/loss.txt
EVWIN=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/EVs/win.txt

#time course and mask for OFC as seed region
TIMECOURSE=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/OFC_tc.txt
MASK=${BASEDIR}/masks/rOFC_Reward_seed.nii.gz
fslmeants -i $DATA -o $TIMECOURSE -m $MASK

#find and replace, make sure no spaces after backslash or bash won't concatenate
#run feat for smoothing
ITEMPLATE=${BASEDIR}/templates/L1GamPPI.fsf
OTEMPLATE=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_PPI.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
-e 's@EVLOSS@'$EVLOSS'@g' \
-e 's@EVWIN@'$EVWIN'@g' \
-e 's@TIMECOURSE@'$TIMECOURSE'@g' \
<$ITEMPLATE> $OTEMPLATE

#runs feat on output template
feat $OTEMPLATE

#delete unused files
rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
