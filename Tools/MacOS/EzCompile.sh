#!/bin/bash
# Copyright (c) 2025 Daft Software.

cd "$(dirname "$0")"
source Tools/Scripts/SetupEnv.sh

BUILD_TARGET="${PROJECT_NAME}Editor"

# Compile C++ for Development on Mac
"$UBT" -project="$UPROJECT_PATH" $BUILD_TARGET Mac Development \
	-WaitMutex \
	-FromMsBuild

"$UNREAL" "$UPROJECT_PATH"
