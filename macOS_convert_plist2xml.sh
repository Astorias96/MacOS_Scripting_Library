#!/bin/sh
### Written by LemonTree - 11-12-2020 ###
### This shell converts a .plist file to a .xml file so it gets readable by humans ###

########################################################
### Variables ##########################################
########################################################

## Command variables ##
DATE=$(which "date")
OSASCRIPT=$(which "osascript")
PLUTIL=$(which "plutil")

## User-defined variables ##
DIALOG_TITLE="Convert PLIST to XML utility"
DIALOG_ICON="note" ## Possible switches: note ; caution ; stop ##
DIALOG_MESSAGE1="In the next window, please choose the PLIST file to convert to XML."
DIALOG_MESSAGE2="The file $OSASCRIPT_FILEPATH was successfully converted."

## Creating $CURRENT_DATE variable ##
CURRENT_DATE="$DATE +%Y-%m-%d-%H%M%S"

########################################################
### Beginning operations ###############################
########################################################

## Printing basic information to the shell ##
echo "\n$($CURRENT_DATE): The script has started."
echo "\n$($CURRENT_DATE): The user is being prompted to select a .plist file."

## Sending an $OSASCRIPT dialog to inform on file selection ##
$OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE1\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1

## Creating the $OSASCRIPT file picker variable ##
OSASCRIPT_FILEPATH=$($OSASCRIPT -e "POSIX path of (choose file)") > /dev/null 2>&1

## Aborting if user chose to cancel ##
if [ -z $OSASCRIPT_FILEPATH ]; then
  echo "\n$($CURRENT_DATE): The script was cancelled by the user.\n\n$($CURRENT_DATE): Exiting.\n"
  exit -1

else
## Printing $OSASCRIPT_FILE_PICKER to the shell ##
echo "\n$($CURRENT_DATE): The file $OSASCRIPT_FILEPATH will be converted into a .xml file."

#########################################################
## Executing command with all variables #################
#########################################################

$PLUTIL -convert xml1 "$OSASCRIPT_FILEPATH"

## Send $OSASCRIPT dialog to inform on exit ##
echo "\n$($CURRENT_DATE): The file converting process has finished.\n\n$($CURRENT_DATE): Exiting.\n"
$OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE2\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1

fi
exit 0
