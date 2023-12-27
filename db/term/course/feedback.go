package course

import (
	"database/sql"
	"log"
	"net/http"
	"strconv"
)

func AddFeedback(w http.ResponseWriter, r *http.Request, db *sql.DB, student_id string, course_id string, feedback_val string) {
	
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


	_, err = db.Query("INSERT INTO feedbacks(student_id, course_id, feedback_val) VALUES($1,$2,$3)",
		student_id_parsed,
		course_id_parsed,
		feedback_val,
	)

	if err != nil {
		log.Println(err)
		http.Error(w, "Complete course to send feedback!", http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusOK)

}
