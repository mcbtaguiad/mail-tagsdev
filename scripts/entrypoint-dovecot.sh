#!/bin/sh
# ============================================================================ #
# Author: Mark Taguiad <marktaguiad@tagsdev.xyz>
# ============================================================================ #
# Docker Email entrypoint.
# ============================================================================ #

logDir=/var/log/mail/

echo "starting dovecot"
dovecot -F &

while true; do
        ( find "$logDir" -type f -print0 | xargs -0 tail --verbose --follow --lines=0 )&
        tailPid=$!
        inotifywait --recursive --quiet --event create --format=%w%f "$logDir" | tr \\n \\0 | xargs -0 tail --verbose
        kill $tailPid
done

exec "$@"