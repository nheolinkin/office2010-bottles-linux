#!/bin/bash
FILE="$1"
if [ -z "$FILE" ]; then
    flatpak run --command=bottles-cli com.usebottles.bottles run \
    -b Office2010 \
    -e "C:\Program Files\Microsoft Office\Office14\EXCEL.EXE"
else
WINPATH="Z:${FILE//\//\\}"
WINPATH="\"$WINPATH\""
flatpak run --command=bottles-cli com.usebottles.bottles run \
  -b Office2010 \
  -e "C:\Program Files\Microsoft Office\Office14\EXCEL.EXE" \
  --args-replace \
  "$WINPATH"
fi