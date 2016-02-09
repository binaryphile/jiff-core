#!/usr/bin/env bash
# Usage: jiff sample-task
# Summary: A sample task template
# Help: Here is a more full explanation.
# It can go multiple lines

source stdlib
# source jifflib # jiff-specific functions
# source platformlib # platform-specific functions

strict_mode_on
# trace_on # for debugging while developing

## Provide jiff completions
# if match "${1:-}" "--complete"; then
#   cat <<EOM
# --option-one
# --option-two
# subtask
# EOM
#   exit
# fi

usage () {
  echo "Usage: jiff task --option-one [subtask]"
}

# subtask="${1:-}"

# case "${subtask}" in
# "one" | "two" )
#   do_something
#   ;;
# * )
#   usage
#   ;;
# esac
