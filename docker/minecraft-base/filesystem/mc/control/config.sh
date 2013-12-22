#!/bin/bash
# WARNING: Don't edit this file, or you'll break updates.  Instead, copy
# config.local.example.sh to config.local.sh and edit that.

# Setup {{{1
#     Don't touch this section; it's used to automatically determine some
#     configuration values.

declare -rA dirs
dirs[control]="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # /mc/control/
dirs[mc]="$(cd "${dirs[control]}" && cd .. && pwd)"            # /mc/
dirs[server]="$(cd "${dirs[mc]}" && cd server && pwd)"         # /mc/server/
dirs[tmp]="$(cd "${dirs[mc]}" && cd tmp && pwd)"               # /mc/tmp/

# Calculate default heap sizes
memory_kb="$(awk '/MemTotal/{print $2}' /proc/meminfo)"
let memory_mb = $memory_kb / 1024
if [ $memory_mb -lt 2048 ]; then
	[ $memory_mb -gt 512 ] && default_min_heap=256 || let default_min_heap = $memory_mb / 2
	let default_max_heap = $memory_mb - $default_min_heap
	default_min_heap="${default_min_heap}M"
	default_max_heap="${default_max_heap}M"
else
	default_min_heap=256M
	default_max_heap=2G
fi


# Includes {{{1
#    This includes the default and customizable configuration scripts.
#

readonly default_config="${dirs[control]}/config.default.sh"
readonly local_config="${dirs[control]}/config.local.sh"

if [ ! -r "$default_config" ]; then
	echo 'The default configuration file is missing; you should not edit or remove it.' >&2
	exit 1
fi

if [ ! -r "$local_config" ]; then
	echo 'You need to create a local configuration file first.  Do not edit the default configuration file.' >&2
	exit 1
fi

declare -A config
declare -a config_java_args=( )

source "$default_config"
source "$local_config"

config_java_args+=(
	"-Xms${config[java_min_heap]}"
	"-Xmx${config[java_max_heap]}"
)


# Environment {{{1
#     No touchy.
#

export TMPDIR="${dirs[tmp]}"
