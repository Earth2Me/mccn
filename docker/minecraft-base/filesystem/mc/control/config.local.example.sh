#!/bin/bash
# Copy this to config.local.sh.  DO NOT rename it, or you will break updates.
# Use config.default.sh as a reference to configure the application.

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