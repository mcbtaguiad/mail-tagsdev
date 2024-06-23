#!/bin/sh
# ============================================================================ #
# Author: Mark Taguiad <marktaguiad@tagsdev.xyz>
# ============================================================================ #
# Tagsdev Mail Opendkim.
# ============================================================================ #

if [ -n "$(find /var/mail/opendkim/ -prune -empty -type d 2>/dev/null)" ]
then
        mkdir -p /var/mail/opendkim
        echo 'generating keys'
        # opendkim-genkey -b 2048 -h sha256 -s tagsdev -d tagsdev --directory=/var/mail/opendkim
        opendkim-genkey -b 2048 -d tagsdev.xyz -s default -v --directory=/var/mail/opendkim
        chown -R opendkim:opendkim /var/mail/opendkim/
        find /var/mail/opendkim -type f -exec cat {} \; 
        echo 'start opendkim'
        opendkim -f -x /etc/opendkim.conf -p inet:8891@0.0.0.0
else
        echo 'dkim key exist'
        chown -R opendkim:opendkim /var/mail/opendkim/
        echo 'start opendkim'
        find /var/mail/opendkim -type f -exec cat {} \;
        opendkim -f -x /etc/opendkim.conf -p inet:8891@0.0.0.0
fi