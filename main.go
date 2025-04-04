package main

import (
	"log"
	"net/http"

	"github.com/lordofthemind/go_templ_tailwind_htmx/templates"
)

func main() {
	mux := http.NewServeMux()

	// Serve static files (CSS, JS, images, etc.)
	fs := http.FileServer(http.Dir("static"))
	mux.Handle("/static/", http.StripPrefix("/static/", fs))

	// Serve the Templ-rendered homepage
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		err := templates.IndexPage().Render(r.Context(), w)
		if err != nil {
			http.Error(w, "template rendering failed", http.StatusInternalServerError)
		}
	})

	// Serve the HTMX-interactive endpoint
	mux.HandleFunc("/greet", handleGreet)

	log.Println("🚀 Server running at http://localhost:9090")
	log.Fatal(http.ListenAndServe(":9090", mux))
}

// 👇 Move this out of main!
func handleGreet(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html")
	w.Write([]byte("<p class='animate-pulse'>👋 Hello from Go + HTMX!</p>"))
}
