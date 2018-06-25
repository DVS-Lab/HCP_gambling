#!/bin/bash

task=GAMBLING
run=$1
subj=$2

BASEDIR=`pwd`
cd ..
MAINDATADIR=/s3/hcp
MAINOUTPUTDIR=`pwd`/Analysis
cd $BASEDIR

#replaced RSNmap with 8 mask files from PNAS
for RSNmap in ECN; do

  OUTPUT=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_nPPI_netTC_${RSNmap}
  DATA=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_Act.feat/filtered_func_data.nii.gz
  NVOLUMES=`fslnvols ${DATA}`

  #checking L1 output
  #comment out sanity check when running full dataset
  #SANITY CHECK
  if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
    echo "L1_Gam_nPPI has been run for $subj $run $RSNmap"
    exit
  else
    rm -rf ${OUTPUT}.feat
  fi

  #EV files
  EVLOSS=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/EVs/loss.txt
  EVWIN=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/EVs/win.txt

  #generate mask's timecourse
  #DMN ECN and 8 new masks
  NET=${BASEDIR}/masks/PNAS_2mm_${RSNmap}.nii.gz
  MASK=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_Act.feat/mask
  TIMECOURSE=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_Act.feat/net_${RSNmap}_tc.txt
  fsl_glm -i $DATA -d $NET -o $TIMECOURSE --demean -m $MASK

  #find and replace: run feat for smoothing
  ITEMPLATE=${BASEDIR}/templates/L1Gam_netECN.fsf
  OTEMPLATE=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_nPPI_net${RSNmap}.fsf
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

done
