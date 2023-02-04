#!/bin/bash

#
# If the buildkite message (commit message) contains [PATCH], [MINOR], or [MAJOR] (case insensitive) then the npm
# package version will be updated accordingly and a new commit will be pushed to the head of master. This new commit
# will trigger the publish package job causing the package to be published to npm.
#

git config user.name "returnly-deploy"
git config user.email "26936852+returnly-deploy@users.noreply.github.com" 

incremented=false

shopt -s nocasematch

if [[ $BUILDKITE_MESSAGE == *"[PATCH]"* ]]; then
    echo ">>>> Updating patch version 🆙"
    npm version patch --force --no-commit-hooks -m "[v%s] $BUILDKITE_MESSAGE"
    incremented=true
elif [[ $BUILDKITE_MESSAGE == *"[MINOR]"* ]]; then
    echo ">>>> Updating minor version 🆙"
    npm version minor --force --no-commit-hooks -m "[v%s] $BUILDKITE_MESSAGE"
    incremented=true
elif [[ $BUILDKITE_MESSAGE == *"[MAJOR]"* ]]; then
    echo ">>>> Updating major version 🆙"
    npm version major --force --no-commit-hooks -m "[v%s] $BUILDKITE_MESSAGE"
     incremented=true
fi

if $incremented; then
    git push origin HEAD:master --tags --force
    exit 0
fi