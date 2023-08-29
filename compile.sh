#!/bin/bash

default_command="racks --skip-arity-checks src/app.rkt"

if [ $# -eq 0 ]; then
  $default_command
  exit 0
fi

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -r|--recompile)
      racks --skip-arity-checks -r src/app.rkt
      exit 0
      ;;
    --clean)
      rm -r --force js-build
      $default_command
      exit 0
      ;;
    *)
      echo "Usage: $0 [-r | --recompile] <directory_name>"
      exit 1
      ;;
  esac
done
