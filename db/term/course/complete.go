package course

import (
	"database/sql"
	"log"
	"net/http"
	"strconv"
)

func CompleteQuiz(w http.ResponseWriter, r *http.Request, db *sql.DB, lesson_id string, student_id string) {
	student_id_parsed, err := strconv.Atoi(student_id)
	if err != nil {
		http.Error(w, "Invalid student id", http.StatusBadRequest)
		return
	}
	lesson_id_parsed, err := strconv.Atoi(lesson_id)
	if err != nil {
		http.Error(w, "Invalid lesson id", http.StatusBadRequest)
		return
	}

	_, err = db.Query("SELECT complete_quiz($1,$2)",
		lesson_id_parsed,
		student_id_parsed,
	)

	if err != nil {
		log.Println(err)
		http.Error(w, "Bad arguments for quiz completion", http.StatusBadRequest)
	}
}

func CompleteLesson(w http.ResponseWriter, r *http.Request, db *sql.DB, lesson_id string, student_id string) {
	student_id_parsed, err := strconv.Atoi(student_id)
	if err != nil {
		http.Error(w, "Invalid student id", http.StatusBadRequest)
		return
	}
	lesson_id_parsed, err := strconv.Atoi(lesson_id)
	if err != nil {
		http.Error(w, "Invalid lesson id", http.StatusBadRequest)
		return
	}

	_, err = db.Query("SELECT complete_lesson($1,$2)",
		lesson_id_parsed,
		student_id_parsed,
	)

	if err != nil {
		log.Println(err)
		http.Error(w, "Bad arguments for lesson completion", http.StatusBadRequest)
	}
}
