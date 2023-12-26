package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net/http"
	_ "net/http/pprof"
	"os"
	"os/signal"
	"server/forum"
	"server/users"
	"syscall"

	_ "github.com/lib/pq"
)

func ExecuteScript(db *sql.DB, scriptName string) {
	sqlFile, err := os.ReadFile(fmt.Sprintf("./sql/%s.sql", scriptName))
	if err != nil {
		panic(err)
	}
	db.Exec(string(sqlFile))
}
func main() {

	// Bind 9999 <-> 5432
	// db, err := sql.Open("postgres://username:secret@localhost:9999/studs")
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	db, err := sql.Open("postgres", "postgres://bakalover:bakalover@localhost:5432/mytest")

	if err != nil {
		log.Println(err)
	}
	mux := http.NewServeMux()
	ExecuteScript(db, "create")

	mux.HandleFunc("/api/register", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			users.Register(w, r, db, r.FormValue("username"), r.FormValue("password"))
		} else {
			log.Println("Wrong method on register")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/login", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			users.Login(w, r, db, r.FormValue("username"), r.FormValue("password"))
		} else {
			log.Println("Wrong method on login")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/forum/createtopic", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			forum.CreateTopic(w, r, db, r.FormValue("topic"), r.FormValue("descript"))
		} else {
			log.Println("Wrong method on addpost")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/forum/gettopic", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			forum.GetTopic(w, r, db, r.FormValue("topic"))
		} else {
			log.Println("Wrong method on gettopic")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/forum/getalltopics", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			forum.GetAllTopics(w, r, db)
		} else {
			log.Println("Wrong method on getalltopics")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/forum/addpost", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			forum.AddPost(w, r, db, r.FormValue("topic"), r.FormValue("username"), r.FormValue("content"))
		} else {
			log.Println("Wrong method on addpost")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/forum/getposts", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			forum.GetPosts(w, r, db, r.FormValue("topic"), r.FormValue("username"))
		} else {
			log.Println("Wrong method on getposts")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/forum/getallpost", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			forum.GetAllPosts(w, r, db)
		} else {
			log.Println("Wrong method on getallpost")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	server := &http.Server{Addr: ":9999", Handler: mux}

	// Separate goroutine for graceful shutdown
	go func() {
		err := server.ListenAndServe()
		log.Println(err)
	}()

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM, syscall.SIGINT)
	<-c
	// Shutdown the server
	if err := server.Shutdown(ctx); err != nil {
		log.Printf("Server shutdown: %s", err)
	}

	// fs := http.FileServer(http.Dir("static/"))
	// http.Handle("/static/", http.StripPrefix("/static/", fs))

	ExecuteScript(db, "delete")
	db.Close()
	log.Println("Goodbye!")
}
