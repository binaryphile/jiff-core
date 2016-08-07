#!/usr/bin/env bash

# Functions specific to jiff but not platform-specific

source array.sh
source file.sh
source shell.sh
source string.sh
source ui.sh

RoleLink="${RoleLink:-${_JIFF_ROOT}/role/current}"
LibExecDirectory="${LibExecDirectory:-${_JIFF_ROOT}/libexec}"
ContextLink="${ContextLink:-${_JIFF_ROOT}/context/current}"

jiff.current_context() {
  local context

  context="$( readlink "$ContextLink" )"
  context=( $(str.split context "/") )
  context=( $(ary.slice "0" $((${#context[@]}-3)) "${context[@]}") )
  context="$(ary.join "/" "${context[@]}")"
  printf "%s" "$context"
}

jiff.context_less_role() {
  local context

  context="$( fil.readlink ContextLink )"
  context=( $(str.split "/" "$context") )
  context=( $(ary.slice context 0 -2) )
  context="$(ary.join context "/")"
  printf "%s" "$context"
}

jiff.is_jiff_task() {
  local file="${LibExecDirectory}/jiff-$1"
  fil.exist? file
}

jiff.make_rolelinks() {
  local task
  local file

  for file in "$RoleLink"/jiff-*; do
    str.eql? file "${RoleLink}/jiff-*" && continue
    task="$(fil.base_name file)"
    fil.make_symlink "${LibExecDirectory}/${task}" "$file"
  done
}

jiff.run_and_exit_if_is_jiff_task() {
  local task

  task="$1"
  shift
  ! jiff.is_jiff_task "$task" || exec jiff "$task" "$@"
}

jiff.run_if_is_jiff_task() {
  local task

  task="$1"
  if jiff.is_jiff_task "$task"; then
    jiff "$task"
  fi
}

jiff.run_subtask() {
  local verb
  local object

  verb="$1"
  shift
  object="${1:-}"
  shift
  ui.usage_and_exit_if_blank? object
  jiff.run_and_exit_if_is_jiff_task "${verb}-$object" "$@"
}
