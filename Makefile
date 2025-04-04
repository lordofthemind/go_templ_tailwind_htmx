# -------------------------------
# 🌐 Docker & Dev Configurations
# -------------------------------

# PostgreSQL Config
PG_CONTAINER_NAME ?= GotthPostgresqlContainer
PG_DATABASE_NAME ?= GotthPostgresDB
PG_DATABASE_USERNAME ?= postgres
PG_DATABASE_PASSWORD ?= GotthDatabaseSecret
PG_IMAGE_TAG ?= 16-alpine
POSTGRES_PASSWORD ?= GotthPostgresSecret

# MongoDB Configuration
MONGO_CONTAINER_NAME ?= GotthMongoContainer
MONGO_PORT ?= 27017
MONGO_IMAGE_TAG ?= 7.0
MONGO_USERNAME ?= root
MONGO_PASSWORD ?= GotthMongoSecret
MONGO_DB_NAME ?= GotthMongoDB

# Redis Config
REDIS_CONTAINER_NAME ?= GotthRedisContainer
REDIS_PORT ?= 6379
REDIS_IMAGE_TAG ?= 7-alpine
REDIS_PASSWORD ?= GotthRedisSecret

# -------------------------------
# 🐘 PostgreSQL Container Commands
# -------------------------------
pg_run: ## Run PostgreSQL container
	docker run --name $(PG_CONTAINER_NAME) -p 5432:5432 -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) -d postgres:$(PG_IMAGE_TAG)

pg_start: ## Start PostgreSQL container
	docker start $(PG_CONTAINER_NAME)

pg_stop: ## Stop PostgreSQL container
	docker stop $(PG_CONTAINER_NAME)

pg_rm: ## Remove PostgreSQL container
	docker rm $(PG_CONTAINER_NAME)

pg_rmvol: ## Remove PostgreSQL container volume
	docker volume rm $(PG_CONTAINER_NAME)

pg_createdb: ## Create PostgreSQL database
	docker exec -it $(PG_CONTAINER_NAME) createdb -U $(PG_DATABASE_USERNAME) $(PG_DATABASE_NAME)

pg_dropdb: ## Drop PostgreSQL database
	docker exec -it $(PG_CONTAINER_NAME) dropdb -U $(PG_DATABASE_USERNAME) $(PG_DATABASE_NAME)

# -------------------------------
# 🍃 MongoDB Container Commands
# -------------------------------
mongo_run: ## Run MongoDB container
	docker run --name $(MONGO_CONTAINER_NAME) -p $(MONGO_PORT):27017 \
	-e MONGO_INITDB_ROOT_USERNAME=$(MONGO_USERNAME) \
	-e MONGO_INITDB_ROOT_PASSWORD=$(MONGO_PASSWORD) \
	-d mongo:$(MONGO_IMAGE_TAG)

mongo_start: ## Start MongoDB container
	docker start $(MONGO_CONTAINER_NAME)

mongo_stop: ## Stop MongoDB container
	docker stop $(MONGO_CONTAINER_NAME)

mongo_rm: ## Remove MongoDB container
	docker rm $(MONGO_CONTAINER_NAME)

mongo_rmvol: ## Remove MongoDB container volume
	docker volume rm $(MONGO_CONTAINER_NAME)

mongo_cli: ## Open MongoDB shell
	docker exec -it $(MONGO_CONTAINER_NAME) mongosh -u $(MONGO_USERNAME) -p $(MONGO_PASSWORD)

# -------------------------------
# 🧊 Redis Container Commands
# -------------------------------
redis_run: ## Run Redis container
	docker run --name $(REDIS_CONTAINER_NAME) -p $(REDIS_PORT):6379 \
	-e REDIS_PASSWORD=$(REDIS_PASSWORD) -d redis:$(REDIS_IMAGE_TAG) \
	redis-server --requirepass $(REDIS_PASSWORD)

redis_start: ## Start Redis container
	docker start $(REDIS_CONTAINER_NAME)

redis_stop: ## Stop Redis container
	docker stop $(REDIS_CONTAINER_NAME)

redis_rm: ## Remove Redis container
	docker rm $(REDIS_CONTAINER_NAME)

redis_rmvol: ## Remove Redis container volume
	docker volume rm $(REDIS_CONTAINER_NAME)

redis_cli: ## Open Redis CLI with password
	docker exec -it $(REDIS_CONTAINER_NAME) redis-cli -a $(REDIS_PASSWORD)

# -------------------------------
# ⚙️ Application CLI Commands
# -------------------------------
cnfg: ## Log configuration
	./builds/linux/Gotth cnfg

completion: ## Generate shell autocompletion script
	./builds/linux/Gotth completion

mgrt: ## Run database migrations
	./builds/linux/Gotth mgrt

seed: ## Run database seeders
	./builds/linux/Gotth seed

serv: ## Start the Gin server
	./builds/linux/Gotth serv

# -------------------------------
# 🎨 Dev Tools
# -------------------------------
dev_templ: ## Run templ generate
	templ generate

dev_tailwind: ## Build Tailwind CSS
	twc -i ./static/css/index.css -o ./static/css/style.css

dev_run: ## Build and run Go server
	go build -o ./tmp/gotth ./main.go && ./tmp/gotth

dev_runall: ## Generate templ, compile Tailwind, run Go server
	$(MAKE) dev_templ
	$(MAKE) dev_tailwind
	$(MAKE) dev_run

# -------------------------------
# 🧪 Linting, Testing, Formatting
# -------------------------------
lint: ## Run golangci-lint
	golangci-lint run

test: ## Run Go tests
	go test ./...

fmt: ## Format Go code
	go fmt ./...

dev_precommit: ## Run pre-commit checks (fmt + lint)
	$(MAKE) fmt
	$(MAKE) lint

# -------------------------------
# 🔨 Build Binaries
# -------------------------------
build_win: ## Build for Windows (amd64)
	GOOS=windows GOARCH=amd64 go build -o ./builds/win/Gotth.exe main.go

build_lin: ## Build for Linux (amd64)
	GOOS=linux GOARCH=amd64 go build -o ./builds/linux/Gotth main.go

build_mac: ## Build for macOS (amd64)
	GOOS=darwin GOARCH=amd64 go build -o ./builds/mac/Gotth main.go

build: ## Build for all platforms
	$(MAKE) build_win
	$(MAKE) build_lin
	$(MAKE) build_mac

# -------------------------------
# 🔁 Container Group Commands
# -------------------------------
dev_up_all: ## Run all containers (Postgres, Mongo, Redis)
	$(MAKE) pg_run
	$(MAKE) mongo_run
	$(MAKE) redis_run

dev_down_all: ## Stop all containers
	-docker stop $(PG_CONTAINER_NAME) $(MONGO_CONTAINER_NAME) $(REDIS_CONTAINER_NAME)

dev_rm_all: ## Remove all containers
	-docker rm $(PG_CONTAINER_NAME) $(MONGO_CONTAINER_NAME) $(REDIS_CONTAINER_NAME)

dev_reset_all: ## Stop, remove containers & volumes
	$(MAKE) dev_down_all
	$(MAKE) dev_rm_all
	-docker volume rm $(PG_CONTAINER_NAME) $(MONGO_CONTAINER_NAME) $(REDIS_CONTAINER_NAME)

dev_clean: ## Clean up build artifacts
	rm -rf tmp builds/*/Gotth*

# -------------------------------
# 📖 Help
# -------------------------------
help: ## Show all Makefile targets
	@grep -E '^[a-zA-Z_/-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-24s\033[0m %s\n", $$1, $$2}'

# -------------------------------
# 📌 Phony Targets
# -------------------------------

# PostgreSQL
.PHONY: pg_run pg_start pg_stop pg_rm pg_rmvol pg_createdb pg_dropdb

# MongoDB
.PHONY: mongo_run mongo_start mongo_stop mongo_rm mongo_rmvol mongo_cli

# Redis
.PHONY: redis_run redis_start redis_stop redis_rm redis_rmvol redis_cli

# CLI
.PHONY: cnfg completion mgrt seed serv

# Dev
.PHONY: dev_templ dev_tailwind dev_run dev_runall dev_up_all dev_down_all dev_rm_all dev_reset_all dev_clean

# Lint/Test/Format
.PHONY: lint test fmt dev_precommit

# Build
.PHONY: build_win build_lin build_mac build

# Help
.PHONY: help
