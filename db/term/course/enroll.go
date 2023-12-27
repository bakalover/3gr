package course

import (
	"database/sql"
	"log"
	"net/http"
	"strconv"
	"time"
)

func Enroll(w http.ResponseWriter, r *http.Request, db *sql.DB, student_id string, course_id string) {
	student_id_parsed, err := strconv.Atoi(student_id)
	if err != nil {
		http.Error(w, "Invalid student id", http.StatusBadRequest)
		return
	}

	course_id_parsed, err := strconv.Atoi(course_id)
	if err != nil {
		http.Error(w, "Invalid course id", http.StatusBadRequest)
		return
	}

	_, err = db.Query("INSERT INTO enrollments(student_id, course_id, enrollment_d) VALUES($1,$2,$3) ",
		student_id_parsed,
		course_id_parsed,
		time.Now(),
	)

	if err != nil {
		log.Println(err)
		http.Error(w, "You need to pay to enroll to the course!", http.StatusBadRequest)
		return
	}

	_, err = db.Query("INSERT INTO progress(student_id, course_id, progress_val) VALUES($1, $2, 0)",
		student_id_parsed,
		course_id_parsed,
	)

	if err != nil {
		log.Println(err)
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}
