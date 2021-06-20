#!/bin/sh
### Written by LemonTree - 18-12-2020 ###
### This shell decrypts a given string using AES-256 encryption and a previously randomly generated salt and passphrase ###

## Command variables ##
DATE=$(which "date")
OSASCRIPT=$(which "osascript")

## Creating $CURRENT_DATE variable ##
CURRENT_DATE="$DATE +%Y-%m-%d-%H%M%S"
echo "\n$($CURRENT_DATE): The script has started."

## User-defined variables ##
DIALOG_ICON="note" ## Possible switches: note ; caution ; stop ##
DIALOG_MESSAGE_1="Please enter a string to decrypt (AES-256):"
DIALOG_MESSAGE_2="Please enter the associated Salt (AES-256):"
DIALOG_MESSAGE_3="Please enter the associated Passphrase (AES-256):"
DIALOG_MESSAGE_4="In the next window, please select the output folder for decrypted string file."
DIALOG_MESSAGE_5="The string was decrypted sucessfully. The file Decrypted_String_"$($CURRENT_DATE)".txt was created in the destination folder."
DIALOG_TITLE="String Encryption Utility (AES-256)"
ENCRYPTED_STRING_PROMPT_COMMAND="Tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_1\" with hidden answer default answer \"\" buttons {\"Cancel\", \"Ok\"} default button 2 with title \"$DIALOG_TITLE\""
SALT_PROMPT_COMMAND="Tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_2\" with hidden answer default answer \"\" buttons {\"Cancel\", \"Ok\"} default button 2 with title \"$DIALOG_TITLE\""
PASSPHRASE_PROMPT_COMMAND="Tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_3\" with hidden answer default answer \"\" buttons {\"Cancel\", \"Ok\"} default button 2 with title \"$DIALOG_TITLE\""

## Declaring string decryption function ##
function DecryptString() {

    # Usage ~$ DecryptString "Encrypted String" "Salt" "Passphrase"
    echo "${1}" | openssl enc -aes256 -d -a -A -S "${2}" -k "${3}"
}

# Prompting user for string to decrypt ##
ENCRYPTED_STRING=$($OSASCRIPT -e "$ENCRYPTED_STRING_PROMPT_COMMAND" -e 'text returned of result') > /dev/null 2>&1

if [[ ! -z $ENCRYPTED_STRING ]]; then

  ## Prompting user for salt ##
  SALT=$($OSASCRIPT -e "$SALT_PROMPT_COMMAND" -e 'text returned of result') > /dev/null 2>&1

else

  echo "\n$($CURRENT_DATE): The script was cancelled by the user.\n\n$($CURRENT_DATE): Exiting.\n"
  exit -1

fi

if [[ ! -z $SALT ]]; then

  ## Prompting user for passphrase ##
  PASSPHRASE=$($OSASCRIPT -e "$PASSPHRASE_PROMPT_COMMAND" -e 'text returned of result') > /dev/null 2>&1

else

  echo "\n$($CURRENT_DATE): The script was cancelled by the user.\n\n$($CURRENT_DATE): Exiting.\n"
  exit -1

fi

if [[ ! -z $PASSPHRASE ]]; then

  ## Informing user on folder selection ##
  $OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_4\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1

  ## Prompting user for file output ##
  PASSWORD_OUTPUT_FILE=$($OSASCRIPT -e "POSIX path of (choose folder)") > /dev/null 2>&1

else

  echo "\n$($CURRENT_DATE): The script was cancelled by the user.\n\n$($CURRENT_DATE): Exiting.\n"
  exit -1

fi

if [[ ! -z $PASSWORD_OUTPUT_FILE ]]; then

  ## Decrypting string ##
  DecryptString "$ENCRYPTED_STRING" "$SALT" "$PASSPHRASE" > "$PASSWORD_OUTPUT_FILE/Decrypted_String_"$($CURRENT_DATE)".txt"

  ## Informing user ##
  echo "\n$($CURRENT_DATE): The string was decrypted sucessfully. The file Decrypted_String_"$($CURRENT_DATE)".txt was created in the destination folder.\n\n$($CURRENT_DATE): Exiting.\n"
  $OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_5\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1

else

  echo "\n$($CURRENT_DATE): The script was cancelled by the user.\n\n$($CURRENT_DATE): Exiting.\n"
  exit -1

fi

exit 0
