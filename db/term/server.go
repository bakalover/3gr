package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"server/course"
	"server/forum"
	"server/stud"
	"server/users"
	"syscall"

	_ "github.com/lib/pq"
)

func ExecuteScript(db *sql.DB, scriptName string) {
	sqlFile, err := os.ReadFile(fmt.Sprintf("./sql/%s.sql", scriptName))
	if err != nil {
		panic(err)
	}
	_, err = db.Exec(string(sqlFile))
	if err != nil {
		log.Println(err)
	} else {
		log.Printf("Successful excuted script: %s", scriptName)
	}
}
func main() {

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// Bind 36999 <-> 5432
	// db, err := sql.Open("postgres",
	// 	fmt.Sprintf("postgres://%s:%s@localhost:36999/studs",
	// 		os.Getenv("ITMO_PG_LOGIN"),
	// 		os.Getenv("ITMO_PG_PASS"),
	// 	),
	// )
	db, err := sql.Open("postgres", "postgres://bakalover:bakalover@localhost:5432/mytest")

	if err != nil {
		log.Println(err)
	}
	mux := http.NewServeMux()
	ExecuteScript(db, "create")
	ExecuteScript(db, "fill")

	// --------------------------------------Users--------------------------------------------

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

	// --------------------------------------Users--------------------------------------------

	// --------------------------------------Students & Staff--------------------------------------------

	mux.HandleFunc("/api/stud/create_group", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			stud.CreateGroup(w, r, db, r.FormValue("group_number"), r.FormValue("faculty"))
		} else {
			log.Println("Wrong method on create_group")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/stud/add_student", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			stud.AddStudent(w, r, db, r.FormValue("full_name"), r.FormValue("group_number"), r.FormValue("username"))
		} else {
			log.Println("Wrong method on add_student")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/stud/get_students", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			stud.GetStudentsByGroup(w, r, db, r.FormValue("group_number"))
		} else {
			log.Println("Wrong method on add_student")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/stud/add_instructor", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			stud.AddInstructor(w, r, db,
				r.FormValue("full_name"),
				r.FormValue("bio"),
				r.FormValue("username"),
				r.FormValue("course_id"),
			)
		} else {
			log.Println("Wrong method on add_instructor")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/stud/get_instructors", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			stud.GetInstructors(w, r, db)
		} else {
			log.Println("Wrong method on get_instructors")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	// --------------------------------------Students & Staff--------------------------------------------

	// --------------------------------------Forum--------------------------------------------

	mux.HandleFunc("/api/forum/create_topic", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			forum.CreateTopic(w, r, db, r.FormValue("topic"), r.FormValue("descript"))
		} else {
			log.Println("Wrong method on create_topic")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/forum/get_topic", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			forum.GetTopic(w, r, db, r.FormValue("topic"))
		} else {
			log.Println("Wrong method onget_topic")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/forum/get_all_topics", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			forum.GetAllTopics(w, r, db)
		} else {
			log.Println("Wrong method on get_all_topics")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/forum/add_post", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			forum.AddPost(w, r, db, r.FormValue("topic"), r.FormValue("username"), r.FormValue("content"))
		} else {
			log.Println("Wrong method on add_post")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/forum/get_posts", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			forum.GetPosts(w, r, db, r.FormValue("topic"), r.FormValue("username"))
		} else {
			log.Println("Wrong method on get_posts")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/forum/get_all_post", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			forum.GetAllPosts(w, r, db)
		} else {
			log.Println("Wrong method on get_all_post")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	// --------------------------------------Forum--------------------------------------------

	// --------------------------------------Course--------------------------------------------

	mux.HandleFunc("/api/course/pay", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			course.Pay(w, r, db, r.FormValue("student_id"), r.FormValue("course_id"), r.FormValue("amount"))
		} else {
			log.Println("Wrong method on add_feedback")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/course/get_pay", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			course.GetPay(w, r, db)
		} else {
			log.Println("Wrong method on get_pay")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/course/enroll", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			course.Enroll(w, r, db, r.FormValue("student_id"), r.FormValue("course_id"))
		} else {
			log.Println("Wrong method on add_feedback")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/course/get_enroll", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			course.GetEnroll(w, r, db)
		} else {
			log.Println("Wrong method on get_enroll")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/course/add_feedback", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			course.AddFeedback(w, r, db, r.FormValue("student_id"), r.FormValue("course_id"), r.FormValue("feedback_val"))
		} else {
			log.Println("Wrong method on add_feedback")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/course/complete_quiz", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			course.CompleteQuiz(w, r, db, r.FormValue("lesson_id"), r.FormValue("student_id"))
		} else {
			log.Println("Wrong method on complete_quizs")
			w.WriteHeader(http.StatusBadRequest)
		}
	})

	mux.HandleFunc("/api/course/complete_lesson", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			course.CompleteLesson(w, r, db, r.FormValue("lesson_id"), r.FormValue("student_id"))
		} else {
			log.Println("Wrong method on complete_lesson")
			w.WriteHeader(http.StatusBadRequest)
		}
	})
	// --------------------------------------Course--------------------------------------------

	server := &http.Server{Addr: ":9999", Handler: mux}

	// Separate goroutine for graceful shutdown
	go func() {
		if err := server.ListenAndServe(); err != http.ErrServerClosed {
			log.Fatal(err)
		}

	}()

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM, syscall.SIGINT)
	<-c // Await ctrl+c ^_^

	if err := server.Shutdown(ctx); err != nil {
		log.Printf("Server shutdown error: %s", err)
	}

	// fs := http.FileServer(http.Dir("static/"))
	// http.Handle("/static/", http.StripPrefix("/static/", fs))

	ExecuteScript(db, "delete")
	db.Close()
	log.Println("Server performed graceful shutdown")
	log.Println("Goodbye!")
}
