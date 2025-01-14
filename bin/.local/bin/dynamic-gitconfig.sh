#!/usr/bin/env bash

# Make sure to set GITHUB_EMAIL in export-secrets.zsh
cat > ~/.gitconfig_dynamic <<EOF
[user]
    email = $GITHUB_EMAIL
EOF
