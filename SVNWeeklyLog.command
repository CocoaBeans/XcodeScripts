#!/bin/bash

############################################################################################################################
###
###		SVNWeeklyLog.command
###
###		Prints the commits from last week.
###		
###		Copyright (c) 2012 Kevin Ross. All rights reserved.
###
###		Mutator:		Mutated:		Mutation:
###		--------		--------		---------
###		Kross			02.01.12		Initial Version
###
############################################################################################################################

#  svn log -v --limit 10 --revision {`date -v "+1d" "+%Y-%m-%d"`}:{`date -v "-7d" "+%Y-%m-%d"`}
REPO=$1
DOT_SVN_FOLDER="$REPO/.svn"

if [ -d $DOT_SVN_FOLDER ] 
then	
	START_DATE=`date -v+1d "+%Y-%m-%d"`
	END_DATE=`date -v-7d "+%Y-%m-%d"`
	
	echo "SVN logs between $END_DATE and $START_DATE"
	svn log -v --revision {$START_DATE}:{$END_DATE} $REPO
else 
	echo "Path for '$REPO' is not a valid SVN repository!"
fi

