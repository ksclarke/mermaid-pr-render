#!/bin/bash

# Support nice recursive patterns like '**/*.mmd'
shopt -s globstar

# Fetch the tip of the base branch
git fetch -q --depth=1 origin $GITHUB_BASE_REF

# Get the SHAs of the checkpoints we're comparing
HEAD_SHA="$(git rev-parse $GITHUB_HEAD_REF)"
BASE_SHA="$(git rev-parse origin/$GITHUB_BASE_REF)"

# Loop through the supplied (via pattern) files
for FILE in $(git diff --name-only $BASE_SHA $HEAD_SHA | grep "$1" | xargs); do
  # Strip the original file extension
  NAME="/github/workspace/$(echo "${FILE}" | cut -f 1 -d '.')"

  # Run Mermaid's CLI, supplying a new file extension to the output file
  /usr/local/bin/mmdc -i "/github/workspace/${FILE}" -o "${NAME}.${2}" -p "/puppeteer-config.json"

  # Output something visible in the action's logs to indicate what was rendered
  echo "Rendered ${NAME#/github/workspace/}.${2}"
done
