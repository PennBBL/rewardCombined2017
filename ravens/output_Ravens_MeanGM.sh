subjects=$(cat /data/jux/BBL/projects/rewardAnalysisReproc/subjectLists/n491_bblid_datexscanid_scanid.csv); 

for i in $subjects; do 
    bblid=$(echo $i|cut -d',' -f1); 
    datexscanid=$(echo $i|cut -d',' -f2);
    mean=`cat /data/joy/BBL/studies/reward/processedData/structural/ravens/${bblid}/${datexscanid}/*MeanGM_RAVENS2.txt`;
    spaCorr=`fslcc -p 10 --noabs /data/joy/BBL/studies/reward/processedData/structural/ravens/${bblid}/${datexscanid}/*_templateInSubjectSpace.nii.gz /data/joy/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006/${bblid}/${datexscanid}/antsCT/*ExtractedBrain0N4.nii.gz`;
    spaCorr=$(echo $spaCorr | cut -d' ' -f3);
echo ${bblid},${datexscanid},${mean},${spaCorr} >> /data/jux/BBL/projects/rewardAnalysisReproc/qa/ravens/n491_Ravens_MeanCT.csv; 
done
