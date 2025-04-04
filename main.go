package main

import (
	"log"
	"net/http"

	"github.com/lordofthemind/go_templ_tailwind_htmx/templates"
)

func main() {
	mux := http.NewServeMux()

	// Serve static files (CSS)
	fs := http.FileServer(http.Dir("static"))
	mux.Handle("/static/", http.StripPrefix("/static/", fs))

	//hehehe

	// Serve the Templ page
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		err := templates.IndexPage().Render(r.Context(), w)
		if err != nil {
			http.Error(w, "template rendering failed", http.StatusInternalServerError)
		}
	})

	log.Println("Server running at http://localhost:9090")
	log.Fatal(http.ListenAndServe(":9090", mux))
}
