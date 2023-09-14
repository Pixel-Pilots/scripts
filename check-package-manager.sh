#!/bin/bash

textreset=$(tput sgr0) # reset the foreground colour
red=$(tput setaf 1)
green=$(tput setaf 2)

# Check for the presence of package lock files
if [ -f "package-lock.json" ]; then
    echo "${green}npm"
    exit 0
elif [ -f "yarn.lock" ]; then
    echo "${green}yarn"
    exit 0
elif [ -f "pnpm-lock.yaml" ]; then
    echo "${green}pnpm"
    exit 0
else
    echo "${red}No package manager found"
    exit 1
fi