*This project has been created as part of the 42 curriculum by mtarza*

# Inception

## Foreword

This project aims to expand knowledge in system administration using Docker and Docker Compose by building a complete virtualized web infrastructure inside a virtual machine.

---

# What is Inception?

Inception is a system administration project from the 42/1337 curriculum that requires creating a secure and scalable infrastructure using Docker containers.

The project consists of multiple isolated services communicating through Docker networks:

- NGINX with TLSv1.2 / TLSv1.3
- WordPress with PHP-FPM
- MariaDB database
- Redis cache
- FTP server
- Adminer
- Static website
- Portainer

Each service runs inside its own dedicated container and all services are orchestrated using Docker Compose.

---

# Architecture

```txt
                    ┌──────────────────────┐
                    │      INTERNET        │
                    └──────────┬───────────┘
                               │
                         Port 443 (TLS)
                               │
                    ┌──────────▼───────────┐
                    │        NGINX         │
                    │ Reverse Proxy + SSL  │
                    └──────────┬───────────┘
                               │
                 ┌─────────────┴─────────────┐
                 │                           │
        ┌────────▼────────┐         ┌────────▼────────┐
        │   WORDPRESS     │         │   STATIC SITE   │
        │     PHP-FPM     │         │     HTML/CSS    │
        └────────┬────────┘         └─────────────────┘
                 │
        ┌────────▼────────┐
        │     REDIS       │
        │      CACHE      │
        └────────┬────────┘
                 │
        ┌────────▼────────┐
        │    MARIADB      │
        │    DATABASE     │
        └─────────────────┘
```

---

# Services Provided

| Service | Description | Access |
|---|---|---|
| NGINX | Reverse proxy with SSL/TLS | Port 443 |
| WordPress | CMS running with PHP-FPM | Internal Port 9000 |
| MariaDB | Relational database | Internal Port 3306 |
| Redis | WordPress cache system | Internal Port 6379 |
| FTP Server | File transfer service | Port 21 |
| Adminer | Database management interface | Port 8080 |
| Static Website | Portfolio showcase website | Port 8081 |
| Portainer | Docker management dashboard | Port 9443 |

---

# Goal

The objective of this project is to:

- Learn Docker fundamentals
- Build isolated services using containers
- Configure Docker networking
- Configure persistent volumes
- Use Docker Compose
- Understand web infrastructure
- Configure SSL/TLS with NGINX
- Manage services securely

---

# Mandatory Part

The mandatory part includes:

- A Docker container containing NGINX only
- A Docker container containing WordPress + PHP-FPM only
- A Docker container containing MariaDB only
- Persistent Docker volumes
- Docker bridge networking
- TLSv1.2 or TLSv1.3 only
- Environment variables stored inside `.env`
- No passwords inside Dockerfiles
- Automatic restart policy

---

# Bonus Part

Implemented bonuses:

- Redis cache
- FTP server
- Adminer
- Static website
- Portainer

---

# Installation

## Clone Repository

```bash
git clone <your-repository-url> inception
cd inception
```

---

# Create Secrets

```bash
mkdir -p secrets

echo "root_$(openssl rand -base64 12 | sed 's/\//_/g')" > secrets/db_root_password.txt
echo "wpuser_$(openssl rand -base64 12 | sed 's/\//_/g')" > secrets/db_password.txt
echo "supervisor_$(openssl rand -base64 12 | sed 's/\//_/g')" > secrets/wp_admin_password.txt
echo "editor_$(openssl rand -base64 12 | sed 's/\//_/g')" > secrets/wp_user_password.txt
echo "ftpuser_$(openssl rand -base64 12 | sed 's/\//_/g')" > secrets/ftp_password.txt

chmod 600 secrets/*.txt
```

---

# Configure Hosts File

```bash
echo "127.0.0.1 mtarza.42.fr" | sudo tee -a /etc/hosts
```

---

# Build and Start Project

```bash
make all
```

---

# Access Services

| Service | URL |
|---|---|
| WordPress | https://mtarza.42.fr |
| WordPress Admin | https://mtarza.42.fr/wp-admin |
| Adminer | http://mtarza.42.fr:8080 |
| Static Website | http://mtarza.42.fr:8081 |
| Portainer | https://mtarza.42.fr:9443 |
| FTP | ftps://mtarza.42.fr:21 |

---

# Makefile Commands

| Command | Description |
|---|---|
| make all | Build and start containers |
| make build | Build Docker images |
| make up | Start containers |
| make down | Stop containers |
| make clean | Remove containers and volumes |
| make fclean | Remove everything |
| make re | Rebuild project |
| make logs | Show logs |
| make status | Show container status |

---

# Docker

## What is Docker?

Docker is an open-source platform used to develop, ship, and run applications inside lightweight isolated containers.

Unlike traditional virtual machines, Docker containers share the host kernel, making them:

- Lightweight
- Fast
- Portable
- Easy to deploy

---

# Virtual Machines vs Docker

| Virtual Machines | Docker |
|---|---|
| Full guest operating system | Shared host kernel |
| Heavy resource usage | Lightweight |
| Slow startup | Fast startup |
| Large disk size | Small image size |
| Hardware virtualization | Process isolation |

---

# Secrets vs Environment Variables

## Environment Variables

Environment variables can be exposed through:

- Logs
- Process inspection
- Docker inspect

## Docker Secrets

Docker secrets are:

- Mounted securely as files
- Hidden from inspect output
- Accessible only to authorized containers

---

# Docker Networks

This project uses a user-defined bridge network.

Advantages:

- Automatic DNS resolution
- Better isolation
- Secure inter-container communication

---

# Docker Volumes vs Bind Mounts

## Bind Mounts

- Depend on host filesystem
- Less portable

## Docker Volumes

- Managed by Docker
- Better performance
- Easier backups
- Persistent storage

---

# NGINX

NGINX acts as:

- Reverse proxy
- SSL termination server
- Static file server

Only port 443 is exposed publicly.

TLSv1.2 and TLSv1.3 are enabled.

---

# WordPress + PHP-FPM

WordPress runs with PHP-FPM.

PHP-FPM processes PHP requests while NGINX handles HTTP requests.

Benefits:

- Better performance
- Separation of concerns
- Scalability

---

# MariaDB

MariaDB stores:

- WordPress users
- Posts
- Settings
- Metadata

Persistent data is stored using Docker volumes.

---

# Redis

Redis is used to cache WordPress queries and improve performance.

---

# FTP Server

The FTP server provides access to WordPress files stored in the shared Docker volume.

---

# Portainer

Portainer provides a web dashboard to:

- Manage containers
- View logs
- Manage volumes
- Monitor Docker services

---

# AI Usage

AI was used for:

- Documentation structure
- Docimntartion 


All generated content was reviewed, tested, and fully understood before use.

---

# Useful Commands

## Show Running Containers

```bash
docker ps
```

## Show Logs

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

## Restart Service

```bash
docker restart wordpress
```

## Inspect Networks

```bash
docker network ls
docker network inspect inception_network
```

---

# Resources

- Docker Documentation: https://docs.docker.com/
- Docker Compose: https://docs.docker.com/compose/
- NGINX Documentation: https://nginx.org/en/docs/
- MariaDB Documentation: https://mariadb.com/docs/
- WordPress CLI: https://developer.wordpress.org/cli/commands/
- Redis Documentation: https://redis.io/docs/

---

# Conclusion

This project provides hands-on experience with:

- Docker
- System administration
- Web infrastructure
- Networking
- Volumes
- Reverse proxies
- SSL/TLS
- Service orchestration

It also introduces best practices for scalable and maintainable infrastructures.
