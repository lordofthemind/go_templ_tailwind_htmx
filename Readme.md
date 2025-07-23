# 🌱 Gotth: Go + Templ + Tailwind CSS + HTMX Starter Kit

> Lightweight, fast, and modern starter stack to build web UIs with Go — zero JavaScript, just HTML and magic.

---

## 🛠️ Tech Stack

- **Golang**: Backend and HTTP server
- **Templ**: Type-safe HTML templating in Go
- **Tailwind CSS v4.1.2**: Utility-first CSS framework
- **HTMX**: Add interactivity without writing JS
- **Makefile**: Developer automation for building, testing, running containers, and more
- **Air**: Live-reload development (optional)

---

## 📁 Project Structure

```
.
├── main.go                      # Entry point
├── templates/                  # Templ files (HTML components)
├── static/css/                 # Tailwind styles
├── internal/                   # Modular architecture (handlers, services, repos)
├── resources/                  # Configs, keys, etc.
├── scripts/                    # Utility scripts
├── configs/                    # App config
├── Makefile                    # Developer tasks
└── .air.toml                   # Live-reload config for dev
```

---

## 🚀 Getting Started

### 1. Clone & Setup

```bash
git clone https://github.com/yourusername/go_templ_tailwind_htmx.git
cd go_templ_tailwind_htmx
```

### 2. Install Tailwind CSS CLI

This project uses the **standalone binary** version of Tailwind CLI v4:

```bash
wget https://github.com/tailwindlabs/tailwindcss/releases/download/v4.1.2/tailwindcss-linux-x64
mv tailwindcss-linux-x64 twc
chmod +x twc
sudo mv twc /usr/local/bin/
```

Now you can run Tailwind using:

```bash
twc -i ./static/css/index.css -o ./static/css/style.css
```

> This is automated in the `Makefile` under `make dev_tailwind`.

---

## 💻 Development

### Run everything in one go:

```bash
make dev_runall
```

> This will:
> - Generate Templ HTML (`make dev_templ`)
> - Compile Tailwind CSS (`make dev_tailwind`)
> - Build and start the Go server

Server runs at: [http://localhost:9090](http://localhost:9090)

---

## 🔁 Hot Reload (Optional)

Install `air` for live-reloading Go server:

```bash
go install github.com/cosmtrek/air@latest
```

Then just run:

```bash
air
```

Air is configured via `.air.toml` to auto-build Tailwind, Templ, and Go binary.

---

## 🧩 Features

- ⚡ **Zero-JS Interactivity**: With HTMX for dynamic content updates
- 🧑‍💻 **Type-Safe Templates**: Using [Templ](https://templ.guide)
- 🖼️ **Componentized Layouts**: `Base`, `Nav`, `Footer`, etc.
- 📬 **HTMX Forms**: Signup form powered via HTMX POST
- 🌐 **Modular Go Architecture**: Repositories, Services, Routes, Handlers
- 🐘 **Containerized DB**: PostgreSQL, MongoDB, Redis with simple `make` commands

---

## 🐳 Database Dev Containers

Start all dev DBs at once:

```bash
make dev_up_all
```

Or run each separately:

```bash
make pg_run       # PostgreSQL
make mongo_run    # MongoDB
make redis_run    # Redis
```

Stop and cleanup:

```bash
make dev_down_all
make dev_rm_all
make dev_reset_all  # Removes volumes too
```

---

## 📦 Build & Release

```bash
make build        # Builds for all platforms
make build_win    # Windows
make build_mac    # macOS
make build_lin    # Linux
```

Artifacts are saved under `./builds/`

---

## 📋 Other Useful Commands

```bash
make lint          # Run golangci-lint
make test          # Run tests
make fmt           # Format code
make dev_precommit # fmt + lint
```

---

## 📄 License

MIT License — see `LICENSE` for details.

---

## 👋 Contributing

PRs, issues, and suggestions are welcome! This is a community-friendly project for anyone diving into the modern Go web stack.

---

## 🙌 Credits

- [Templ](https://templ.guide/)
- [HTMX](https://htmx.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Air](https://github.com/cosmtrek/air)

---

> Built by **Logan @WarHammer** ⚔️
```