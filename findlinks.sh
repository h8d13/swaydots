#!/bin/sh

find "$HOME" -type l 2>/dev/null | while read -r link; do
    target=$(readlink "$link")
    case "$target" in
        *"/home/hadean/swaydots"*)
            echo "$link -> $target"
            ;;
    esac
done
