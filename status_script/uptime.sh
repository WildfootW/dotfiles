#!/usr/bin/env bash
# Prints the uptime.
uptime | awk '
{ if ($4 == "days," || $4 == "day," || $4 == "day" || $4 == "days") 
    { print $3 " days " $5  } 
else 
    { print $3 " minutes" }  }
    ' | tr -d ','
