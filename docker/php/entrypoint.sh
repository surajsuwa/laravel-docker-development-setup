#!/bin/sh

set -e


# The Key Ignition (entrypoint.sh): The first thing that runs when you turn the key. Right now, your entrypoint.sh literally just says: "Turn on the engine and start driving (exec "$@")!"
# if [ "$1" = "php-fpm" ]; then
#     php artisan optimize:clear
# fi

exec "$@"


