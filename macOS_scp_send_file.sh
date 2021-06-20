#!/bin/sh
### Written by LemonTree - 04/12/2020 ###
### This shell allows an user to dynamically send a file from a remote ssh server. A pre-configured sh configuration in /etc/ssh/ssh_config must exist for this to work ###

# Exit codes definition
EXIT_USER_CONFIRMED_ALL_DIALOGS="0"                 # User confirmed all dialogs (variable not empty)
EXIT_USER_CANCELLED_1ST_DIALOG="1"                  # User cancelled the 1st dialog - ssh configuration name
EXIT_USER_CANCELLED_2ND_DIALOG="2"                  # User cancelled the 2nd dialog - file to send
EXIT_USER_CANCELLED_3RD_DIALOG="3"                  # User cancelled the 3rd dialog - remote destination

# User-defined variables
SCP_TIMEOUT="10"                                    # Setting a connection timeout for the $SCP transfer
DEFAULT_CONFIGURATION="your-ssh-configuration"      # Setting your default ssh configuration

# Declare command variables
DATE=$(which "date")
OSASCRIPT=$(which "osascript")
SCP=$(which "scp")

## Creating $CURRENT_DATE variable ##
CURRENT_DATE="$DATE +%Y-%m-%d-%H%M%S"
echo "\n$($CURRENT_DATE): The script has started."

# Declare $OSASCRIPT commands variables
OSASCRIPT_ENTER_TEXT_SSH_CONFIG_COMMAND=$($OSASCRIPT -e "text returned of (display dialog \"Please enter an existing SSH configuration name:\" default answer \"$DEFAULT_CONFIGURATION\" with title \"Send file over SCP utility\" with icon note)")                                                                                              # prompt user to enter a ssh configuration name

# Continuing only if user chose to continue (OK button or enter)
if [ -z "$OSASCRIPT_ENTER_TEXT_SSH_CONFIG_COMMAND" ]; then
  echo "\n$($CURRENT_DATE): The script was cancelled by the user on the ssh configuration name dialog.\n\n$($CURRENT_DATE): Exiting.\n"
  exit 1
else
  OSASCRIPT_CONFIRMATON_MESSAGE_COMMAND=$($OSASCRIPT -e "tell application \"System Events\" to display dialog \"In the next window, you will be asked to choose a file.\nPlease choose the file you want to send.\" buttons \"OK\" default button \"OK\" with title \"Send file over SCP utility\" with icon caution")                            # sending message to user to inform him on file selection process
  OSASCRIPT_PICK_FILE_COMMAND=$($OSASCRIPT -e "POSIX path of (choose file)")

  # Continuing only if user chose to continue (OK button or enter)
  if [ -z "$OSASCRIPT_PICK_FILE_COMMAND" ]; then
    echo "\n$($CURRENT_DATE): The script was cancelled by the user on the file selection dialog.\n\n$($CURRENT_DATE): Exiting.\n"
    exit 2
  else
    OSASCRIPT_ENTER_TEXT_REMOTE_FILEPATH_COMMAND=$($OSASCRIPT -e "text returned of (display dialog \"Please enter the exact path to the folder (on the remote device) to copy the files to:\" default answer \"/home/yourUsername/Desktop\" with title \"Send file over SCP utility\" with icon note)")                                           # prompt user to enter remote filepath

    # Continuing only if user chose to continue (OK button or enter)
    if [ -z "$OSASCRIPT_ENTER_TEXT_REMOTE_FILEPATH_COMMAND" ]; then
      echo "\n$($CURRENT_DATE): The script was cancelled by the user on the remote destination dialog.\n\n$($CURRENT_DATE): Exiting.\n"
      exit 3
    else

      # Syncronise variables
      SSH_CONFIGURATION="$OSASCRIPT_ENTER_TEXT_SSH_CONFIG_COMMAND"
      FILE_TO_SEND="$OSASCRIPT_PICK_FILE_COMMAND"
      REMOTE_FILEPATH="$OSASCRIPT_ENTER_TEXT_REMOTE_FILEPATH_COMMAND"

      # Testing ...
      #echo $FILE_TO_SEND
      #echo $SSH_CONFIGURATION
      #echo $REMOTE_FILEPATH

      echo "\n$($CURRENT_DATE): Starting file transfer over SCP.\n"
      # Start file transfer over $SCP to $REMOTE_HOST using $SSH_CONFIGURATION
      $SCP -o ConnectTimeout="$SCP_TIMEOUT" "$FILE_TO_SEND" "$SSH_CONFIGURATION":"$REMOTE_FILEPATH"

      # Sending $OSASCRIPT confimation message to user
      OSASCRIPT_CONFIRMATON_MESSAGE_COMMAND=$($OSASCRIPT -e "tell application \"System Events\" to display dialog \"The file transfer operation has finished.\nInput file: $FILE_TO_SEND\nOutput folder: $REMOTE_FILEPATH\nSSH configuration name: $SSH_CONFIGURATION\" buttons \"OK\" default button \"OK\" with title \"Send file over SCP utility\" with icon note")
      echo "\n$($CURRENT_DATE): The file transfer process has finished running.\n\n$($CURRENT_DATE): Exiting.\n"
    fi
  fi
fi

exit 0
