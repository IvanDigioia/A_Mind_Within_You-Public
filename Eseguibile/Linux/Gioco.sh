#!/bin/sh
echo -ne '\033c\033]0;A mind within you\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Gioco.x86_64" "$@"
