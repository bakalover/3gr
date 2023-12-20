package main

import (
	"context"
	"net/http"
	"server/users"

	"github.com/jackc/pgx/v5/pgxpool"
)

func main() {

	// Bind 9999 <-> 5432
	// db, err := pgxpool.New(context.Background(), "postgres://username:secret@localhost:9999/studs")

	db, err := pgxpool.New(context.Background(), "postgres://bakalover:bakalover@localhost:5432/mytest")

	if err != nil {
		panic("Cannot establish database connection!")
	}

	http.HandleFunc("/api/register", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			users.AddNewUser(w, r, db)
		}
	})

	fs := http.FileServer(http.Dir("static/"))
	http.Handle("/static/", http.StripPrefix("/static/", fs))

	http.ListenAndServe(":8080", nil)
}
