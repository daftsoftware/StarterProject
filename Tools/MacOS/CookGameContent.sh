#!/bin/bash
# Copyright (c) 2025 Daft Software.

cd "$(dirname "$0")"
source Tools/Scripts/SetupEnv.sh

"$UAT" BuildCookRun \
	-target=StarterGame \
	-project="$UPROJECT_PATH" \
	-targetplatform=Mac \
	-clientconfig=Development \
	-cook \
	-iostore \
	-nop4
