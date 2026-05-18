LOGIN := $(shell whoami)
DATA_DIR := /home/$(LOGIN)/data

GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[0;33m
BLUE = \033[0;34m
RESET = \033[0m

COMPOSE_FILE = srcs/docker-compose.yml

all: setup_dirs build up
	@echo "$(GREEN) Inception project is ready!$(RESET)"
	@echo "$(BLUE) WordPress: https://$(LOGIN).42.fr$(RESET)"
	@echo "$(BLUE) Adminer: http://$(LOGIN).42.fr:8080$(RESET)"
	@echo "$(BLUE) Static site: http://$(LOGIN).42.fr:8081$(RESET)"
	@echo "$(BLUE) Portainer: https://$(LOGIN).42.fr:9443$(RESET)"
	@echo "$(BLUE) FTP: ftp://$(LOGIN).42.fr:21 (ftps)$(RESET)"

setup_dirs:
	@echo "$(YELLOW) Creating data directories...$(RESET)"
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	@echo "$(GREEN) Data directories created$(RESET)"

build:
	@echo "$(YELLOW) Building containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) build
	@echo "$(GREEN) Build complete$(RESET)"

up:
	@echo "$(YELLOW) Starting containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN)All containers started$(RESET)"

down:
	@echo "$(YELLOW) Stopping containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down
	@echo "$(GREEN) Containers stopped$(RESET)"

clean: down
	@echo "$(YELLOW) Removing containers and volumes...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down -v
	@echo "$(GREEN) Clean complete$(RESET)"

fclean: clean
	@echo "$(YELLOW)  Removing all images, containers, and cache...$(RESET)"
	@docker system prune -a --volumes -f
	@echo "$(GREEN)Full clean complete$(RESET)"

re: fclean all
	@echo "$(GREEN) Rebuild complete$(RESET)"

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

status:
	@echo "$(BLUE) Container Status:$(RESET)"
	@docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

restart: down up
	@echo "$(GREEN) Restart complete$(RESET)"

.PHONY: all setup_dirs build up down clean fclean re logs status restart

