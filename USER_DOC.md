# User Documentation - Inception Project

## Overview

This project provides a complete WordPress website running in Docker containers. The infrastructure includes:

- 🌐 **WordPress Website** - Your blog/content management system
- 🗄️ **MariaDB Database** - Stores all your content
- 🔒 **SSL/TLS Security** - Encrypted HTTPS connection
- 🛠️ **Adminer** - Web-based database management
- 📁 **FTP Server** - Upload files to your website
- 🐳 **Portainer** - Docker management interface
- ⚡ **Redis Cache** - Speed up your website
- 🎨 **Static Website** - Personal portfolio

## Quick Start

### First Time Setup

```bash
# Clone the repository
git clone <your-repo-url> inception
cd inception

# Generate passwords (secrets)
mkdir -p secrets
echo "root_$(openssl rand -base64 12 | sed 's/\//_/g')" > secrets/db_root_password.txt
echo "wpuser_$(openssl rand -base64 12 | sed 's/\//_/g')" > secrets/db_password.txt
echo "supervisor_$(openssl rand -base64 12 | sed 's/\//_/g')" > secrets/wp_admin_password.txt
echo "editor_$(openssl rand -base64 12 | sed 's/\//_/g')" > secrets/wp_user_password.txt
echo "ftpuser_$(openssl rand -base64 12 | sed 's/\//_/g')" > secrets/ftp_password.txt
chmod 600 secrets/*.txt

# Add domain to hosts file
echo "127.0.0.1 mtarza.42.fr" | sudo tee -a /etc/hosts

# Build and start all services
make all
```

## Everyday Use

```bash
make up
make down
make restart
make re
```

## Accessing Services

### WordPress

URL: https://mtarza.42.fr

### WordPress Admin

URL: https://mtarza.42.fr/wp-admin

### Adminer

URL: http://mtarza.42.fr:8080

### Portainer

URL: https://mtarza.42.fr:9443

### FTP

Host: mtarza.42.fr
Port: 21

## Managing Credentials

```bash
ls -la ~/inception/secrets/
cat ~/inception/secrets/wp_admin_password.txt
```

## Checking Service Status

```bash
make status
docker ps
make logs
```

## Troubleshooting

```bash
docker logs nginx
docker restart wordpress
docker restart mariadb
```

## Stopping the Project

```bash
make down
make clean
make fclean
```
