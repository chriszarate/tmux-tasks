#!/usr/bin/env bash

# Provide a count of outstanding and urgent tasks using .

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

  tmux set-option -gq "$1" "${status_value/$tasks_placeholder_status/$tasks_status}"
}

# Commands
command_taskwarrior_urgent="#($CURRENT_DIR/scripts/taskwarrior_urgent.sh)"
command_taskwarrior_outstanding="#($CURRENT_DIR/scripts/taskwarrior_outstanding.sh)"

# Colors
tasks_format_begin=$(get_tmux_option "@tasks_format_begin" "#[fg=white,bg=colour236]")
tasks_format_end=$(get_tmux_option "@tasks_format_end" "#[fg=default,bg=default]")

# Icons
tasks_icon_urgent=$(get_tmux_option "@tasks_icon_urgent" "⧗ ")
tasks_icon_outstanding=$(get_tmux_option "@tasks_icon_outstanding" "+")

# Substitution
tasks_placeholder_status="\#{tasks_status}"
tasks_status="$tasks_format_begin $tasks_icon_urgent$command_taskwarrior_urgent $tasks_icon_outstanding$command_taskwarrior_outstanding $tasks_format_end"

update_status "status-left"
update_status "status-right"
