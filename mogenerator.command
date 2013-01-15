#!/bin/bash -x

############################################################################################################################
###
###		Mogenerator.command
###
###		Managed Object Generator Build Script.
###		Implements generation gap codegen pattern for Core Data.
###		http://rentzsch.github.com/mogenerator/
###		
###		Copyright (c) 2012 Kevin Ross. All rights reserved.
###
###		Mutator:		Mutated:		Mutation:
###		--------		--------		---------
###		Kross			02.01.12		Initial Version
###		Kross			01.02.13		Fixed script to work with paths that contain special characters
###
############################################################################################################################



REQUIRE_MOGEN=0
LEVEL="warning"

if [ $REQUIRE_MOGEN -eq 1 ]; then
	LEVEL="error"
fi


MOGEN=`which mogenerator`

if [ ! $MOGEN ]; then
echo "Searching for mogenerator."
MOGEN=`find /usr -name mogenerator`
fi

if [ ! $MOGEN ]; then
echo "$LEVEL: Could not find mogenerator... skipping build phase."
echo "$LEVEL: #########################################################################################################"
echo "$LEVEL: Without mogenerator installed the build will not re-generate the custom base-classes from the data model!"
echo "$LEVEL: Consider downloading mogenerator from http://rentzsch.github.com/mogenerator"
echo "$LEVEL: #########################################################################################################"
exit 0
fi


GMGenerateFromModel() 
{
	args=("$@")
	
	argc="${#args[@]}"
	echo "argc=${argc}"
	
	for MODEL_PATH in "${args[@]}" 
	do
	:

	## Paths
	MODEL_DIR=`dirname "${MODEL_PATH}"`
	MODEL_DIR=`dirname "${MODEL_DIR}"`  ## do it again...
	MACHINE_DIR="${MODEL_DIR}/Generated"
	# echo "MACHINE_DIR=${MACHINE_DIR}"

	# Check the modification date of the data model.
	MODEL_MODIFICATION_TIME=`stat -f "%m" "${MODEL_PATH}/contents"`
	
	GENERATED_FILES=(`ls -tU "${MACHINE_DIR}"`)
	
	NUMBER_OF_FILES="${#GENERATED_FILES[@]}"
	# echo "NUMBER_OF_FILES = ${NUMBER_OF_FILES}"
	
	if [ $NUMBER_OF_FILES -gt 0 ]; then
	
		MOST_RECENT_CHANGED_FILE="${MACHINE_DIR}/${GENERATED_FILES[0]}"

		# echo "MOST_RECENT_CHANGED_FILE = ${MOST_RECENT_CHANGED_FILE}"


		MOST_RECENT_FILE_TIME_STAMP=`stat -f "%m" "${MOST_RECENT_CHANGED_FILE}"`

		# ${ArrayName[${#ArrayName[@]}-1]}
		# Gets the last item in ArrayName
		
		echo "MODEL_MODIFICATION_TIME          = $MODEL_MODIFICATION_TIME"
		echo "MOST_RECENT_FILE_TIME_STAMP = $MOST_RECENT_FILE_TIME_STAMP"
		
		if [ "${MODEL_MODIFICATION_TIME}" -lt "${MOST_RECENT_FILE_TIME_STAMP}" ]; then
			echo "Data model has not been updated... skipping model \"${MODEL_PATH}\"."
			continue
		fi
	fi
	
	echo "Running $MOGEN"
	
	baseClass=DLManagedObject
	
	$MOGEN --version
	echo --model \""${MODEL_PATH}"\"
	echo --human-dir \""${MODEL_DIR}"\"
	echo --machine-dir \""${MACHINE_DIR}"\" 
	#echo #--base-class $baseClass
	
	$MOGEN															\
	--model "${MODEL_PATH}"											\
	--human-dir "${MODEL_DIR}"										\
	--machine-dir "${MACHINE_DIR}"									\
	--template-var arc=false											\
	#--template-path "${MODEL_PATH}/motemplates"	\
	#--base-class $baseClass
	
	
	# touch all of the generated files so we can skip running this again if we haven't changed the data model.
	for FILE in "${GENERATED_FILES}"
		do
		# echo "touch: ${MACHINE_DIR}/${FILE}"
		touch "${MACHINE_DIR}/${FILE}"
	done
	
	done
}




#### get an array of the .xcdatamodels files in the src_root directory...
#### and pass it to GMGenerateFromModel()

SRC_ROOT_FIX=`echo "${SRCROOT}" | sed 's/\ /\\ /g'`
#echo "SRC_ROOT_FIX=${SRC_ROOT_FIX}"


######## This craziness forces the field seperator to be a newline so `find` will work with paths that contain spaces
OLD_IFS="$IFS"
IFS="
"

DATA_MODELS=(`find "${SRC_ROOT_FIX}" -name "*.xcdatamodel"`)
#echo "DATA_MODELS=${DATA_MODELS[@]}"

IFS="$OLD_IFS" # We need to set the OLD_IFS back so it doesn't affect the rest of the script
##########################################################################################################

GMGenerateFromModel "${DATA_MODELS[@]}"
