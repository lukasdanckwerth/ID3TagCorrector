#!/bin/bash

set -x

# receive directories
SOURCE_DIRECTORY=$(pwd)
echo $SOURCE_DIRECTORY

TARGET_DIRECTORY=/Users/lukas/.bin/
TARGET_FILE_PATH="/Users/lukas/.bin/ID3Corrector"
MAIN_FILE_PATH="$SOURCE_DIRECTORY/main.swift"

# remove old file if existing
if [ -f $TARGET_FILE_PATH ]; then
    rm -rf $TARGET_FILE_PATH
fi

# add first line
echo "#!/usr/bin/swift" > $TARGET_FILE_PATH
echo "" >> $TARGET_FILE_PATH

if [ -f $COMMAND_LINE_HELPER_FILE_PATH ]; then
    echo "appending command line helper file content"
    cat $COMMAND_LINE_HELPER_FILE_PATH >> $TARGET_FILE_PATH
fi

if [ -f $MAIN_FILE_PATH ]; then
    echo "appending main file content"
    cat $MAIN_FILE_PATH >> $TARGET_FILE_PATH
fi

chmod +x "$TARGET_FILE_PATH"
