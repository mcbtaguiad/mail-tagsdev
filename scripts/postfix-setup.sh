#!/bin/sh
# ============================================================================ #
# Author: Mark Taguiad <marktaguiad@tagsdev.xyz>
# ============================================================================ #
# Docker Email entrypoint.
# ============================================================================ #

# fix ip address
# mariadb
DB_IP=$(ping -c 1 www.google.com | awk -F'[()]' '/PING/{print $2}')\
sed -i 's/DB_IP_ADDRESS/${DB_IP}/g' /etc/postfix/main.cf

DOVECOT_IP_ADDRESS

OPENDKIM_IP_ADDRESS

# start postfix
echo "starting postfix"
touch /var/mail/postfix/vmailbox &
touch /var/mail/postfix/virtual_alias &
echo "root@example.com admin@example.com" > /var/mail/postfix/virtual_alias &
echo 'mail.tagsdev.xyz' > /etc/mailname &
postmap /var/mail/postfix/virtual_alias &
postfix start &

