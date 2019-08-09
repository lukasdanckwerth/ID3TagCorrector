#!/bin/sh

# guard the existence of a path to a git repository
if [ -n "$1" ]; then
    A_REPOSITORY_PATH=$1

    # change directory
    cd "$A_REPOSITORY_PATH"
else
    # fallback on current directory
    A_REPOSITORY_PATH=$(pwd)
fi

echo "repository path:  $A_REPOSITORY_PATH"

# guard the given path is a valid git repository
if [ ! -d "$A_REPOSITORY_PATH/.git" ]; then
    echo "$A_REPOSITORY_PATH/.git doesn't exist"; exit 0
fi

# fetch newest updates
# echo "git pull..." && git pull

# receive project name
A_PROJECT_NAME="ID3Corrector"
echo "project name:  $A_PROJECT_NAME"

# COMMAND_LINE_TOOL_PATH="/Users/lukas/bin/$A_PROJECT_NAME"

echo "clean xcode project"
xcodebuild -quiet clean -project $A_PROJECT_NAME.xcodeproj -scheme tag-corrector

echo "build xcode project"
xcodebuild build -project $A_PROJECT_NAME.xcodeproj -scheme tag-corrector

# archive CONFIGURATION_BUILD_DIR=$A_REPOSITORY_PATH/target

echo "finished"
