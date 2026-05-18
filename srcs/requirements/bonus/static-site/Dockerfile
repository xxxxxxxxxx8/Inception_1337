FROM alpine:3.19

RUN apk update && apk add --no-cache nginx

RUN mkdir -p /var/www/html /run/nginx

COPY conf/index.html /var/www/html/
COPY conf/nginx.conf /etc/nginx/http.d/default.conf

RUN adduser -D -g 'www' www 2>/dev/null || true

EXPOSE 8081

CMD ["nginx", "-g", "daemon off;"]
