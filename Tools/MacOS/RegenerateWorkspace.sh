#!/bin/bash
# Copyright (c) 2025 Daft Software.

cd "$(dirname "$0")"
source Tools/Scripts/SetupEnv.sh

echo "Regenerating project files for $UPROJECT_PATH..."

# For macOS, we use the Unreal Engine's GenerateProjectFiles script
"$UNREAL" -project="$UPROJECT_PATH" -game -engine -projectfiles

echo "Project files regenerated successfully."
