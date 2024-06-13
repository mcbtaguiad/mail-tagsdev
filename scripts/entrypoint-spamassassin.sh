#!/bin/sh
# ============================================================================ #
# Author: Mark Taguiad <marktaguiad@tagsdev.xyz>
# ============================================================================ #
# Docker Email entrypoint.
# ============================================================================ #
sa-update
spamd --create-prefs --syslog stderr --nouser-config --max-children 5 --helper-home-dir /var/lib/spamassassin --configpath=/etc/spamassassin/spamassassin --pidfile=/var/run/spamd.pid --listen 0.0.0.0

exec "$@"