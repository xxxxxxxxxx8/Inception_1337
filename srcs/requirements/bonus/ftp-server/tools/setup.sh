#!/bin/sh

if [ -f /run/secrets/ftp_password ]; then
    FTP_PASSWORD=$(cat /run/secrets/ftp_password)
    echo "ftpuser:$FTP_PASSWORD" | chpasswd
    echo "FTP password configured"
else
    echo "Warning: FTP password secret not found"
fi

if [ -d /var/www/wordpress ]; then
    chown -R ftpuser:ftpuser /var/www/wordpress
    echo "Permissions set for /var/www/wordpress"
fi

exec vsftpd /etc/vsftpd/vsftpd.conf
