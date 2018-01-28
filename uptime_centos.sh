#!/usr/bin/env bash
# Prints the uptime.
uptime | awk '{print $3 " " $4 " " $5}'

