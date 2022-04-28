#!/usr/bin/env bash

# file utilized in github actions to automatically update upstream

(
set -e
PS1="$"

current=$(cat gradle.properties | grep pearlRef | sed 's/pearlRef = //')
upstream=$(git ls-remote https://github.com/Pearl-project/Pearl | grep main | cut -f 1)

if [ "$current" != "$upstream" ]; then
    sed -i 's/pearlRef = .*/pearlRef = '"$upstream"'/' gradle.properties
    {
      ./gradlew applyPatches --stacktrace && ./gradlew build --stacktrace && ./gradlew rebuildPatches --stacktrace
    } || exit

    git add .
    ./scripts/upstreamCommit.sh "$current"
fi

) || exit 1
