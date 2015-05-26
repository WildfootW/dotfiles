#!/usr/bin/env sh
# Prints the uptime.
uptime | grep -ZoG "\d\d days,[^,]*"
