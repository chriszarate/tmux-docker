#!/usr/bin/env bash

# Provide a count of running and stopped Docker containers.

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

  tmux set-option -gq "$1" "${status_value/$docker_placeholder_status/$docker_status}"
}

# Commands
docker_running="#($CURRENT_DIR/scripts/docker-running.sh)"
docker_stopped="#($CURRENT_DIR/scripts/docker-stopped.sh)"

# Colors
docker_format_begin=$(get_tmux_option "@docker_format_begin" "#[fg=white,bg=colour236]")
docker_format_end=$(get_tmux_option "@docker_format_end" "#[fg=default,bg=default]")

# Icons
docker_icon_running=$(get_tmux_option "@docker_icon_running" "◼ ")
docker_icon_stopped=$(get_tmux_option "@docker_icon_stopped" "◻ ")

# Substitution
docker_placeholder_status="\#{docker_status}"
docker_status="$docker_format_begin $docker_icon_running$docker_running $docker_icon_stopped$docker_stopped $docker_format_end"

update_status "status-left"
update_status "status-right"
