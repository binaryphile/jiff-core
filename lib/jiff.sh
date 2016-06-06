#!/usr/bin/env bash

# Functions specific to jiff but not platform-specific

source std.sh
source string.sh
source array.sh

RoleLink="${RoleLink:-${_JIFF_ROOT}/role/current}"
LibExecDirectory="${LibExecDirectory:-${_JIFF_ROOT}/libexec}"
ContextLink="${ContextLink:-${_JIFF_ROOT}/context/current}"

jiff::current_context () {
  local context

  context="$( readlink "${ContextLink}" )"
  context=( $(str::split "/" "${context}") )
  context=( $(ary::slice "0" $((${#context[@]}-3)) "${context[@]}") )
  context="$(ary::join "/" "${context[@]}")"
  printf "%s" "${context}"
}

jiff::context_less_role () {
  local context

  context="$( readlink "${ContextLink}" )"
  context=( $(str::split "/" "${context}") )
  context=( $(ary::slice "0" $((${#context[@]}-2)) "${context[@]}") )
  context="$(ary::join "/" "${context[@]}")"
  printf "%s" "${context}"
}

jiff::is_jiff_task () {
  std::is_file "${LibExecDirectory}/jiff-${1}"
}

jiff::make_rolelinks () {
  local task
  local file

  for file in "${RoleLink}"/jiff-*; do
    std::is_match "${file}" "${RoleLink}/jiff-*" && continue
    task="$(std::base_name "${file}")"
    std::make_symlink "${LibExecDirectory}/${task}" "${file}"
  done
}

jiff::run_and_exit_if_is_jiff_task () {
  local task

  task="${1}"
  shift
  ! jiff::is_jiff_task "${task}" || exec jiff "${task}" "${@}"
}

jiff::run_if_is_jiff_task () {
  local task

  task="${1}"
  if jiff::is_jiff_task "${task}"; then
    jiff "${task}"
  fi
}

jiff::run_subtask () {
  local verb
  local object

  verb="${1}"
  shift
  object="${1:-}"
  shift
  std::usage_and_exit_if_is_empty "${object}"
  jiff::run_and_exit_if_is_jiff_task "${verb}-${object}" "${@}"
}
