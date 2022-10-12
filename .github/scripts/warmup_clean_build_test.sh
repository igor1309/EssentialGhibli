#!/bin/bash

# Run Swift clean build and test

# Do not forget to make this file executable with `chmod +x the_file_name`

# `set -o pipefail` causes a pipeline (for example,
# `curl -s https://sipb.mit.edu/ | grep foo`) to produce
# a failure return code if any command errors.
# Normally, pipelines only return a failure if the last command errors.
# In combination with `set -e`, this will make your script exit
# if any command in a pipeline errors.
set -eo pipefail

# TODO: replace with command line argument
SCHEME="CI_iOS"
NAME="iPhone 13 Pro"
VERSION="16.0"
DESTINATION="platform=iOS Simulator,name=$NAME,OS=$VERSION"
echo $DESTINATION

# iOS Simulator from the Command Line | RY 's Blog https://suelan.github.io/2020/02/05/iOS-Simulator-from-the-Command-Line/
# Using iOS Simulator with the Command Line | Notificare https://notificare.com/blog/2020/05/22/Using-iOS-Simulator-with-the-Command-Line/
# xcode - How can I launch the iOS Simulator from Terminal? - Stack Overflow https://stackoverflow.com/questions/31179706/how-can-i-launch-the-ios-simulator-from-terminal

# warm up with `xcrun instruments -w` not working, use `xcrun simctl`
# - xcrun instruments -w 'iPhone 13 Pro (16.0)' || sleep 15
#- xcrun instruments -w '$name ($VERSION)' || sleep 15
# create new device
# NEW_DEVICE=$(xcrun simctl create "Test Phone" "iPhone XR" iOS13.0)
NEW_DEVICE_NAME="Test iPhone"
NEW_DEVICE_ID=$(xcrun simctl create "$NEW_DEVICE_NAME" "$NAME" iOS$VERSION)
DESTINATION="platform=iOS Simulator,id=$NEW_DEVICE_ID,OS=$VERSION"
#DESTINATION="platform=iOS Simulator,name=$NEW_DEVICE_NAME,OS=$VERSION"
echo $DESTINATION

# Boot a simulator
xcrun simctl boot "$NEW_DEVICE_ID"
# open -a Simulator.app --args -CurrentDeviceUDID "$NEW_DEVICE_ID"

# wait for boot to finish
sleep 60

# clean build test
xcodebuild clean build test \
           -project App/EssentialGhibli.xcodeproj \
           -scheme "$SCHEME" \
           -sdk iphonesimulator \
           -destination "$DESTINATION" \
           CODE_SIGN_IDENTITY="" \
           CODE_SIGNING_REQUIRED=NO \
           ONLY_ACTIVE_ARCH=YES \
           | xcpretty
