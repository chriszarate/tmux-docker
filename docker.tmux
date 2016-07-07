#!/usr/bin/env bash

# Provide a count of running and stopped Docker containers.

docker_placeholder_status="\#{docker_status}"

get_tmux_option() {
  local option_value
  option_value=$(tmux show-option -gqv "$1")

  if [ -z "$option_value" ]; then
    echo "$2"
  else
    echo "$option_value"
  fi
}

update_status() {
  local status_value
  status_value="$(get_tmux_option "$1")"

  tmux set-option "$1" "${status_value/$docker_placeholder_status/$output}"
}

# Colors
docker_format_begin=$(get_tmux_option "@docker_format_begin" "#[fg=white,bg=colour236]")
docker_format_end=$(get_tmux_option "@docker_format_end" "#[fg=white,bg=black]")

# Icons
docker_icon_running=$(get_tmux_option "@docker_icon_running" "◼ ")
docker_icon_stopped=$(get_tmux_option "@docker_icon_stopped" "◻ ")

get_docker_status() {
  local docker_count_running
  local docker_count_stopped

  docker_count_running="?"
  docker_count_stopped="?"

  # Make sure docker is available.
  if type docker >/dev/null 2>&1; then
    docker_count_all=$(docker ps -aq | wc -l | bc)
    docker_count_running=$(docker ps -aq -f status=running | wc -l | bc)
    docker_count_stopped=$(echo "$docker_count_all - $docker_count_running" | bc)
  fi

  echo "$docker_format_begin $docker_icon_running$docker_count_running $docker_icon_stopped$docker_count_stopped $docker_format_end"
}

output=$(get_docker_status)
update_status "status-left"
update_status "status-right"
