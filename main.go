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
	mux.HandleFunc("/about", func(w http.ResponseWriter, r *http.Request) {
		err := templates.AboutPage().Render(r.Context(), w)
		if err != nil {
			http.Error(w, "failed to render about page", http.StatusInternalServerError)
		}
	})

	mux.HandleFunc("/about-fact", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/html")
		w.Write([]byte(`<p>🧠 Fun Fact: HTMX lets you build modern interactivity without JavaScript!</p>`))
	})

	mux.HandleFunc("/signup", func(w http.ResponseWriter, r *http.Request) {
		name := r.FormValue("name")
		email := r.FormValue("email")
		// Normally you'd store this in a DB
		w.Header().Set("Content-Type", "text/html")
		w.Write([]byte("<p>✅ Thanks, " + name + "! We'll reach out at " + email + ".</p>"))
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
