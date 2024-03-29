#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

function on_exit
{
	rm -f "${config[pid_file]}" &> /dev/null

	if [ -n "$server_job" ] && kill -0 "$server_job" &> /dev/null; then
		send '#'
		send save-all
		send stop

		(
			sleep "${config[forcekill_timeout]}"
			kill -9 "$server_job"
		) &
		local forcekill=$!

		wait "$server_job"
		kill -9 $forcekill &> /dev/null
	fi

	if 
}

function on_hangup
{
	send '#'
	send save-all
	send reload
}

function send
{
	[ -n "$server_job" -a -w "${config[input_stream]}" ] || return 127
	echo "$*" > "${config[input_stream]}"
}

function server_thread
{
	echo $BASHPID > "${config[pid_file]}"

	while [ -f "${config[pid_file]}" ]; do
		"${config[java]}" "{$config_java_args[@]}" "{$config_server_args[@]}"
		echo "Java exit code: $?" >&2
	done
}

function backup_thread
{
	while [ -f "${config[pid_file]}" ]; do
		sleep "${config[backup_interval]}"

		is_backing_up=1

		send '#'
		send save-off
		send save-all
		sleep "${config[backup_wait]}"

		rdiff-backup "${dirs[server]}" "${config[backup_path]}"
		echo "Backup exit code: $?" >&2

		is_backing_up=0
	done
}

function start_server
{
	server_thread <&3 >&4 2>&5 &
	server_job=$!

	return 0
}

function start_backups
{
	backup_thread <&3 >&4 2>&5 &
	backup_job=$!

	return 0
}

function update_var_files
{
	pushd "${dirs[server]}" > /dev/null || return 1

	local out_file= in_file= var= val= tmp_file=
	for out_file in "${config_var_files[@]}"; do
		in_file="${out_file%.*}"


		for var in "${config_var_file_vars[@]}"; do
			val="$$var"
			val="${val//'\'/'\\'}"
			val="${val//'"'/'\"'}"
			val="${val//'&'/'\&'}"

			[ -n "$tmp_file" ] && rm "$tmp_file"
			tmp_file="$(mktemp)"

			awk '
				{
					gsub(/\$\{'"$var"'\}/, "'"$val"'")
					print $0
				}
			' "$in_file" > "$tmp_file"

			in_file="$tmp_file"
		done

		if [ -n "$tmp_file" ]; then
			mv "$tmp_file" "$out_file"
		else
			cp "$in_file" "$out_file"
		fi
	done

	popd > /dev/null
}

function run_server
{
	update_var_files

	server_job=
	backup_job=
	is_backing_up=0

	trap 'on_exit' SIGINT SIGTERM
	trap 'on_hangup' SIGHUP

	# In case we want to change how IO works in the future, wrap stdin, stdout, and stderr.
	exec 3<>&0 4>&1 5>&2

	start_server || return $?
	start_backups

	wait "$server_job"
	kill -0 "$backup_job" &> /dev/null && wait "$backup_job"
}