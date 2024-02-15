#!/bin/bash
# -*- coding: utf-8 -*-

##### Running smORRFer to analyze RIBO-seq data ########


# $1 - a list of analyzed samples
# $2 - type of analysis: TIS or RPF

# paths
script_path='/home/fesenkoi2/bin/smORFer-master'
data_path='/panfs/pan1/small_orf/EXPERIMENTAL/RIBOseq'


#### START ANALYSIS ####
while read -r line; do
    if [ "$2" = "TIS" ]; then
        ### TIS MODULE ANALYSIS
        echo "Analysing TIS data in $line"

        for file in $data_path/$line/tis_bam/*.bam; do
            echo "Get candidates for $file"

            ##### CALCULATE TIS FOR SMORFS ######
            #$script_path/modulC_TIS_analysis/run_moduleC.sh $data_path/$line/*smorf.bed $file
            echo "Overlapping results for smORFs"
            #Rscript $script_path/helper_scripts/overlap_candidates.R $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_candidates.txt $data_path/$line/*smorf.bed $data_path/$line/"$line"_smORFs_TISoverlapped.txt
            # Change offset
            #echo "Moving results"
            #mv $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_candidates.txt $data_path/$line/"$line"_smORFs_TIS_candidates.txt
            #mv $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_counts.txt $data_path/$line/"$line"_smORFs_TIS_counts.txt
            #rm -r $script_path/modulC_TIS_analysis/8_count_TIS/output
            #rm -r $script_path/modulC_TIS_analysis/7_get_start_codon/output

            # Change offset
            #$script_path/modulC_TIS_analysis/run_moduleCoffset.sh $data_path/$line/*smorf.bed $file
            #Rscript $script_path/helper_scripts/overlap_candidates18.R $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_candidates.txt $data_path/$line/*smorf.bed $data_path/$line/"$line"_smORFs_offset18_TISoverlapped.txt
            #echo "Moving results"
            #mv $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_candidates.txt $data_path/$line/"$line"_smORFs_offset18_TIS_candidates.txt
            #mv $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_counts.txt $data_path/$line/"$line"_smORFs_offset18_TIS_counts.txt
            #rm -r $script_path/modulC_TIS_analysis/8_count_TIS/output
            #rm -r $script_path/modulC_TIS_analysis/7_get_start_codon/output

            # All intergenic
            #$script_path/modulC_TIS_analysis/run_moduleC.sh $data_path/$line/*smorf_all.bed $file
            #Rscript $script_path/helper_scripts/overlap_candidates.R $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_candidates.txt $data_path/$line/*smorf_all.bed $data_path/$line/"$line"_smORFs_all_intergenic_TISoverlapped.txt
            #echo "Moving results"
            #mv $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_candidates.txt $data_path/$line/"$line"_smORFs_all_intergenic_TIS_candidates.txt
            #mv $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_counts.txt $data_path/$line/"$line"_smORFs_all_intergenic_TIS_counts.txt
            #rm -r $script_path/modulC_TIS_analysis/8_count_TIS/output
            #rm -r $script_path/modulC_TIS_analysis/7_get_start_codon/output

            # Corrected start
            #$script_path/modulC_TIS_analysis/run_moduleC.sh $data_path/$line/*smorf_corrected.bed $file
            #Rscript $script_path/helper_scripts/overlap_candidates.R $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_candidates.txt $data_path/$line/*smorf_corrected.bed $data_path/$line/"$line"_smORFs_all_corrected_TISoverlapped.txt
            #echo "Moving results"
            #mv $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_candidates.txt $data_path/$line/"$line"_smORFs_all_corrected_TIS_candidates.txt
            #mv $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_counts.txt $data_path/$line/"$line"_smORFs_all_corrected_TIS_counts.txt
            #rm -r $script_path/modulC_TIS_analysis/8_count_TIS/output
            #rm -r $script_path/modulC_TIS_analysis/7_get_start_codon/output

          
            ##### CALCULATE TIS FOR ANNOTATED FEATURES ######
            #$script_path/modulC_TIS_analysis/run_moduleC.sh $data_path/$line/*_combined_annot.bed $file
            #echo "Overlapping results for proteins"
            #Rscript $script_path/helper_scripts/overlap_candidates.R $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_candidates.txt $data_path/$line/*_combined_annot.bed $data_path/$line/"$line"_annot_TISoverlapped.txt
            #echo "Moving results"
            #mv $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_candidates.txt $data_path/$line/"$line"_annot_TIS_candidates.txt
            #mv $script_path/modulC_TIS_analysis/8_count_TIS/output/TIS_counts.txt $data_path/$line/"$line"_annot_TIS_counts.txt
            #rm -r $script_path/modulC_TIS_analysis/8_count_TIS/output
            #rm -r $script_path/modulC_TIS_analysis/7_get_start_codon/output


        done
    fi
    
    if [ "$2" = "RPF" ]; then
        ### RFP MODULE ANALYSIS
        echo "Analysing RFP data in $line"
        if [ -n "$(find "$data_path/$line/ribo_bam" -maxdepth 1 -type f -name "$line"_combined.bam -print -quit)" ]; then
            echo "Combined file exists"
        else
            echo "Create combined file..."
            samtools merge --threads 10 -o $data_path/$line/ribo_bam/"$line"_combined.bam $data_path/$line/ribo_bam/*.bam
            samtools index $data_path/$line/ribo_bam/"$line"_combined.bam
            echo "Combined file created"
            echo "+++++++++"
        fi
        echo "Start analysis"
        echo "Run count_RPF"
        ##### CALCULATE RPF FOR SMORFS ######
        $script_path/modulB_RPF_analysis/4_count_RPF/count_RPF.sh $data_path/$line/*smorf.bed $data_path/$line/ribo_bam/"$line"_combined.bam
        mv $script_path/modulB_RPF_analysis/4_count_RPF/output/RPF_counts.txt $data_path/$line/"$line"_RPF_smORFs_counts.txt
        mv $script_path/modulB_RPF_analysis/4_count_RPF/output/RPF_high.bed $data_path/$line/"$line"_smORFs_RPF_high.bed
        mv $script_path/modulB_RPF_analysis/4_count_RPF/output/RPF_translated.txt $data_path/$line/"$line"_smORFs_RPF_translated.txt

        ##### CALCULATE RPF FOR ALL SMORFS ######
        $script_path/modulB_RPF_analysis/4_count_RPF/count_RPF.sh $data_path/$line/*smorf_all.bed $data_path/$line/ribo_bam/"$line"_combined.bam
        mv $script_path/modulB_RPF_analysis/4_count_RPF/output/RPF_counts.txt $data_path/$line/"$line"_RPF_allsmORFs_counts.txt
        mv $script_path/modulB_RPF_analysis/4_count_RPF/output/RPF_high.bed $data_path/$line/"$line"_allsmORFs_RPF_high.bed
        mv $script_path/modulB_RPF_analysis/4_count_RPF/output/RPF_translated.txt $data_path/$line/"$line"_allsmORFs_RPF_translated.txt

        ##### CALCULATE RPF FOR ANNOTATED FEATURES ######
        $script_path/modulB_RPF_analysis/4_count_RPF/count_RPF.sh $data_path/$line/*_combined_annot.bed $data_path/$line/ribo_bam/"$line"_combined.bam
        mv $script_path/modulB_RPF_analysis/4_count_RPF/output/RPF_counts.txt $data_path/$line/"$line"_RPF_annot_counts.txt
        mv $script_path/modulB_RPF_analysis/4_count_RPF/output/RPF_high.bed $data_path/$line/"$line"_annot_high.bed
        mv $script_path/modulB_RPF_analysis/4_count_RPF/output/RPF_translated.txt $data_path/$line/"$line"_annot_RPF_translated.txt

       
    fi

done < $1



