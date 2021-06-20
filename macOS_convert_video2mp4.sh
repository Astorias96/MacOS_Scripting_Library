#!/bin/sh
### Written by LemonTree - 28/12/2020 ###
### This shell allows an user to dynamically convert a video files from a specified folder to MPEG-4 format. This allows to save a lot of disk space without loosing the video quality. ###

### Command variables ###
APT_GET=$(which "apt-get")
DATE=$(which "date")
DIRNAME=$(which "dirname")
LS=$(which "ls")
OSASCRIPT=$(which "osascript")
RM=$(which "rm")
SH=$(which "sh")
SUDO=$(which "sudo")

## User-defined variables ##
DIALOG_TITLE="Convert video to MPEG-4 utility"
DIALOG_ICON="note"    ## Possible switches: note ; caution ; stop ##
DIALOG_MESSAGE_1="This shell will begin the installation of the FFMPEG binaries, as they are not present on this device. In the next step, you will get prompted for your password in the terminal window."
DIALOG_MESSAGE_2="In the next window, you will get prompted to select an input folder. The selected folder will be scanned for video files. All files that are found will be converted into MPEG-4 format."
DIALOG_MESSAGE_3="The conversion process for the video files in the previously selected folder has finished. Check the log to confirm the file were converted into MPEG-4 video files."

### Creating $CURRENT_DATE variable ###
CURRENT_DATE="$DATE +%Y-%m-%d-%H%M%S"
GLOBAL_PROFILE="/etc/profile"
echo "\n$($CURRENT_DATE): The script has started."

### Checking if ffmpeg is installed ###
source "$GLOBAL_PROFILE"
FFMPEG=$(which "ffmpeg")

if [ -z $FFMPEG ]; then

  ### Install ffmpeg if missing ###
  echo "\n$($CURRENT_DATE): This shell will begin the installation of the FFMPEG binaries, as they are not present on this device. In the next step, you will get prompted for your password in the terminal window.\n"
  $OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_1\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1
  $OSASCRIPT -e 'do shell script "sh /Applications/Convert_VIDEO2MP4.app/shell/macOS_install_ffmpeg_binary.sh" with administrator privileges'

fi

### Continue execution. Selecting input folder ###
## Sending an $OSASCRIPT dialog to inform on file selection (input) ##
echo "\n$($CURRENT_DATE): The user is being prompted to select an input folder."
$OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_2\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1
SELECTED_FOLDER=$($OSASCRIPT -e "POSIX path of (choose folder)") > /dev/null 2>&1

### Declaring function ###
VideoIsConvertible() {
  [ "${1##*.}" = "avi" ] || [ "${1##*.}" = "mkv" ] || [ "${1##*.}" = "mov" ] || [ "${1##*.}" = "wmv" ]
  return $?
}

if [ ! -z "$SELECTED_FOLDER" ] || [ -d "$SELECTED_FOLDER" ]; then
  ### Creating a loop to convert all video files in the specified folder to MPEG-4 video files ###
    for i in "$SELECTED_FOLDER"*; do
      if VideoIsConvertible "$i" ; then
        echo "\n$($CURRENT_DATE): Starting conversion process for the video file \"$i\"." &&
        $FFMPEG -i "$i" "${i%.*}.mp4" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
          $RM -f "$i"
          echo "\n$($CURRENT_DATE): The video file \"$i\" was sucessfully converted into MPEG-4 format. The input file was deleted."
        else
          echo "\n$($CURRENT_DATE): Error while converting the video file \"$i\"."
        fi
      fi
    done

  ### Informing user after the conversion ###
  echo "\n$($CURRENT_DATE): The conversion process for the video files in \"$SELECTED_FOLDER\" has finished. Check the log to confirm the file were converted into MPEG-4 video files.\n"
  $OSASCRIPT -e "tell application \"System Events\" to display dialog \"$DIALOG_MESSAGE_3\" with title \"$DIALOG_TITLE\" with icon $DIALOG_ICON buttons \"OK\" default button \"OK\"" > /dev/null 2>&1

  ### Exiting ###
  echo "\n$($CURRENT_DATE): Exiting.\n"
  exit 0

else
  echo "\n$($CURRENT_DATE): The script was cancelled by the user when selecting the input folder or the input folder does not exist.\n\n$($CURRENT_DATE): Exiting.\n"
  exit 1
fi
