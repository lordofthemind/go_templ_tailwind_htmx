package main

import (
	"log"
	"net/http"

	"github.com/a-h/templ"
	"github.com/lordofthemind/go_templ_tailwind_htmx/templates"
)

func main() {
	mux := http.NewServeMux()

	// Serve static files
	fs := http.FileServer(http.Dir("static"))
	mux.Handle("/static/", http.StripPrefix("/static/", fs))

	// Routes
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		renderTemplate(w, r, templates.IndexPage())
	})

	mux.HandleFunc("/about", func(w http.ResponseWriter, r *http.Request) {
		renderTemplate(w, r, templates.AboutPage())
	})

	mux.HandleFunc("/signup", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPost {
			name := r.FormValue("name")
			email := r.FormValue("email")
			sendHTMXResponse(w, "<p>✅ Thanks, "+name+"! We'll reach out at "+email+".</p>")
			return
		}
		renderTemplate(w, r, templates.SignupPage())
	})

	mux.HandleFunc("/greet", func(w http.ResponseWriter, r *http.Request) {
		renderTemplate(w, r, templates.GreetPage())
	})

	// HTMX endpoints
	mux.HandleFunc("/about-fact", func(w http.ResponseWriter, r *http.Request) {
		sendHTMXResponse(w, `<p>🧠 Fun Fact: HTMX lets you build modern interactivity without JavaScript!</p>`)
	})

	// In your route definitions
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		renderTemplate(w, r, templates.IndexPage())
	})

	// HTMX endpoint (keep this exactly matching the hx-get value)
	mux.HandleFunc("/greet-message", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/html")
		w.Write([]byte(`
        <p class="animate-pulse text-green-600">
            👋 Hello from the server!
            <span class="text-xs block mt-1">(HTMX request successful)</span>
        </p>
    `))
	})

	mux.HandleFunc("/greet-message", handleGreet)

	log.Println("🚀 Server running at http://localhost:9090")
	log.Fatal(http.ListenAndServe(":9090", mux))
}

// Helper functions
func renderTemplate(w http.ResponseWriter, r *http.Request, component templ.Component) {
	w.Header().Set("Content-Type", "text/html")
	if err := component.Render(r.Context(), w); err != nil {
		http.Error(w, "failed to render page", http.StatusInternalServerError)
	}
}

func sendHTMXResponse(w http.ResponseWriter, content string) {
	w.Header().Set("Content-Type", "text/html")
	w.Write([]byte(content))
}

func handleGreet(w http.ResponseWriter, r *http.Request) {
	sendHTMXResponse(w, `
		<p class="animate-pulse text-green-600">
			👋 Hello from Go + HTMX! 
			<span class="text-xs block mt-1">(This message came from the server)</span>
		</p>
	`)
}
