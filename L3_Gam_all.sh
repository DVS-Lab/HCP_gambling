#!/bin/bash

##bash L3_Gam_all.sh $TYPE $C
TYPE=$1
C=$2

BASEDIR=`pwd`
cd ..
MAINDATADIR=`pwd`/Data
MAINOUTPUTDIR=`pwd`/Analysis
cd $BASEDIR

OUTPUT=${MAINOUTPUTDIR}/L3_${TYPE}_${C}

#check L3 output; avoid running analyses twice/overwriting
#remove sanity check when running full dataset
#SANITY CHECK WILL ONLY SHOW SCRIPT WORKS IF THE OUTPUT FOLDER DOES NOT ALREADY EXIST
if [ -e ${OUTPUT}.gfeat/cope1.feat/cluster_mask_zstat1.nii.gz ]; then
  echo "L3_Gam has been run for $TYPE $C"
  exit
else
  rm -rf ${OUTPUT}.gfeat
fi

#find and replace
ITEMPLATE=${BASEDIR}/templates/L3Gam.fsf
OTEMPLATE=${MAINOUTPUTDIR}/L3_${TYPE}_${C}.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@TYPE@'$TYPE'@g' \
-e 's@C@'$C'@g' \
<$ITEMPLATE> $OTEMPLATE

#runs feat on output template
feat $OTEMPLATE

# delete old stuff
rm -rf ${OUTPUT}.gfeat/cope1.feat/filtered_func_data.nii.gz
rm -rf ${OUTPUT}.gfeat/cope1.feat/var_filtered_func_data.nii.gz
