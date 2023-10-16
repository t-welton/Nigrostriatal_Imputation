# Setup
ROOT="~"
GWAS_TOOLS="$ROOT/summary-gwas-imputation/src"
METAXCAN="$ROOT/MetaXcan/software"
DATA="$ROOT/data"
OUTPUT="$ROOT/outputs_nigro"
MODEL="$ROOT/models"
LIFTOVER="$ROOT/liftover"
REFERENCE="$ROOT/reference_panel"

mkdir $OUTPUT
mkdir $OUTPUT/dis
mkdir $OUTPUT/rep

echo "ROOT: $ROOT"
echo "GWAS_TOOLS: $GWAS_TOOLS"
echo "METAXCAN: $METAXCAN"
echo "DATA: $DATA"
echo "OUTPUT: $OUTPUT"
echo "MODEL: $MODEL"
echo "LIFTOVER: $LIFTOVER"
echo "REFERENCE: $REFERENCE"

for idp in 0003.txt.gz 0004.txt.gz 0005.txt.gz 0006.txt.gz 0015.txt.gz 0016.txt.gz 0033.txt.gz 0034.txt.gz 1440.txt.gz 1441.txt.gz 1442.txt.gz 1443.txt.gz
do
	# harmonisation
	echo "~~~~~~~~~~ discovery harmonisation idp $idp ~~~~~~~~~~"
	python $GWAS_TOOLS/gwas_parsing.py \
		-gwas_file $DATA/dis/${idp} \
		-liftover $LIFTOVER/hg19ToHg38.over.chain.gz \
		-output_column_map chr chromosome \
		-output_column_map rsid variant_id \
		-output_column_map pos position \
		-output_column_map a1 non_effect_allele \
		-output_column_map a2 effect_allele \
		-output_column_map beta effect_size \
		-output_column_map se standard_error \
		-output_column_map "pval(-log10)" pminuslog10 \
		--insert_value sample_size 21000 \
		--insert_value n_cases 21000 \
		--chromosome_format \
		-separator " " \
		-output_order variant_id panel_variant_id chromosome position effect_allele non_effect_allele pminuslog10 pvalue zscore effect_size standard_error sample_size n_cases frequency \
		-snp_reference_metadata $REFERENCE/variant_metadata.txt.gz METADATA \
		-output $OUTPUT/dis/${idp}_harmonised.txt.gz \
        --keep_all_original_entries
done

for idp in 0003.txt.gz 0004.txt.gz 0005.txt.gz 0006.txt.gz 0015.txt.gz 0016.txt.gz 0033.txt.gz 0034.txt.gz 1440.txt.gz 1441.txt.gz 1442.txt.gz 1443.txt.gz
do
	# harmonisation
	echo "~~~~~~~~~~ replication harmonisation idp $idp ~~~~~~~~~~"
	python $GWAS_TOOLS/gwas_parsing.py \
		-gwas_file $DATA/rep/${idp} \
		-liftover $LIFTOVER/hg19ToHg38.over.chain.gz \
		-output_column_map chr chromosome \
		-output_column_map rsid variant_id \
		-output_column_map pos position \
		-output_column_map a1 non_effect_allele \
		-output_column_map a2 effect_allele \
		-output_column_map beta effect_size \
		-output_column_map se standard_error \
		-output_column_map "pval(-log10)" pminuslog10 \
		--insert_value sample_size 11000 \
		--insert_value n_cases 11000 \
		--chromosome_format \
		-separator " " \
		-output_order variant_id panel_variant_id chromosome position effect_allele non_effect_allele pminuslog10 pvalue zscore effect_size standard_error sample_size n_cases frequency \
		-snp_reference_metadata $REFERENCE/variant_metadata.txt.gz METADATA \
		-output $OUTPUT/rep/${idp}_harmonised.txt.gz \
        --keep_all_original_entries
done

exit

for idp in 0003.txt.gz 0004.txt.gz 0005.txt.gz 0006.txt.gz 0015.txt.gz 0016.txt.gz 0033.txt.gz 0034.txt.gz 1440.txt.gz 1441.txt.gz 1442.txt.gz 1443.txt.gz
do
	# imputation
	for chr in {1..22}
	do
		for sub_batch in {0..9}
		do
			echo "~~~~~~~~~~ Discovery imputation idp ${idp} chromosome ${chr} sub-batch ${sub_batch} ~~~~~~~~~~"
			python $GWAS_TOOLS/gwas_summary_imputation.py \
				-by_region_file $REFERENCE/eur_ld.bed.gz \
				-gwas_file $OUTPUT/dis/${idp}_harmonised.txt.gz \
				-parquet_genotype $REFERENCE/chr${chr}.variants.parquet \
				-parquet_genotype_metadata $REFERENCE/variant_metadata.parquet \
				-window 100000 \
				-parsimony 7 \
				-chromosome ${chr} \
				-regularization 0.1 \
				-frequency_filter 0.01 \
				-sub_batches 10 \
				-sub_batch ${sub_batch} \
				--standardise_dosages \
				-output $OUTPUT/dis/${idp}_harmonised_imputed_chr${chr}_sb${sub_batch}_reg0.1_ff0.01_by_region.txt.gz
		done
	done
done

for idp in 0003.txt.gz 0004.txt.gz 0005.txt.gz 0006.txt.gz 0015.txt.gz 0016.txt.gz 0033.txt.gz 0034.txt.gz 1440.txt.gz 1441.txt.gz 1442.txt.gz 1443.txt.gz
do
	# imputation
	for chr in {1..22}
	do
		for sub_batch in {0..9}
		do
			echo "~~~~~~~~~~ Replication imputation idp ${idp} chromosome ${chr} sub-batch ${sub_batch} ~~~~~~~~~~"
			python $GWAS_TOOLS/gwas_summary_imputation.py \
				-by_region_file $REFERENCE/eur_ld.bed.gz \
				-gwas_file $OUTPUT/rep/${idp}_harmonised.txt.gz \
				-parquet_genotype $REFERENCE/chr${chr}.variants.parquet \
				-parquet_genotype_metadata $REFERENCE/variant_metadata.parquet \
				-window 100000 \
				-parsimony 7 \
				-chromosome ${chr} \
				-regularization 0.1 \
				-frequency_filter 0.01 \
				-sub_batches 10 \
				-sub_batch ${sub_batch} \
				--standardise_dosages \
				-output $OUTPUT/rep/${idp}_harmonised_imputed_chr${chr}_sb${sub_batch}_reg0.1_ff0.01_by_region.txt.gz
		done
	done
done

exit

# merge imputed sumstats batches into one big file
for idp_no in 137 #{137..164} 194 211
do
	python $GWAS_TOOLS/gwas_summary_imputation_postprocess.py \
		-gwas_file $OUTPUT/0${idp_no}_harmonised.txt.gz \
		-folder $OUTPUT \
		-pattern 0${idp_no}_harmonised_imputed_.* \
		-parsimony 7 \
		-output $OUTPUT/0${idp_no}_harmonised_merged.txt.gz
done

exit

# Run S-PrediXcan
for idp_no in 137 #{137..164} 194 211
do
	python $METAXCAN/SPrediXcan.py \
		--gwas_file $DATA/0${idp_no}.txt \
		--snp_column rsid \
		--effect_allele_column a1 \
		--non_effect_allele_column a2 \
		--beta_column beta \
		--se_column se \
		--chromosome_column chr \
		--model_db_path $MODEL/mashr_Brain_Cerebellum.db \
		--covariance $MODEL/mashr_Brain_Cerebellum.txt.gz \
		--output_file $OUTPUT/${idp_no}_output.csv
done
	
	
