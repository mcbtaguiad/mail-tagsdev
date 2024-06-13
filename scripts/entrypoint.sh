#!/bin/sh
# ============================================================================ #
# Author: Mark Taguiad <marktaguiad@tagsdev.xyz>
# ============================================================================ #
# Docker Email entrypoint.
# ============================================================================ #

logDir=/var/log/mail/

# start postfix
echo "starting postfix"
# postfix stop &
# postconf maillog_file=/var/log/mail/postfix.log &
# postfix upgrade-configuration &
# sleep 10 
postmap /etc/postfix/virtual_alias &
postfix start &
# needed to run if pvc is mounted and not fresh install
/etc/init.d/postfix reload &

echo "starting dovecot"

dovecot -F &

# echo "starting amavis"
# amavisd -c /etc/amavisd/amavisd.conf genrsa /etc/amavisd/tagsdev.xyz.dkim20200512.pem 2048
# amavisd foreground  &

echo 'opendkim'
mkdir -p /etc/opendkim/keys/ & 
opendkim-genkey -b 2048 -h sha256 -s dkim20200516 -d tagsdev.xyz --directory=/etc/opendkim/keys/ &
opendkim -f -x /etc/opendkim.conf -p inet:8891@localhost &

while true; do
        ( find "$logDir" -type f -print0 | xargs -0 tail --verbose --follow --lines=0 )&
        tailPid=$!
        inotifywait --recursive --quiet --event create --format=%w%f "$logDir" | tr \\n \\0 | xargs -0 tail --verbose
        kill $tailPid
done

exec "$@"