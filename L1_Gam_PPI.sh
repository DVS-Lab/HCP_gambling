#!/bin/bash

task=GAMBLING
run=$1
subj=$2

BASEDIR=`pwd`
cd ..
MAINDATADIR=`pwd`/Data
MAINOUTPUTDIR=`pwd`/output
cd $BASEDIR

#datadir=mnt/c/Users/tue90350/Desktop/data/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}

OUTPUT=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_PPI
DATA=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_Act/filtered_func_data.nii.gz
NVOLUMES=`fslnvols ${DATA}`
#DATA=${datadir}/smoothing.feat/ICA_AROMA/denoised_func_data_nonaggr.nii.gz
#recursively remove files
rm -rf ${OUTPUT}.feat

#EV files
EVLOSS=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/EVs/loss.txt
EVWIN=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/EVs/win.txt
TIMECOURSE=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/OFC_tc.txt
MASK=$BASEDIR/masks/rOFC_Reward_seed.nii.gz
fslmeants -i $DATA -o $TIMECOURSE -m $MASK

#find and replace
ITEMPLATE=${BASEDIR}/templates/L1_Gam_PPI.fsf
OTEMPLATE=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_PPI.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
-e 's@EVLOSS@'$EVLOSS'@g' \
-e 's@EVWIN@'$EVWIN'@g' \
-e 's@TIMECOURSE@'$TIMECOURSE'@g' \
<$ITEMPLATE> $OTEMPLATE

feat $OTEMPLATE

#delete unused files
#rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz, correct for time series
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
