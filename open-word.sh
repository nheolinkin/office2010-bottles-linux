#!/bin/bash

# Bottle name
BOTTLE_NAME="office2010"

# Get the original path from the %f argument passed by the .desktop file
FILE="$1"

# STEP 1: CHECK RUNNING PROCESS
APP_IS_RUNNING=0
if pgrep -f -i "WINWORD.EXE" > /dev/null; then
    APP_IS_RUNNING=1
fi

# STEP 2: LAUNCH APPLICATION
# -------------------------------------------------------------
# CASE 1: No file passed as argument
# -------------------------------------------------------------
if [ -z "$FILE" ]; then
    if [ $APP_IS_RUNNING -eq 1 ]; then
        # Create a new blank document inside the existing running instance via start.exe
        # Prevent launching a separate instance that could crash the active application.
        flatpak run --command=bottles-cli com.usebottles.bottles run \
            -b "$BOTTLE_NAME" \
            -e "C:\windows\command\start.exe" \
            --args "\"C:\Program Files\Microsoft Office\Office14\WINWORD.EXE\""
    else
        flatpak run --command=bottles-cli com.usebottles.bottles run \
            -b "$BOTTLE_NAME" \
            -p WINWORD
    fi
    exit 0
fi

# -------------------------------------------------------------
# CASE 2: A file was passed as argument
# -------------------------------------------------------------
# Replace all forward slashes (/) with Windows-style backslashes (\)
WINPATH="Z:${FILE//\//\\}"

# Wrap the entire path in double quotes (") to handle spaces and special characters
WINPATH="\"$WINPATH\""

if [ $APP_IS_RUNNING -eq 1 ]; then
    # If the application is already running, use start.exe to load the file into the existing window
    flatpak run --command=bottles-cli com.usebottles.bottles run \
        -b "$BOTTLE_NAME" \
        -e "C:\windows\command\start.exe" \
        --args "$WINPATH"
else
    # If the application is not running, open the file using the default method
    flatpak run --command=bottles-cli com.usebottles.bottles run \
        -b "$BOTTLE_NAME" \
        -p WINWORD \
        --args "$WINPATH"
fi
