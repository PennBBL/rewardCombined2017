#!/bin/bash

#########################################################################################
#####################       Reward n477 Distortion Correction         ###################
#####################                 Lauren Beard                    ###################
#####################              lbeard@sas.upenn.edu               ###################
#####################                   09/08/2017                    ###################
#########################################################################################

# This script was written to create all the reward b0 maps
# It is just a rough for loop which runs Mark Elliot's dico_b0calc_v4_afgr.sh script
# AFGR edited Mark Elliots script to make sure it took the correct inputs

# Run through each subject and calcualte a b0 rps map for them
subjFile="/data/joy/BBL/projects/rewardAnalysisReproc/subjectLists/n477_scanid_bblid_date_datexscanid.csv"
subjLength=`cat ${subjFile} | wc -l`
baseOutputPath="/home/lbeard/b0//data/joy/BBL/studies/reward/processedData/b0mapwT2star/"
baseRawDataPath="/data/joy/BBL/studies/reward/rawData/"
baseExtractedPath="/data/joy/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006/"
scriptToCall="/data/joy/BBL/studies/reward/processedData/b0mapwT2star/b0/dico_b0calc_v4_afgr.sh"
forceScript="/data/joy/BBL/applications/scripts/bin/force_RPI.sh"  

for subj in `seq 1 ${subjLength}` ; do
  rndDig=${RANDOM}
  bblid=`sed -n "${subj}p" ${subjFile} | cut -f 2 -d ","`
  scanid=`sed -n "${subj}p" ${subjFile} | cut -f 1 -d ","`
  scandate=`sed -n "${subj}p" ${subjFile} | cut -f 3 -d ","`
  subjRawData="${baseRawDataPath}${bblid}/${scandate}x${scanid}"
  subjB0Maps=`find ${subjRawData} -name "b0_*" -type d`
  subjB0Maps1=`echo ${subjB0Maps} | cut -f 1 -d ' '`
  subjB0Maps2=`echo ${subjB0Maps} | cut -f 2 -d ' '`
  subjOutputDir="${baseOutputPath}/${bblid}/${scandate}x${scanid}/"
  mkdir -p ${subjOutputDir}
  rawT1=`find ${subjRawData}/t1/nifti -name "*nii.gz" -type f`
  ${forceScript} ${rawT1} /home/lbeard/b0/${bblid}/${scandate}x${scanid}/tmp${rndDig}.nii.gz
  rawT1="/home/lbeard/b0/${bblid}/${scandate}x${scanid}/tmp${rndDig}.nii.gz"
  extractedT1=`find ${baseExtractedPath}${bblid}/${scandate}x${scanid} -name "*Extracted*nii.gz"`
  if [ -f ${subjOutputDir}${bblid}_${scandate}x${scanid}_rpsmap.nii ] ; then
    echo "output already exists"
    echo "Skipping BBLID:${bblid}"
    echo "	   SCANID:${scanid}"
    echo "         DATE:${scandate}"
    echo "*************************" ; 
  else
    ${scriptToCall} ${subjOutputDir} ${subjB0Maps1}/dicom/ ${subjB0Maps2}/dicom/ ${rawT1} ${extractedT1}  
    for i in `ls ${subjOutputDir}` ; do
      mv ${subjOutputDir}${i} ${subjOutputDir}${bblid}_${scandate}x${scanid}${i} 
    done ;
    for i in `ls ${subjOutputDir}*nii` ; do 
      /share/apps/fsl/5.0.8/bin/fslchfiletype NIFTI_GZ ${i} ; 
    done   
  fi  
  rm ${rawT1} ;  
done
