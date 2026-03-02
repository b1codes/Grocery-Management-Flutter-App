#!/bin/bash

# Auto-Format Hook - Runs after file writes
TOOL_NAME=$(echo "$1" | jq -r '.tool')
FILE_PATH=$(echo "$1" | jq -r '.arguments.file_path')

if [[ "$TOOL_NAME" == "write_file" || "$TOOL_NAME" == "replace" ]]; then
  if [[ "$FILE_PATH" == *.dart ]]; then
    cd frontend && dart format "$FILE_PATH" > /dev/null 2>&1
  elif [[ "$FILE_PATH" == *.py ]]; then
    ruff format "$FILE_PATH" > /dev/null 2>&1 || black "$FILE_PATH" > /dev/null 2>&1
  fi
fi

echo '{"status": "success"}'
