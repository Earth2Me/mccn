#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/server-wrapper.sh"

function show_usage
{
	cat >&2 <<EOD
Usage: $0 [-?] [run|backup]

COMMANDS:
  run               Default.  Runs the Minecraft server.
  backup            Runs an offline backup.

ARGUMENTS:
  -?, --help        Displays this help message and exits.
EOD
}

while getopts '?(help)' OPTNAME; do
	case "$OPTNAME" in
		?)
			show_usage
			exit
			;;
	esac
done
shift $(($OPTIND - 1))

case "$1" in
	''|run)
		run_server
		exit $?
		;;

	backup)
		run_backup
		exit $?
		;;

	*)
		echo "Unrecognized command: $1" >&2
		show_usage
		exit 1
		;;
esac
