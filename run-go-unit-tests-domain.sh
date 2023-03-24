#!/usr/bin/env bash
set -o errexit
set -o nounset

function clean_up() {
    echo 'unit test failed'
    exit 1
}

# search slash-separated string component that starts with cmd, domain, or deployments
pattern='/^(cmd|deployments|domain)\/[^/]+\/[^/]+/!d;'
# ...only if it has 2 or more components
pattern+='s/^(cmd|deployments|domain)\/([^/]+)\/([^/]+).*$/\2/'

changes=$(git diff --name-only --cached)

# test all if the libraries changed
if [ "$(grep -Eq 'toolbox|driver' $changes)" ]
then
    go test -cover -count=1 -race -v ./... || clean_up
    exit 0
fi

domains=$(echo $changes | sed -E $pattern)
package=./domain/${domains}/...

go test -cover -count=1 -race -v $package || clean_up
