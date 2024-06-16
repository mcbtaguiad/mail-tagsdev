#!/bin/sh
# ============================================================================ #
# Author: Mark Taguiad <marktaguiad@tagsdev.xyz>
# ============================================================================ #
# Tagsdev Mail Opendkim.
# ============================================================================ #

if test -f /var/mail/opendkim; then
        echo 'dkim key exist'
        chown opendkim:opendkim /var/mail/opendkim/*
        echo 'start opendkim'
        find /var/mail/opendkim -type f -exec cat {} \;
        opendkim -f -x /etc/opendkim.conf -p inet:8891@0.0.0.0
else
        echo 'generating keys'
        opendkim-genkey -b 2048 -h sha256 -s tagsdev.xyz -d tagsdev.xyz --directory=/var/mail/opendkim
        chown opendkim:opendkim /var/mail/opendkim/*
        find /var/mail/opendkim -type f -exec cat {} \; 
        echo 'start opendkim'
        opendkim -f -x /etc/opendkim.conf -p inet:8891@0.0.0.0
fi

