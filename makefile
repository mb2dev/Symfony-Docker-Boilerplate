# Variables
DOCKER = docker
DOCKER_COMPOSE = docker compose
PHP_FPM_CONTAINER = php-fpm
NGINX_CONTAINER = nginx
EXEC = $(DOCKER) exec -it $(PHP_FPM_CONTAINER)
PHP = $(EXEC) php
COMPOSER = $(EXEC) composer
SYMFONY_CONSOLE = $(PHP) bin/console

# Colors
BLUE = echo -e "\033[34m$1\033[0m"

## —— 🚀 App —————————————————————————————————————————————————————————————————
init: ## Init a new Symfony Project
	mkdir -p ./app
	$(MAKE) build
	$(MAKE) start
	$(COMPOSER) create-project symfony/skeleton:"7.0.*" .
	@$(call BLUE,"The application is available at: http://127.0.0.1:8080/.")

cc: ## Clear cache
	$(SYMFONY_CONSOLE) cache:clear

## —— 🎻 Composer ——
Dependencies ?=

composer-install: ## Install dependencies
	$(COMPOSER) install

composer-update: ## Update dependencies
	$(COMPOSER) update

composer-clear-cache: ## clear-cache dependencies
	$(COMPOSER) clear-cache

## —— 🐳 Docker —————————————————————————————————————————————————————————————————
build: ## Build app with Images
	$(DOCKER_COMPOSE) build

rebuild: ## Stops and removes containers, volumes, and orphaned networks, then rebuilds the services
	$(DOCKER_COMPOSE) down --volumes --remove-orphans
	$(DOCKER_COMPOSE) up --build -d

start: ## Start the app
	$(DOCKER_COMPOSE) up -d

stop: ## Stop the app
	$(DOCKER_COMPOSE) stop

prune: ## Removes all unused volumes to free up space
	$(DOCKER_COMPOSE) down -v

logs: ## Display the container logs
	$(DOCKER_COMPOSE) logs -f

exec-php-fpm: ## Opens an interactive bash shell inside the php-fpm container
	$(DOCKER_COMPOSE) exec $(PHP_FPM_CONTAINER) bash

exec-nginx: ## Opens an interactive bash shell inside the php-fpm container
	$(DOCKER_COMPOSE) exec $(NGINX_CONTAINER) sh

## —— ⚙️  Others —————————————————————————————————————————————————————————————————
help: ## List of commands
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'