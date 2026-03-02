#!/bin/bash

# Project Pulse Hook - Injects Git status into context
GIT_STATUS=$(git status -s)
PULSE="--- Project Context ---\nGit Status:\n$GIT_STATUS\n-----------------------"

echo "{\"context\": \"$PULSE\"}"
