#!/bin/bash

set -eo pipefail

xcodebuild -workspace Example/Artisan.xcworkspace \
            -scheme Artisan-Example \
            -destination platform=iOS\ Simulator,OS=14.3,name=iPhone\ 11 \
            clean test | xcpretty
