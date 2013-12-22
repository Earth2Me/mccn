#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

function on_exit
{
	rm -f "${config[pid_file]}" "${config[input_stream]}" "${config[output_stream]}" &> /dev/null
}

function on_hangup
{
	send save-all
	send reload
}

function send
{
	[ -n "$job" -a -w "${config[input_stream]}" ] || return 127
	echo "$*" > "${config[input_stream]}"
}

function server_thread
{
	echo $$ > "${config[pid_file]}"

	while [ -f "${config[pid_file]}" ]; do
		"${config[java]}" "{$config_java_args[@]}" "{$config_server_args[@]}"
	done
}

function start_server
{
	job=

	trap 'on_exit' SIGINT SIGTERM
	trap 'on_hangup' SIGHUP

	rm -f "${config[input_stream]}" "${config[output_stream]}" &> /dev/null
	mkfifo "${config[input_stream]}" "${config[output_stream]}" || exit 1

	server_thread < "${config[input_stream]}" &> "${config[output_stream]}" &
	job=$!
}