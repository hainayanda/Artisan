#!/bin/bash

set -eo pipefail

xcodebuild -workspace Example/Artisan.xcworkspace \
            -scheme Artisan-Example \
            -destination platform=iOS\ Simulator,OS=14.5,name=iPhone\ 12 \
            clean test | xcpretty
