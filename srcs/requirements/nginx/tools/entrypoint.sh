#!/bin/sh

while ! nc -z wordpress 9000; do
    sleep 1
done

exec nginx -g "daemon off;"
