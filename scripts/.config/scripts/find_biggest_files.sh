#!/bin/bash


path="$HOME"
n=20
ignore_paths=()
verbose=0
help=0

while [ "$1" != "" ]; do
    case $1 in
        -p )               shift
                           path=$1
                           ;;
        --path )            shift
                           path=$1
                           ;;
        -n )               shift
                           n=$1
                           ;;
        -i )               shift
                           ignore_paths+=("$1")
                           ;;
        --ignore-path )     shift
                           ignore_paths+=("$1")
                           ;;
        --verbose )         shift
                           verbose=1
                           ;;
        -h )               shift
                           help=1
                           ;;
        --help )           shift
                           help=1
                           ;;
    esac
    shift
done

if [ "$help" -eq 1 ]; then
    echo "Usage:"
    echo "Find 20 biggest files in home:"
    echo "      biggest_files"
    echo "Find 30 biggest files in / but ignore /var and /run folders"
    echo "      biggest_files -p \"/\" -n 30 -i \"/var\" -i \"/run\""
    exit
fi

ignore_paths_arg=""

ignore_paths_length=${#ignore_paths[@]}

index=0
for i in "${ignore_paths[@]}"; do
    if [ "$index" -eq 0 ]; then
        ignore_paths_arg="-not -path \"$i\"  -prune"
    else
        ignore_paths_arg="$ignore_paths_arg -a -not -path \"$i\" -prune"
    fi
    index=$((index+1))
done

if [ -n "$ignore_paths_arg" ]; then
    ignore_paths_arg="( $ignore_paths_arg ) -o -type f"
fi

echo "Searching... (It may take some time)"

if [ "$verbose" -eq 1 ]; then
    echo "path: $path"
    echo "n: $n"
    echo "ignore_paths: ${ignore_paths[@]}"
    echo "ignore_paths_arg: $ignore_paths_arg"
    echo "ignore_paths_length: $ignore_paths_length"
fi

find "$path" -type f $ignore_paths_arg -printf '%s %p\n' | sort -nr | head -n "$n" | awk '{if ($1>=1024*1024*1024) printf "%.1f GB %s\n", $1/1024/1024/1024, $2; else printf "%.1f MB %s\n", $1/1024/1024, $2}'
