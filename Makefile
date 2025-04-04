# -------------------------------
# 🌐 Docker & Dev Configurations
# -------------------------------

# PostgreSQL Config
PG_CONTAINER_NAME ?= MegaPostgresqlContainer
PG_DATABASE_NAME ?= GotthPostgresDB
PG_DATABASE_USERNAME ?= postgres
PG_DATABASE_PASSWORD ?= GotthDatabaseSecret
PG_IMAGE_TAG ?= 16-alpine
POSTGRES_PASSWORD ?= GotthPostgresSecret

# MongoDB Configuration
MONGO_CONTAINER_NAME ?= MegaMongoContainer
MONGO_PORT ?= 27017
MONGO_IMAGE_TAG ?= 7.0
MONGO_USERNAME ?= root
MONGO_PASSWORD ?= GotthMongoSecret
MONGO_DB_NAME ?= GotthMongoDB

# Redis Config
REDIS_CONTAINER_NAME ?= MegaRedisContainer
REDIS_PORT ?= 6379
REDIS_IMAGE_TAG ?= 7-alpine
REDIS_PASSWORD ?= GotthRedisSecret

# -------------------------------
# 🐳 PostgreSQL Container Commands
# -------------------------------
runcntr: ## Run PostgreSQL container (shared)
	docker run --name $(PG_CONTAINER_NAME) -p 5432:5432 -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) -d postgres:$(PG_IMAGE_TAG)

strcntr: ## Start PostgreSQL container
	docker start $(PG_CONTAINER_NAME)

stpcntr: ## Stop PostgreSQL container
	docker stop $(PG_CONTAINER_NAME)

rmvcntr: ## Remove PostgreSQL container
	docker rm $(PG_CONTAINER_NAME)

rmvpgvol: ## Remove PostgreSQL container volume
	docker volume rm $(PG_CONTAINER_NAME)

crtdb: ## Create PostgreSQL database
	docker exec -it $(PG_CONTAINER_NAME) createdb -U $(PG_DATABASE_USERNAME) $(PG_DATABASE_NAME)

drpdb: ## Drop PostgreSQL database
	docker exec -it $(PG_CONTAINER_NAME) dropdb -U $(PG_DATABASE_USERNAME) $(PG_DATABASE_NAME)

# -------------------------------
# 🍃 MongoDB Container Commands
# -------------------------------
runmongo: ## Run MongoDB container
	docker run --name $(MONGO_CONTAINER_NAME) -p $(MONGO_PORT):27017 \
	-e MONGO_INITDB_ROOT_USERNAME=$(MONGO_USERNAME) \
	-e MONGO_INITDB_ROOT_PASSWORD=$(MONGO_PASSWORD) \
	-d mongo:$(MONGO_IMAGE_TAG)

strmongo: ## Start MongoDB container
	docker start $(MONGO_CONTAINER_NAME)

stpmongo: ## Stop MongoDB container
	docker stop $(MONGO_CONTAINER_NAME)

rmvmongo: ## Remove MongoDB container
	docker rm $(MONGO_CONTAINER_NAME)

rmvmongovol: ## Remove MongoDB container volume
	docker volume rm $(MONGO_CONTAINER_NAME)

mongocli: ## Open MongoDB shell
	docker exec -it $(MONGO_CONTAINER_NAME) mongosh -u $(MONGO_USERNAME) -p $(MONGO_PASSWORD)

# -------------------------------
# 🐳 Redis Container Commands
# -------------------------------
runredis: ## Run Redis container
	docker run --name $(REDIS_CONTAINER_NAME) -p $(REDIS_PORT):6379 \
	-e REDIS_PASSWORD=$(REDIS_PASSWORD) -d redis:$(REDIS_IMAGE_TAG) \
	redis-server --requirepass $(REDIS_PASSWORD)

strredis: ## Start Redis container
	docker start $(REDIS_CONTAINER_NAME)

stpredis: ## Stop Redis container
	docker stop $(REDIS_CONTAINER_NAME)

rmvredis: ## Remove Redis container
	docker rm $(REDIS_CONTAINER_NAME)

rmvrdvol: ## Remove Redis container volume
	docker volume rm $(REDIS_CONTAINER_NAME)

rediscli: ## Open Redis CLI with password
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
tmpl: ## Run templ generate
	templ generate

twc: ## Build Tailwind CSS
	twc -i ./static/css/index.css -o ./static/css/style.css

run: ## Build and run Go server
	go build -o ./tmp/gotth ./main.go && ./tmp/gotth

gun: ## Generate templ, compile Tailwind, run Go server
	$(MAKE) tmpl
	$(MAKE) twc
	$(MAKE) run

# -------------------------------
# 🧪 Linting, Testing, Formatting
# -------------------------------
lint: ## Run golangci-lint
	golangci-lint run

test: ## Run Go tests
	go test ./...

fmt: ## Format Go code
	go fmt ./...

pre_cmt: ## Run pre-commit checks (fmt + lint)
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
# 📖 Help
# -------------------------------
help: ## Show all Makefile targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

# -------------------------------
# 📌 Phony Targets
# -------------------------------

# PostgreSQL
.PHONY: runcntr strcntr stpcntr rmvcntr rmvpgvol crtdb drpdb

# MongoDB
.PHONY: runmongo strmongo stpmongo rmvmongo rmvmongovol mongocli

# Redis
.PHONY: runredis strredis stpredis rmvredis rmvrdvol rediscli

# CLI
.PHONY: cnfg completion mgrt seed serv

# Dev Tools
.PHONY: tmpl twc run gun

# Lint/Test/Format
.PHONY: lint test fmt pre_cmt

# Build
.PHONY: build_win build_lin build_mac build

# Help
.PHONY: help
