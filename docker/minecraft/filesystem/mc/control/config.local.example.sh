#!/bin/bash
# Copy this to config.local.sh IN YOUR SERVER VOLUME--not this directory.  DO
# NOT rename this file, or you will break updates.  For that matter, do not
# touch anything in this directory.
#
# You should be COPYING this file to: /mc/server/config.local.sh
# Use config.default.sh as a REFERENCE ONLY.

# If you're running several containers on the same server, you'll want to adjust
# these appropriately.
#config[java_min_heap]=256M
#config[java_max_heap]=2G

# Typical settings for OpenJDK x64
config_java_args+=(
	-d64        # Force 64-bit
	-server     # Use the server JVM
	-da         # Disable assertions
	-dsa        # Disable system assertions
	-Xincgc     # Incremental GC: sacrifices some CPU for a lot of RAM
)

# Files that need to be parsed for variables
config_var_files+=(
	bukkit.yml
)

# Variables exposed to var files
config_var_file_vars+=(
	# If you had an instance aliased "mysql":
	MYSQL_PORT_3306_TCP_ADDR
	MYSQL_PORT_3306_TCP_PORT
)