FROM alpine:3.19

RUN apk update && apk add --no-cache vsftpd openssl

RUN adduser -D -h /var/www/wordpress -s /bin/sh ftpuser

RUN mkdir -p /var/run/vsftpd /var/log/vsftpd

RUN mkdir -p /etc/pam.d && \
    echo "auth required pam_unix.so" > /etc/pam.d/vsftpd && \
    echo "account required pam_unix.so" >> /etc/pam.d/vsftpd

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'echo "Setting FTP password..."' >> /entrypoint.sh && \
    echo 'echo "ftpuser:ftp123" | chpasswd' >> /entrypoint.sh && \
    echo 'echo "FTP password set to: ftp123"' >> /entrypoint.sh && \
    echo 'echo "Starting vsftpd..."' >> /entrypoint.sh && \
    echo 'exec vsftpd /etc/vsftpd/vsftpd.conf' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

EXPOSE 20 21 30000-30009

ENTRYPOINT ["/entrypoint.sh"]
