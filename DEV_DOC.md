# Developer Documentation - Inception Project

## Architecture

```txt
┌─────────────────────────────────────────────────────────────────┐
│ DOCKER HOST                                                    │
│                                                                 │
│ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐             │
│ │ NGINX        │ │ WORDPRESS    │ │ MARIADB      │             │
│ │ Port 443     │◄─┤ Port 9000   │◄─┤ Port 3306   │             │
│ │ SSL/TLS      │ │ PHP-FPM      │ │ Database     │             │
│ └──────────────┘ └──────────────┘ └──────────────┘             │
│                                                                 │
│ ┌─────────────┐ ┌─────────────────┐ ┌─────────────┐            │
│ │ ADMINER     │ │ REDIS CACHE     │ │ FTP SERVER  │            │
│ │ Port 8080   │ │ Port 6379       │ │ Port 21     │            │
│ └─────────────┘ └─────────────────┘ └─────────────┘            │
│                                                                 │
│ ┌──────────────┐ ┌──────────────┐                              │
│ │ STATIC SITE  │ │ PORTAINER    │                              │
│ │ Port 8081    │ │ Port 9443    │                              │
│ └──────────────┘ └──────────────┘                              │
│                                                                 │
│ Volumes: wp_volume | db_volume | portainer_data                │
│ Network: inception_network (bridge)                            │
└─────────────────────────────────────────────────────────────────┘
```

# Environment Setup

## Prerequisites

```bash
docker --version
docker compose version
make --version
openssl version
```

## Full Installation

```bash
git clone <repository-url> inception
cd inception

mkdir -p secrets

openssl rand -base64 12 | sed 's/\//_/g' | xargs echo "root_" > secrets/db_root_password.txt
openssl rand -base64 12 | sed 's/\//_/g' | xargs echo "wpuser_" > secrets/db_password.txt
openssl rand -base64 12 | sed 's/\//_/g' | xargs echo "supervisor_" > secrets/wp_admin_password.txt
openssl rand -base64 12 | sed 's/\//_/g' | xargs echo "editor_" > secrets/wp_user_password.txt
openssl rand -base64 12 | sed 's/\//_/g' | xargs echo "ftpuser_" > secrets/ftp_password.txt

chmod 600 secrets/*.txt

echo "127.0.0.1 mtarza.42.fr" | sudo tee -a /etc/hosts

make all
```

# Makefile Commands

```bash
m# Build and start all services
make all

# Build Docker images only
make build

# Start containers only
make up

# Stop containers only
make down

# Stop and remove containers + volumes
make clean

# Complete cleanup (images + cache + volumes)
make fclean

# Full rebuild from scratch
make re

# View all logs in real-time
make logs

# Show container status
make status

# Restart all services
make restart
```

# Docker Compose Commands

```bash
# Navigate to project
cd ~/inception

# Build all images
docker compose -f srcs/docker-compose.yml build

# Build specific service
docker compose -f srcs/docker-compose.yml build mariadb
docker compose -f srcs/docker-compose.yml build wordpress
docker compose -f srcs/docker-compose.yml build nginx

# Build without cache
docker compose -f srcs/docker-compose.yml build --no-cache

# Start all services
docker compose -f srcs/docker-compose.yml up -d

# Start specific service
docker compose -f srcs/docker-compose.yml up -d mariadb
docker compose -f srcs/docker-compose.yml up -d wordpress
docker compose -f srcs/docker-compose.yml up -d nginx

# Stop all services
docker compose -f srcs/docker-compose.yml down

# Stop with volumes removed
docker compose -f srcs/docker-compose.yml down -v

# View logs
docker compose -f srcs/docker-compose.yml logs -f

# View specific service logs
docker compose -f srcs/docker-compose.yml logs -f wordpress

# Check config
docker compose -f srcs/docker-compose.yml config
```

# Container Commands

## List Containers

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# List with custom format
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Inspect container details
docker inspect nginx
docker inspect wordpress
docker inspect mariadb
```

## Enter Containers

```bash
# Enter WordPress container
docker exec -it wordpress sh

# Enter MariaDB container
docker exec -it mariadb sh

# Enter Redis container
docker exec -it redis sh

# Enter Nginx container
docker exec -it nginx sh

# Enter FTP container
docker exec -it ftp-server sh

# Enter Portainer container
docker exec -it portainer sh

# Exit container
exit
```

## Logs

```bash
# View all logs
docker logs nginx
docker logs wordpress
docker logs mariadb

# View last 50 lines
docker logs wordpress --tail 50

# Follow logs in real-time
docker logs -f wordpress

# View with timestamps
docker logs -t wordpress

# View since last hour
docker logs --since 1h wordpress
```

# WordPress WP-CLI

## Basic WP-CLI Commands

```bash
# Enter WordPress container
docker exec -it wordpress sh

# Inside container, run:
wp --info
wp core version
wp plugin list
wp theme list
```
## User Management
```bash
# List all users
docker exec wordpress wp user list --allow-root

# Create user
docker exec wordpress wp user create newuser email@test.com --user_pass=password --allow-root

# Delete user
docker exec wordpress wp user delete 2 --allow-root

# Update user password
docker exec wordpress wp user update 1 --user_pass=newpass --allow-root
```
## Post Management

```bash
# List posts
docker exec wordpress wp post list --allow-root

# Create post
docker exec wordpress wp post create --post_title="Hello World" --post_content="Content here" --post_status=publish --allow-root

# Delete post
docker exec wordpress wp post delete 1 --force --allow-root

# Update post
docker exec wordpress wp post update 1 --post_title="New Title" --allow-root
```


## Plugins

```bash
# List plugins
docker exec wordpress wp plugin list --allow-root

# Install plugin
docker exec wordpress wp plugin install redis-cache --activate --allow-root

# Deactivate plugin
docker exec wordpress wp plugin deactivate redis-cache --allow-root

# Uninstall plugin
docker exec wordpress wp plugin uninstall redis-cache --allow-root
```

## Database

```bash
# Check database
docker exec wordpress wp db check --allow-root

# Repair database
docker exec wordpress wp db repair --allow-root

# Optimize database
docker exec wordpress wp db optimize --allow-root

# Export database
docker exec wordpress wp db export backup.sql --allow-root
```
## Redis Cache Commands

```bash
# Check Redis status
docker exec wordpress wp redis status --allow-root

# Enable Redis
docker exec wordpress wp redis enable --allow-root

# Disable Redis
docker exec wordpress wp redis disable --allow-root

# Check Redis connection
docker exec wordpress wp redis info --allow-root
```


# MariaDB Commands

## Login

```bash
# Login as root
docker exec -it mariadb mysql -u root -p
# Enter password from secrets/db_root_password.txt

# Login as wpuser
docker exec -it mariadb mysql -u wpuser -p
# Enter password from secrets/db_password.txt

# Login directly to wordpress database
docker exec -it mariadb mysql -u root -p$(cat secrets/db_root_password.txt) wordpress
```

## Queries

```bash
# Show all databases
docker exec mariadb mysql -u root -p$(cat secrets/db_root_password.txt) -e "SHOW DATABASES;"

# Show all tables
docker exec mariadb mysql -u root -p$(cat secrets/db_root_password.txt) -e "USE wordpress; SHOW TABLES;"

# Show users table
docker exec mariadb mysql -u root -p$(cat secrets/db_root_password.txt) -e "USE wordpress; SELECT * FROM wp_users;"

# Show all users
docker exec mariadb mysql -u root -p$(cat secrets/db_root_password.txt) -e "SELECT user, host FROM mysql.user;"
```

## Database Backup and Restore

```bash
# Backup entire database
docker exec mariadb mysqldump -u root -p$(cat secrets/db_root_password.txt) --all-databases > all-databases-backup.sql

# Backup only wordpress database
docker exec mariadb mysqldump -u root -p$(cat secrets/db_root_password.txt) wordpress > wordpress-backup.sql

# Restore database
cat wordpress-backup.sql | docker exec -i mariadb mysql -u root -p$(cat secrets/db_root_password.txt) wordpress

# Create database manually
docker exec mariadb mysql -u root -p$(cat secrets/db_root_password.txt) -e "CREATE DATABASE testdb;"

# Drop database
docker exec mariadb mysql -u root -p$(cat secrets/db_root_password.txt) -e "DROP DATABASE testdb;"
```

# Redis CLI

```bash
# Enter Redis CLI
docker exec -it redis sh
redis-cli -a redis123

# Or directly
docker exec redis redis-cli -a redis123
```
# Redis Operation

```bash
# Ping test
docker exec redis redis-cli -a redis123 ping

# Get server info
docker exec redis redis-cli -a redis123 INFO server

# Get stats
docker exec redis redis-cli -a redis123 INFO stats

# Get memory info
docker exec redis redis-cli -a redis123 INFO memory

# Get all keys
docker exec redis redis-cli -a redis123 KEYS "*"

# Get specific key
docker exec redis redis-cli -a redis123 GET "keyname"

# Set key
docker exec redis redis-cli -a redis123 SET testkey "Hello"

# Delete key
docker exec redis redis-cli -a redis123 DEL testkey

# Flush all cache
docker exec redis redis-cli -a redis123 FLUSHALL

# Monitor Redis in real-time
docker exec redis redis-cli -a redis123 MONITOR
```

# Nginx Commands

```bash
# Test nginx configuration
docker exec nginx nginx -t

# Reload nginx (graceful)
docker exec nginx nginx -s reload

# Stop nginx
docker exec nginx nginx -s stop

# Show nginx version
docker exec nginx nginx -v

# Show nginx compile options
docker exec nginx nginx -V
```
## Logs

```bash
# Access log
docker exec nginx cat /var/log/nginx/access.log

# Error log
docker exec nginx cat /var/log/nginx/error.log

# Follow access log
docker exec nginx tail -f /var/log/nginx/access.log
```

# FTP Commands

```bash
# Connect via FTP (plain)
ftp localhost 21

# Connect via lftp
lftp -u ftpuser,ftp123 localhost

# Connect with SSL
lftp -u ftpuser,ftp123 -e "set ftp:ssl-force true; set ssl:verify-certificate no; ls; quit" localhost
```

## FTP operation

```bash
# Upload file
echo "test" > /tmp/test.txt
ftp -n localhost 21 << EOF
user ftpuser ftp123
put /tmp/test.txt test.txt
quit
EOF

# Download file
ftp -n localhost 21 << EOF
user ftpuser ftp123
get test.txt /tmp/downloaded.txt
quit
EOF

# List files
ftp -n localhost 21 << EOF
user ftpuser ftp123
ls
quit
EOF

# Delete file
ftp -n localhost 21 << EOF
user ftpuser ftp123
delete test.txt
quit
EOF
```
## FTP Password Management
```
# Reset FTP password
docker exec ftp-server sh -c 'echo "ftpuser:newpassword" | chpasswd'

# Check FTP logs
docker exec ftp-server cat /var/log/vsftpd.log
```


# Docker Volumes

```bash
# List all volumes
docker volume ls

# Inspect WordPress volume
docker volume inspect wp_volume

# Inspect database volume
docker volume inspect db_volume

# Inspect Portainer volume
docker volume inspect portainer_data
```
# Volume Backup and Restore

```bash
# Backup WordPress volume
docker run --rm -v wp_volume:/source -v $(pwd):/backup alpine tar czf /backup/wp_volume_backup.tar.gz -C /source .

# Restore WordPress volume
docker run --rm -v wp_volume:/target -v $(pwd):/backup alpine tar xzf /backup/wp_volume_backup.tar.gz -C /target

# View volume contents
docker run --rm -v wp_volume:/data alpine ls -la /data/

# Copy file from volume
docker run --rm -v wp_volume:/source alpine cat /source/wp-config.php > wp-config-backup.txt

# Remove volume
docker volume rm wp_volume

# Remove all unused volumes
docker volume prune
```

# Docker Networks

```bash
# List networks
docker network ls

# Inspect inception_network
docker network inspect inception_network

# Check containers on network
docker network inspect inception_network | grep -A 5 "Containers"

# Test connectivity
docker exec wordpress ping mariadb
docker exec wordpress ping redis
docker exec nginx ping wordpress

# Check DNS resolution
docker exec wordpress nslookup mariadb
docker exec wordpress nslookup redis
```

# Image Management Commands

```bash
# List all images
docker images

# List images with custom format
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# Remove specific image
docker rmi srcs-wordpress

# Remove all unused images
docker image prune

# Remove all images
docker rmi -f $(docker images -q)

# Build image manually
docker build -t custom-image srcs/requirements/wordpress/
```
## System Cleanup Commands
```bash
# Remove all stopped containers
docker container prune

# Remove all unused images
docker image prune

# Remove all unused volumes
docker volume prune

# Remove all unused networks
docker network prune

# Remove everything unused
docker system prune

# Remove everything including volumes
docker system prune -a --volumes

# Complete project cleanup
cd ~/inception
make fclean

# Reset Docker completely
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi -f $(docker images -q)
docker volume rm $(docker volume ls -q)
docker network rm $(docker network ls -q)
```

# SSL/TLS Certificate

## Generate Certificate

```bash
openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout inception.key \
-out inception.crt \
-subj "/C=MA/ST=Casablanca/L=Casablanca/O=1337/CN=mtarza.42.fr"
```

## Verify Certificate

```bash
openssl x509 -in inception.crt -text -noout
```
## Port Checking
```bash
# Check listening ports
sudo netstat -tlnp | grep -E ":(443|8080|8081|9443|21)"

# Check Docker port mappings
docker port nginx
docker port adminer
docker port portainer

# Check all ports
docker ps --format "table {{.Names}}\t{{.Ports}}"
```
## Process Monitoring

```bash
# Check CPU/Memory usage
docker stats

# Check specific container
docker stats nginx

# View container processes
docker exec nginx ps aux
docker exec wordpress ps aux
docker exec mariadb ps aux
```


# Docker Secrets

## Secret Paths

```txt
/run/secrets/db_root_password
/run/secrets/db_password
/run/secrets/wp_admin_password
/run/secrets/wp_user_password
/run/secrets/ftp_password
```

## Read Secret

```bash
cat /run/secrets/db_password
```

# Healthchecks

```bash
docker ps
docker exec mariadb mysqladmin ping -u root -p$(cat secrets/db_root_password.txt)
docker exec nginx nginx -t
```

# Security Best Practices

- Use Docker secrets instead of environment variables
- Disable root SSH login
- Use TLSv1.2/TLSv1.3 only
- Keep containers isolated using bridge networks
- Use non-root users when possible
- Never commit secrets to git

# Troubleshooting

## Port Already Used

```bash
sudo lsof -i :443
sudo kill <PID>
```

## Docker Permission

```bash
sudo usermod -aG docker $USER
newgrp docker
```

## Rebuild Without Cache

```bash
docker compose build --no-cache
```

# Quick Reference

| Task | Command |
|------|----------|
| Start project | make all |
| Stop project | make down |
| Rebuild everything | make re |
| Show logs | make logs |
| Enter WordPress | docker exec -it wordpress sh |
| Enter MariaDB | docker exec -it mariadb sh |
| Check Redis | docker exec redis redis-cli ping |
| Test HTTPS | curl -k https://mtarza.42.fr |
