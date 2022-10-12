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

# WARNINIG: replace with command line argument
scheme="CI_iOS_with_snapshots"
name="iPhone 13 Pro"
version="16.0"
destination="platform=iOS Simulator,name=$name,OS=$version"

# warm up
# - xcrun instruments -w 'iPhone 13 Pro (16.0)' || sleep 15
#- xcrun instruments -w '$name ($version)' || sleep 15
# create new device
# NEW_DEVICE=$(xcrun simctl create "Test Phone" "iPhone XR" iOS13.0)
# NEW_DEVICE=$(xcrun simctl create "Test iPhone" "$name" iOS$version)

# Boot a simulator
#xcrun simctl boot "$NEW_DEVICE"

# clean build test
xcodebuild clean build test \
           -project App/EssentialGhibli.xcodeproj \
           -scheme "$scheme" \
           -sdk iphonesimulator \
           -destination "$destination" \
           CODE_SIGN_IDENTITY="" \
           CODE_SIGNING_REQUIRED=NO \
           ONLY_ACTIVE_ARCH=YES \
           | xcpretty
