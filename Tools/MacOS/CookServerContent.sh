#!/bin/bash
# Copyright (c) 2025 Daft Software.

cd "$(dirname "$0")"
source Tools/Scripts/SetupEnv.sh

"$UAT" BuildCookRun \
	-target=StarterServer \
	-project="$UPROJECT_PATH" \
	-targetplatform=Mac \
	-serverconfig=Development \
	-cook \
	-iostore \
	-nop4
