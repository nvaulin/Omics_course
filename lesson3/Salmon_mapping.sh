# Salmon_mapping.sh script does the following:
# for each SAMPLE in 'samples.txt':
#    process a corresponding fastq files with fastp
#    map the resulting file to the transcriptome using salmon quant

# edit necessary lines

while read SAMPLE; do
	echo "Running sample ${SAMPLE}"

	FASTQ1=${SAMPLE}.R1.fastq.gz                                    # fastq names
	FASTQ2=${SAMPLE}.R2.fastq.gz

	FASTQ1_PATH="/home/i.pletenev/l3_data/${FASTQ1}"                    # <- edit the path to your fastqs
	FASTQ2_PATH="/home/i.pletenev/l3_data/${FASTQ2}"
	
	#######################
	##  PART1 Run fastp  ##
 	#######################

	FASTQ1_FILT=${SAMPLE}.R1.filt.fastq.gz                          # fastp output
	FASTQ2_FILT=${SAMPLE}.R2.filt.fastq.gz

	FASTQ1_FILT_PATH="/home/Nikita.Vaulin/Omics/lesson3/filtered/${FASTQ1_FILT}" # <- edit the path to your filtered fastqs
	FASTQ2_FILT_PATH="/home/Nikita.Vaulin/Omics/lesson3/filtered/${FASTQ2_FILT}"

	fastp -i ${FASTQ1_PATH} -I ${FASTQ2_PATH} -o ${FASTQ1_FILT_PATH} -O ${FASTQ2_FILT_PATH} -h ${SAMPLE}.fastp.html -j ${SAMPLE}.fastp.json

	#####################################
	##  PART2 Map samples with Salmon  ##
	#####################################

	SALMON_TRANSCRIPTOME_INDEX_DIR="/home/Nikita.Vaulin/Omics/lesson3/transcriptome_index/transcriptome/" # <- add directory with transcriptome index
	SALMON_OUT_DIR="/home/Nikita.Vaulin/Omics/lesson3/salmon/${SAMPLE}"                 # <- add directory to store salmon output

 	salmon quant -i ${SALMON_TRANSCRIPTOME_INDEX_DIR} \
 		-l A \
 		-1 ${FASTQ1_FILT_PATH} \
 		-2 ${FASTQ2_FILT_PATH} \
 		-p 2 \
 		-o ${SALMON_OUT_DIR} \
 		--useVBOpt \
 		--seqBias \
 		--validateMappings

done < samples.txt
