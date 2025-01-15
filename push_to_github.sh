#!/bin/bash

# Script to push changes to GitHub

# Stage all changes
git add .

# Commit changes with a message provided by the user or a default message
git commit -m "${1:-Update project files}"

# Push to the main branch
git branch -M main
git push -u origin main

# terminal code to push: ./push_to_github.sh "Initial commit with project files"