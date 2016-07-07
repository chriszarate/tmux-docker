#!/usr/bin/env bash

main() {
  local output
  output="?"

  # Make sure docker is available.
  if type docker >/dev/null 2>&1; then
    output=$(docker ps -aq -f status=created -f status=paused -f status=exited -f status=dead | wc -l | bc)
  fi

  echo "$output"
}

main
