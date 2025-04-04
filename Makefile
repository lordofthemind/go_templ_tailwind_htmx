# Makefile for go_templ_tailwind_htmx project

# Binary commands
TAILWIND = twc
GO = go
TEMPL = templ

# Paths
INPUT_CSS = static/css/index.css
OUTPUT_CSS = static/css/output.css
TEMPLATES_DIR = ./templates/**/*.templ
GO_FILES = ./internal/**/*.go ./main.go ./templates/**/*.go

# Targets

## Run Tailwind in watch mode including .templ and .go files
twc:
	$(TAILWIND) -i $(INPUT_CSS) -o $(OUTPUT_CSS) --watch --content "$(TEMPLATES_DIR)" --content "$(GO_FILES)"

## Run templ generate
templ:
	$(TEMPL) generate

watch:
	twc -i static/css/index.css -o static/css/output.css --watch --content "./templates/**/*.templ" --content "./internal/**/*.go"


## Run Go server
run:
	$(GO) run main.go

gun:
	go build -o ./tmp/gotth ./main.go && air

## Dev: Templ + Tailwind + Run server (each in its own terminal)
dev:
	@echo "🔄 Dev requires 3 terminals:"
	@echo "→ make tailwind"
	@echo "→ make templ && make run"
