#!/usr/bin/env bash
set -o errexit

# search slash-separated string component that starts with cmd, domain, or deployments
pattern='/^(cmd|deployments|domain)\/[^/]+\/[^/]+/!d;'
# ...only if it has 2 or more components
pattern+='s/^(cmd|deployments|domain)\/([^/]+)\/([^/]+).*$/\2/'

domain=$(git diff --name-only --cached | sed -E $pattern)

if [ ${#domain[@]} -gt 1 ]
then
    echo "Changes may only be applied to one domain"
    exit 1
fi
