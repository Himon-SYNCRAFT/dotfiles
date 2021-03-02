#!/bin/sh


if [ "$(cmus-remote -Q | head -n1 | cut -f 2 -d ' ')" = "playing" ]; then
    cmus-remote -u
else
    cmus-remote -p
fi
