#!/bin/bash

########################################################################################################################
###
###		appledoc.command
###
###		Build script to generate Docsets with the look of Apple's documentation.
###		Script only executes if the build setting of GENERATE_APPLEDOC has been defined as 1
###		
###		Copyright (c) 2012 Kevin Ross. All rights reserved.
###
###		Mutator:		Mutated:		Mutation:
###		--------		--------		---------
###		Kross			02.01.12		Initial Version
###
########################################################################################################################

# default install location...
# /usr/local/bin/appledoc 

# Add /usr/local/bin to the environment's PATH since that is the default place for appledoc to be installed.
export PATH="/usr/local/bin:$PATH"


# only generate the documentation if the GENERATE_APPLEDOC build setting has been defined as "1".
if [ $GENERATE_APPLEDOC -eq 1 ]; then

	REQUIRE_APPLEDOC=0
	LEVEL="warning"

	if [ $REQUIRE_APPLEDOC -eq 1 ]; then
		LEVEL="error"
	fi

	APPLEDOC_PATH=`which appledoc`
	#echo "APPLEDOC_PATH=${APPLEDOC_PATH}"

	if [ ! $APPLEDOC_PATH ]; then
		echo "Searching for appledoc..."
		APPLEDOC_PATH=`find /usr -name appledoc 2> /dev/null`
	fi

	if [ ! $APPLEDOC_PATH ]; then
		echo "$LEVEL: Could not find appledoc... skipping build phase."
		echo "$LEVEL: #########################################################################################################"
		echo "$LEVEL: Without appledoc installed the build will not re-generate the prject documentation!"
		echo "$LEVEL: Consider downloading appledoc from http://gentlebytes.com/appledoc/"
		echo "$LEVEL: #########################################################################################################"
		exit 0
	fi

	echo "found appledoc at path ${APPLEDOC_PATH}"
	echo "Running appledoc..."

	$APPLEDOC_PATH \
	--project-company "Kevin Ross" \
	--company-id "com.kevinross" \
	--project-name "AppName" \
	--no-warn-undocumented-member \
	--no-warn-undocumented-object \
	--warn-unknown-directive \
	--output "${PROJECT_DIR}/Documentation" \
	--ignore "*.m" \
	--exclude-output "${PROJECT_DIR}/AppName/Model/Generated" \
	--no-repeat-first-par \
	--logformat xcode \
	--install-docset \
	--exit-threshold 2 \
	"${PROJECT_DIR}"

fi