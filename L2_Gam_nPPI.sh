#!/bin/bash

BASEDIR=`pwd`
cd ..
MAINOUTPUTDIR=`pwd`/Analysis
cd $BASEDIR

##bash L2_Gam_nPPI.sh $subj
subj=$1

for NET in DMN; do
  INPUT01=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_LR/L1_Gam_nPPI_${NET}.feat
  INPUT02=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_RL/L1_Gam_nPPI_${NET}.feat
  OUTPUT=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/L2_Gam_nPPI_${NET}

  #checking L2 output
  #remove output files if they exist to avoid +.gfeat directories; g signifies higher level
  #remove sanity check when running full dataset
  #SANITY CHECK
  NCOPES=7 #check last cope since they are done sequentially
  #if [ -e ${OUTPUT}.gfeat/cope${NCOPES}.feat/cluster_mask_zstat1.nii.gz ]; then
    #echo "L2_Gam_nPPI has been run for $subj $NET"
    #exit
  #else
    #rm -rf ${OUTPUT}.gfeat
  #fi

  for run in LR RL; do
    rm -rf ${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_${run}/L1_Gam_nPPI_${NET}.feat/reg
    mkdir -p ${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_${run}/L1_Gam_nPPI_${NET}.feat/reg
    ln -s $FSLDIR/etc/flirtsch/ident.mat ${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_${run}/L1_Gam_nPPI_${NET}.feat/reg/example_func2standard.mat
    ln -s $FSLDIR/etc/flirtsch/ident.mat ${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_${run}/L1_Gam_nPPI_${NET}.feat/reg/standard2example_func.mat
    ln -s $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz ${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_${run}/L1_Gam_nPPI_${NET}.feat/reg/standard.nii.gz
  done

  #find and replace
  ITEMPLATE=${BASEDIR}/templates/L2GamPPI.fsf
  OTEMPLATE=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/L2_Gam_nPPI_${NET}.fsf
  sed -e 's@OUTPUT@'$OUTPUT'@g' \
  -e 's@INPUT01@'$INPUT01'@g' \
  -e 's@INPUT02@'$INPUT02'@g' \
  <$ITEMPLATE> $OTEMPLATE

  #runs feat on output template
  feat $OTEMPLATE

  #remove files we won't be using
  for C in `seq $NCOPES`; do
    rm -rf ${OUTPUT}.gfeat/cope${C}.feat/filtered_func_data.nii.gz
    rm -rf ${OUTPUT}.gfeat/cope${C}.feat/var_filtered_func_data.nii.gz
  done
done
