#!/usr/bin/env bash

# Functions specific to jiff but not platform-specific

source lib/bash

is_jiff_task () {
  is_file "${_JIFF_ROOT}/libexec/jiff-${1}"
}

run_and_exit_if_is_jiff_task () {
  local task

  task="${1}"
  ! is_jiff_task "${task}" || exec jiff "${task}"
}

run_if_is_jiff_task () {
  local task

  task="${1}"
  if is_jiff_task "${task}"; then
    jiff "${task}"
  else
     return 1
  fi
}
