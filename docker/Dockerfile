# Use Ubuntu as the base image
FROM ubuntu:24.10

LABEL Maintainer="Mark Taguiad <marktaguiad@tagsdev.xyz>"
LABEL Description="Docker Mail"

RUN apt-get update && \
    apt-get install -y postfix dovecot-core dovecot-imapd \
    dovecot-lmtpd dovecot-pop3d dovecot-sieve spamassassin spamc mailutils \
    postfix-policyd-spf-python opendkim libsasl2-modules openssl inotify-tools && \
    apt-get clean

RUN groupadd -g 5000 vmail && \
    useradd -s /usr/sbin/nologin -u 5000 -g 5000 vmail && \
    usermod -aG vmail postfix && \
    usermod -aG vmail dovecot && \
    mkdir -p /var/mail/vhosts/tagsdev.xyz && \
    chown -R vmail:vmail /var/mail/vhosts && \
    chmod -R 775 /var/mail/vhosts && \
    mkdir -p /var/log/mail && \
    touch /var/log/mail/dovecot && \
    chgrp vmail /var/log/mail/dovecot && \
    chmod 660 /var/log/mail/dovecot && \
    touch /etc/postfix/vmailbox && \
    touch /etc/postfix/virtual_alias && \ 
    echo "root@example.com admin@example.com" > /etc/postfix/virtual_alias && \
    # mkdir -p /etc/amavis && \
    echo 'mail.tagsdev.xyz' > /etc/mailname
    # echo "\$mydomain = "mail.tagsdev.xyz";" >  /etc/amavis/conf.d/05-node_id



RUN echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && \
    sysctl -p


# Copy custom configuration files
COPY resources/dovecot/dovecot.conf /etc/dovecot/dovecot.conf
# COPY resources/ssl-params.conf /etc/dovecot/ssl-params.conf
COPY resources/postfix/main.cf /etc/postfix/main.cf
COPY resources/postfix/master.cf /etc/postfix/master.cf
COPY resources/postfix/virtual_domains /etc/postfix/virtual_domains
# COPY resources/amavisd.conf /etc/amavis/conf.d/amavisd.conf
COPY resources/postfix/policyd-spf.conf /etc/python-policyd-spf/policyd-spf.conf
COPY resources/postfix/opendkim.conf /etc/opendkim.conf

WORKDIR /app

COPY scripts/add_user.sh /app
RUN chmod a+x  /app/add_user.sh

COPY scripts/entrypoint.sh /app
RUN chmod a+x  /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]