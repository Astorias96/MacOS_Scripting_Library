#!/bin/sh
## Written by LemonTree - 04-12-2020 ##
## This shell installs the latest ffmpeg release for macOS ##
## It downloads a .zip file and extracts the binary into the $USR_BINARY_PATH folder. ##

## System variables ##
AWK=$(which "awk")
CAT=$(which "cat")
CURL=$(which "curl")
DATE=$(which "date")
GREP=$(which "grep")
RM=$(which "rm")
TAIL=$(which "tail")
TR=$(which "tr")
UNZIP=$(which "unzip")

## User-defined variables ##
OFFICIAL_URL="https://evermeet.cx/ffmpeg/"
USR_BINARY_PATH="/usr/local/bin/"
FFMPEG_BINARY_PATH="${USR_BINARY_PATH}ffmpeg"
OUTPUT_FOR_CURL="/private/tmp/"

## Creating $CURRENT_DATE variable ##
CURRENT_DATE="$DATE +%Y-%m-%d-%H%M%S"
echo "\n$($CURRENT_DATE): The script has started."

## Get the $CURRENT_RELEASE_URL and $CURL the .zip file to $OUTPUT_FOR_CURL ##
CURRENT_RELEASE_URL=$($CURL -s "https://evermeet.cx/ffmpeg/" | $GREP .zip | $GREP ffmpeg | $GREP href | $GREP --invert-match .sig | $AWK '{ print $2 }' | $TAIL -n 1 | $TR "\"" " " | $AWK '{ print $2 }')
DOWNLOAD_URL=${OFFICIAL_URL}${CURRENT_RELEASE_URL}
echo "\n$($CURRENT_DATE): The latest release of ffmpeg for macOS was downloaded using this url:\n$DOWNLOAD_URL\n\nThe archive was downloaded to the below path and will be removed later:\n$OUTPUT_FOR_CURL\n\nThe binaries will be installed on:\n$USR_BINARY_PATH\n\nDownloading...\n"
$CURL -L --silent --url "$DOWNLOAD_URL" --output "${OUTPUT_FOR_CURL}${CURRENT_RELEASE_URL}"

## $UNZIP the downloaded .zip file to $USR_BINARY_PATH ##
echo "$($CURRENT_DATE): Unzipping...\n"
$UNZIP -o "${OUTPUT_FOR_CURL}${CURRENT_RELEASE_URL}" -d "$USR_BINARY_PATH"

if [ -f "$FFMPEG_BINARY_PATH" ]; then
  ## Remove downloaded installer from /tmp folder ##
  $RM -f "${OUTPUT_FOR_CURL}${CURRENT_RELEASE_URL}"

echo "\n$($CURRENT_DATE): The ffmpeg binaries were successfully installed.\nExiting.\n"

else
  echo "$($CURRENT_DATE): The ffmpeg binaries failed to install.\nExiting.\n"
  exit 1
fi

exit 0
