#!/bin/bash

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
###
############################################################################################################################



REQUIRE_MOGEN=0
LEVEL="warning"

if [ $REQUIRE_MOGEN -eq 1 ]; then
	LEVEL="error"
fi


## Paths
MODEL_DIR="${SRCROOT}/MyApp/Model"
MACHINE_DIR="${MODEL_DIR}/Generated"
MODEL_PATH="${MODEL_DIR}/MyApp.xcdatamodeld/MyApp.xcdatamodel"



# Check the modification date of the data model.
MODEL_MODIFICATION_TIME=`stat -f "%m" "${MODEL_PATH}/contents"`

GENERATED_FILES=(`ls -tU ${MACHINE_DIR}`)
MOST_RECENT_CHANGED_FILE="${MACHINE_DIR}/${GENERATED_FILES[0]}"

# echo "MOST_RECENT_CHANGED_FILE = ${MOST_RECENT_CHANGED_FILE}"

MOST_RECENT_FILE_TIME_STAMP=`stat -f "%m" ${MOST_RECENT_CHANGED_FILE}`

# ${ArrayName[${#ArrayName[@]}-1]}
# Gets the last item in ArrayName

#echo "MODEL_MODIFICATION_TIME          = $MODEL_MODIFICATION_TIME"
#echo "MOST_RECENT_FILE_TIME_STAMP = $MOST_RECENT_FILE_TIME_STAMP"

if [ ${MODEL_MODIFICATION_TIME} -lt ${MOST_RECENT_FILE_TIME_STAMP} ]; then
	echo "Data model has not been updated... skipping build phase."
	exit 0
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


echo "Running $MOGEN"

baseClass=DOManagedObject

$MOGEN --version
echo --model \""${MODEL_PATH}"\"
echo --human-dir \""${MODEL_DIR}"\"
echo --machine-dir \""${MACHINE_DIR}"\" 
#echo #--base-class $baseClass

$MOGEN															\
--model "${MODEL_PATH}"											\
--human-dir "${MODEL_DIR}"										\
--machine-dir "${MACHINE_DIR}"									\
--template-path "${SRCROOT}/MyApp/Scripts/motemplates"			\
--template-var arc=true
#--base-class $baseClass


# touch all of the generated files so we can skip running this again if we haven't changed the data model.
for FILE in "${GENERATED_FILES}"
do
	# echo "touch: ${MACHINE_DIR}/${FILE}"
	touch ${MACHINE_DIR}/$FILE
done
