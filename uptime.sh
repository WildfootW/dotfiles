#!/usr/bin/env bash
# Prints the uptime.
uptime | grep -ZoG "\d\{1\} days,[^,]*"
