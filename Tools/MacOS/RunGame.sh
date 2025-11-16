#!/bin/bash
# Copyright (c) 2025 Daft Software.

cd "$(dirname "$0")"
source Tools/Scripts/SetupEnv.sh

"$UNREAL" "$UPROJECT_PATH" -game
