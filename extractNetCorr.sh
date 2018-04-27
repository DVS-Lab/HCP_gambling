#!/bin/bash

mask=/data/Analysis/L3_main/L3_Gam_Act_1.gfeat/mask.nii.gz

for n in ECN DMN; do
	netimg=/data/HCP_gambling/masks/PNAS_2mm_${n}.nii.gz
	for i in `ls -1 /data/Analysis/*/MNINonLinear/Results/L2_Gam_nPPI_${n}.gfeat/cope3.feat/stats/zstat1.nii.gz`; do
		corr=`fslcc -m ${mask} ${netimg} ${i} | awk '{print $3}'`
		echo $corr >> netcorr_${n}.txt
	done
done







