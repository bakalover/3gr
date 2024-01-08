package stud

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"server/model"
	"strconv"
)

func CheckCourseExistence(db *sql.DB, course_id int16) (bool, error) {
	rows, err := db.Query("SELECT * FROM courses where course_id = $1", course_id)
	return rows.Next(), err
}

func AddInstructor(w http.ResponseWriter, r *http.Request, db *sql.DB, fullname string, bio string, username string, course_id string) {
	course_id_parsed, err := strconv.Atoi(course_id)

	if err != nil {
		http.Error(w, "Invalid course id", http.StatusBadRequest)
		return
	}

	check, err := CheckCourseExistence(db, int16(course_id_parsed))

	if err != nil {
		log.Println(err)
		http.Error(w, "Internal Error", http.StatusInternalServerError)
		return
	}

	if !check {
		http.Error(w, "Course does not exist!", http.StatusBadRequest)
		return
	}

	_, err = db.Query("INSERT INTO instructors(full_name, bio,  photo, username, course_id) VALUES($1, $2, $3, $4, $5)",
		fullname,
		bio,
		fmt.Sprintf("stdpath_%s", username),
		username,
		course_id_parsed,
	)

	if err != nil {
		log.Println(err)
		http.Error(w, "Internal Error", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)

}

func GetInstructors(w http.ResponseWriter, r *http.Request, db *sql.DB) {

	rows, err := db.Query("SELECT * FROM instructors")

	if err != nil {
		log.Println(err)
		http.Error(w, "Internal Error", http.StatusInternalServerError)
		return
	}

	var instructors []model.Instructor

	for rows.Next() {
		var instructor model.Instructor

		err = rows.Scan(&instructor.InstructorId,
			&instructor.FullName,
			&instructor.Bio,
			&instructor.Photo,
			&instructor.Username,
			&instructor.CourseId,
		)

		if err != nil {
			log.Println(err)
		}
		instructors = append(instructors, instructor)
	}

	dump, err := json.Marshal(instructors)

	if err != nil {
		log.Println(err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(dump)
}
