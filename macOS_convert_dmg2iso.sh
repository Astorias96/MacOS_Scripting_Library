#!/bin/sh
### Written by LemonTree - 11-12-2020 ###
### This shell converts a .dmg file to a .iso file so it can be used and written on various systems ###

########################################################
### Variables ##########################################
########################################################

## Command variables ##
DATE=$(which "date")
HDIUTIL=$(which "hdiutil")
OSASCRIPT=$(which "osascript")
RM=$(which "rm")

## User-defined variables ##
DIALOG_TITLE="Convert DMG to ISO utility"
DIALOG_ICON="note"                                                                       ## Possible switches: note ; caution ; stop ##
DIALOG_MESSAGE_1="In the next window, please choose the DMG file to convert to ISO."
DIALOG_MESSAGE_2="In the next window, please choose the folder where you want to save the ISO file."
DIALOG_MESSAGE_3="In the next window, please enter the desired file name for the converted ISO file."
DIALOG_MESSAGE_4="The output file already exists.\nPressing OK will overwrite it."
DIALOG_MESSAGE_5="The file DMG was successfully converted."
DIALOG_DEFAULT_ANSWER="Filename.iso"

## Creating $CURRENT_DATE variable ##
CURRENT_DATE="$DATE +%Y-%m-%d-%H%M%S"

########################################################
### Beginning operations ###############################
########################################################

## Printing basic information to the shell ##
echo "\n$($CURRENT_DATE): The script has started."
echo "\n$($CURRENT_DATE): The user is being prompted to select a .dmg file."

## Sending an $OSASCRIPT dialog to inform on file selection (input) ##
$OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_1\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1

## Creating the $OSASCRIPT file picker variable (input) ##
OSASCRIPT_FILEPATH_1=$($OSASCRIPT -e "POSIX path of (choose file)") > /dev/null 2>&1

## Aborting if user chose to cancel ##
if [[ -z $OSASCRIPT_FILEPATH_1 ]]; then
  echo "\n$($CURRENT_DATE): The script was cancelled by the user.\n\n$($CURRENT_DATE): Exiting.\n"
  exit -1

else
  ## Sending an $OSASCRIPT dialog to inform on file selection (output) ##
  $OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_2\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1

  ## Creating the $OSASCRIPT file picker variable (output) ##
  OSASCRIPT_FILEPATH_2=$($OSASCRIPT -e "POSIX path of (choose folder)") > /dev/null 2>&1

  ## Aborting if user chose to cancel ##
  if [[ -z $OSASCRIPT_FILEPATH_2 ]]; then
    echo "\n$($CURRENT_DATE): The script was cancelled by the user.\n\n$($CURRENT_DATE): Exiting.\n"
    exit -1

  else
    ## Sending an $OSASCRIPT dialog to inform on enter filename dialog (output) ##
    $OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_3\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1

    ## Creating the $OSASCRIPT enter text variable (output) ##
    OSASCRIPT_FILENAME=$($OSASCRIPT -e "set T to text returned of (display dialog \"Please enter a filename:\" with title \"$DIALOG_TITLE\" buttons {\"Cancel\", \"Continue\"} default button \"Continue\" default answer \"$DIALOG_DEFAULT_ANSWER\" with icon $DIALOG_ICON)") > /dev/null 2>&1

    ## Aborting if user chose to cancel ##
    if [[ -z $OSASCRIPT_FILENAME ]]; then
      echo "\n$($CURRENT_DATE): The script was cancelled by the user.\n\n$($CURRENT_DATE): Exiting.\n"
      exit -1

    else
      ## Printing $OSASCRIPT_FILE_PICKER to the shell ##
      echo "\n$($CURRENT_DATE): The file $OSASCRIPT_FILEPATH_1 will be converted into a .iso file and placed on the the following path:\n\"$OSASCRIPT_FILEPATH_2/$OSASCRIPT_FILENAME\""

      #########################################################
      ## Executing command with all variables #################
      #########################################################

      if [[ -f "$OSASCRIPT_FILEPATH_2/$OSASCRIPT_FILENAME" ]]; then
        echo "\n$($CURRENT_DATE): The file \"$OSASCRIPT_FILEPATH_2/$OSASCRIPT_FILENAME\" already exists. The user is being prompted to overwrite the file."

        ## Sending an $OSASCRIPT dialog to inform on enter filename dialog (output) ##
        $OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_4\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1

        ## Remove the existing .iso file ##
        $RM -f "$OSASCRIPT_FILEPATH_2/$OSASCRIPT_FILENAME" &&

        ## Convert .dmg file to .iso file ##
        $HDIUTIL makehybrid -iso -joliet -o "$OSASCRIPT_FILEPATH_2/$OSASCRIPT_FILENAME" "$OSASCRIPT_FILEPATH_1"

        ## Send $OSASCRIPT dialog to inform on exit ##
        echo "\n$($CURRENT_DATE): The file converting process has finished.\n\n$($CURRENT_DATE): Exiting.\n"
        $OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_5\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1

      else
        ## Convert .dmg file to .iso file ##
        $HDIUTIL makehybrid -iso -joliet -o "$OSASCRIPT_FILEPATH_2/$OSASCRIPT_FILENAME" "$OSASCRIPT_FILEPATH_1"

        ## Send $OSASCRIPT dialog to inform on exit ##
        echo "\n$($CURRENT_DATE): The file converting process has finished.\n\n$($CURRENT_DATE): Exiting.\n"
        $OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_5\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1
      fi
    fi
  fi
fi
exit 0
