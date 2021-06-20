#!/bin/sh
### Written by LemonTree - 18-12-2020 ###
### This shell encrypts a given string using AES-256 encryption and a randomly generated salt and passphrase ###

## Command variables ##
DATE=$(which "date")
OSASCRIPT=$(which "osascript")

### Creating $CURRENT_DATE variable ###
CURRENT_DATE="$DATE +%Y-%m-%d-%H%M%S"
echo "\n$($CURRENT_DATE): The script has started."

## User-defined variables ##
DIALOG_ICON="note" ## Possible switches: note ; caution ; stop ##
DIALOG_MESSAGE_1="Please enter a string to encrypt (AES-256):"
DIALOG_MESSAGE_2="In the next window, please select the output folder for encrypted string file."
DIALOG_MESSAGE_3="The string was encrypted sucessfully. The file Encrypted_String_"$($CURRENT_DATE)".txt was created in the destination folder."
DIALOG_TITLE="String Encryption Utility (AES-256)"
PASSWORD_PROMPT_COMMAND="Tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_1\" with hidden answer default answer \"\" buttons {\"Cancel\", \"Ok\"} default button 2 with title \"$DIALOG_TITLE\""

## Declaring string encryption function ##
function GenerateEncryptedString() {

    # Usage ~$ GenerateEncryptedString "String"
    local STRING="${1}"
    local SALT=$(openssl rand -hex 8)
    local K=$(openssl rand -hex 12)
    local ENCRYPTED=$(echo "${STRING}" | openssl enc -aes256 -a -A -S "${SALT}" -k "${K}")
    echo "Encrypted String: ${ENCRYPTED}"
    echo "Salt: ${SALT} | Passphrase: ${K}"
}

# Prompting user for string to encrypt ##
PASSWORD=$($OSASCRIPT -e "$PASSWORD_PROMPT_COMMAND" -e 'text returned of result') > /dev/null 2>&1

if [[ ! -z $PASSWORD ]]; then

  ## Informing user on folder selection ##
  $OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_2\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1

  ## Prompting user for file output ##
  PASSWORD_OUTPUT_FILE=$($OSASCRIPT -e "POSIX path of (choose folder)") > /dev/null 2>&1

else
  echo "\n$($CURRENT_DATE): The script was cancelled by the user.\n\n$($CURRENT_DATE): Exiting.\n"
  exit -1

fi

if [[ ! -z $PASSWORD_OUTPUT_FILE ]]; then

  ## Encrypting string ##
  GenerateEncryptedString $PASSWORD > "$PASSWORD_OUTPUT_FILE/Encrypted_String_"$($CURRENT_DATE)".txt"

  ## Informing user ##
  echo "\n$($CURRENT_DATE): The string was encrypted sucessfully. The file Encrypted_String_"$($CURRENT_DATE)".txt was created in the destination folder.\n\n$($CURRENT_DATE): Exiting.\n"
  $OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_3\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1

else
  echo "\n$($CURRENT_DATE): The script was cancelled by the user.\n\n$($CURRENT_DATE): Exiting.\n"
  exit -1
fi

exit 0
