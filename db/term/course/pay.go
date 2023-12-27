package course

import (
	"database/sql"
	"log"
	"net/http"
	"strconv"
	"time"
)

func Pay(w http.ResponseWriter, r *http.Request, db *sql.DB, student_id string, course_id string, amount string) {
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

	amount_parsed, err := strconv.Atoi(amount)

	if err != nil {
		http.Error(w, "Invalid amount", http.StatusBadRequest)
		return
	}

	_, err = db.Query("INSERT INTO payments(student_id, course_id, amount, payment_date) VALUES($1,$2,$3,$4) ",
		student_id_parsed,
		course_id_parsed,
		amount_parsed,
		time.Now(),
	)

	if err != nil {
		log.Println(err)
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}
