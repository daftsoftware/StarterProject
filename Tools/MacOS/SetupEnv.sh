#!/bin/bash
# Copyright (c) 2025 Daft Software.

# Setup Environment Script - Provides scripts with paths like engine locations etc.

# Get the project root directory (2 levels up from this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Find the .uproject file
UPROJECT_FILE=$(find "$PROJECT_ROOT" -maxdepth 1 -name "*.uproject" | head -n 1)
UPROJECT_PATH="$UPROJECT_FILE"

# Extract project name from .uproject filename
PROJECT_NAME=$(basename "$UPROJECT_FILE" .uproject)

# Extract Unreal Engine version from .uproject JSON
UNREAL_VERSION=$(grep -o '"EngineAssociation"[[:space:]]*:[[:space:]]*"[^"]*"' "$UPROJECT_FILE" | sed 's/.*"EngineAssociation"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Check if it's a source build (contains curly braces)
if [[ "$UNREAL_VERSION" == *"{"* ]] && [[ "$UNREAL_VERSION" == *"}"* ]]; then
    SOURCE_BUILD=true
else
    SOURCE_BUILD=false
fi

# Function to get launcher-installed Unreal Engine path
function get_launcher_ue_path() {
    local launcher_file="$HOME/Library/Application Support/Epic/UnrealEngineLauncher/LauncherInstalled.dat"
    if [[ -f "$launcher_file" ]]; then
        # Parse the JSON to find the installation path matching the version
        local install_path=$(python3 -c "
import json, sys
try:
    with open('$launcher_file', 'r') as f:
        data = json.load(f)
        for item in data.get('InstallationList', []):
            if item.get('AppName', '').endswith('$UNREAL_VERSION'):
                print(item.get('InstallLocation', ''))
                break
except:
    pass
" 2>/dev/null)
        echo "$install_path"
    fi
}

# Function to get source build path from UE registry plist
function get_source_build_path() {
    local plist="$HOME/Library/Application Support/Epic/UnrealEngine/Install.plist"
    if [[ -f "$plist" ]]; then
        # Try to extract the path for this specific version
        local path=$(defaults read "$plist" "$UNREAL_VERSION" 2>/dev/null)
        echo "$path"
    fi
}

echo "---------------------- ENVIRONMENT ----------------------"

# Determine engine path based on build type
if [[ "$SOURCE_BUILD" == true ]]; then
    ENGINE_PATH=$(get_source_build_path)
else
    ENGINE_PATH=$(get_launcher_ue_path)
fi

# If ENGINE_PATH is empty, try common locations
if [[ -z "$ENGINE_PATH" ]]; then
    if [[ -d "/Users/Shared/Epic Games/UE_$UNREAL_VERSION" ]]; then
        ENGINE_PATH="/Users/Shared/Epic Games/UE_$UNREAL_VERSION"
    elif [[ -d "$HOME/Library/Application Support/Epic/UE_$UNREAL_VERSION" ]]; then
        ENGINE_PATH="$HOME/Library/Application Support/Epic/UE_$UNREAL_VERSION"
    fi
fi

echo "Engine Path: $ENGINE_PATH"

# Set up Unreal Engine paths for macOS
UNREAL="$ENGINE_PATH/Engine/Binaries/Mac/UnrealEditor.app/Contents/MacOS/UnrealEditor"
echo "Unreal Editor Path: $UNREAL"

UNREAL_CMD="$ENGINE_PATH/Engine/Binaries/Mac/UnrealEditor-Cmd"
echo "Unreal Editor Command Line Path: $UNREAL_CMD"

UBT="$ENGINE_PATH/Engine/Build/BatchFiles/Mac/Build.sh"
echo "UBT Path: $UBT"

UAT="$ENGINE_PATH/Engine/Build/BatchFiles/RunUAT.sh"
echo "UAT Path: $UAT"

echo "UProject Path: $UPROJECT_PATH"
echo "Project Root: $PROJECT_ROOT"
echo "Project Name: $PROJECT_NAME"
echo "Unreal Version: $UNREAL_VERSION"
echo "Source Build: $SOURCE_BUILD"

echo "---------------------- ENVIRONMENT ----------------------"
echo ""

# Export variables for use in calling scripts
export PROJECT_ROOT
export UPROJECT_PATH
export PROJECT_NAME
export UNREAL_VERSION
export SOURCE_BUILD
export ENGINE_PATH
export UNREAL
export UNREAL_CMD
export UBT
export UAT
