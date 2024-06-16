#!/bin/sh
# ============================================================================ #
# Author: Mark Taguiad <marktaguiad@tagsdev.xyz>
# ============================================================================ #
# Docker Email entrypoint.
# ============================================================================ #

logDir=/var/log/mail/

# start postfix
echo "starting postfix"
touch /var/mail/postfix/vmailbox &
touch /var/mail/postfix/virtual_alias &
echo "root@example.com admin@example.com" > /var/mail/postfix/virtual_alias &
echo 'mail.tagsdev.xyz' > /etc/mailname &
postmap /var/mail/postfix/virtual_alias &
postfix start &

while true; do
        ( find "$logDir" -type f -print0 | xargs -0 tail --verbose --follow --lines=0 )&
        tailPid=$!
        inotifywait --recursive --quiet --event create --format=%w%f "$logDir" | tr \\n \\0 | xargs -0 tail --verbose
        kill $tailPid
done

exec "$@"