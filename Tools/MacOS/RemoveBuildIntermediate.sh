#!/bin/bash
# Copyright (c) 2025 Daft Software.

cd "$(dirname "$0")"

echo "Removing Build and Intermediate folders..."
rm -rf Binaries/
rm -rf Intermediate/
rm -rf Saved/

echo "Cleanup complete."
