#!/bin/bash

#  askpass.command
#
# An SSH_ASKPASS command for MacOS X  
#
#  Created by Kevin Ross on 3/21/12.
#  Copyright (c) 2013 Kevin Ross. All rights reserved.
#  
# To use this script:  
#     setenv SSH_ASKPASS "askpass.command"  
#     setenv DISPLAY ":0"  
#  

# TITLE=${MACOS_ASKPASS_TITLE:-"SSH"}  

TITLE="Administrator Authorization"
MESSAGE="Please enter the administrator password for this user account..."

DIALOG="display dialog \"$MESSAGE\" default answer \"\" with title \"$TITLE\""  
DIALOG="$DIALOG with icon caution with hidden answer"  

result=`osascript -e 'tell application "Finder"' -e "activate"  -e "$DIALOG" -e 'end tell'`  

if [ "$result" = "" ]; then  
exit 1  
else  
echo "$result" | sed -e 's/^text returned://' -e 's/, button returned:.*$//'  
exit 0  
fi  
