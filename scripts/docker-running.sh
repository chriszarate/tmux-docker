#!/usr/bin/env bash

main() {
  local output
  output="?"

  # Make sure docker is available.
  if type docker >/dev/null 2>&1; then
    output=$(docker ps -aq -f status=restarting -f status=running | wc -l | bc)
  fi

  echo "$output"
}

main
