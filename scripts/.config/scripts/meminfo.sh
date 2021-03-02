#!/usr/bin/sh


ps axch -o cmd:15,%mem | awk '{arr[$1]+=$2}; END {for (i in arr) {print i, arr[i] "%"}}' | sort -k2 -r -n | head
