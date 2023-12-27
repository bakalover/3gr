package stud

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"server/model"
	"strconv"
)

func CheckGroupExistence(db *sql.DB, group_number int16) (bool, error) {
	rows, err := db.Query("SELECT * FROM groups where group_number = $1", group_number)
	return rows.Next(), err
}

func CreateGroup(w http.ResponseWriter, r *http.Request, db *sql.DB, number string, faculcy string) {
	group_number, err := strconv.Atoi(number)

	if err != nil {
		http.Error(w, "Invalid group number", http.StatusBadRequest)
		return
	}

	check, err := CheckGroupExistence(db, int16(group_number))

	if err != nil {
		log.Println(err.Error())
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}

	if check {
		http.Error(w, "Group with given number already exists!", http.StatusBadRequest)
		return
	}

	_, err = db.Query("INSERT INTO groups(group_number, faculty) VALUES($1,$2)",
		group_number,
		faculcy,
	)

	if err != nil {
		log.Println(err.Error())
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}

}

func AddStudent(w http.ResponseWriter, r *http.Request, db *sql.DB, fullname string, group_number string, username string) {
	group_number_parsed, err := strconv.Atoi(group_number)

	if err != nil {
		http.Error(w, "Invalid group number", http.StatusBadRequest)
		return
	}

	check, err := CheckGroupExistence(db, int16(group_number_parsed))

	if err != nil {
		log.Println(err.Error())
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}

	if !check {
		http.Error(w, "Group with given number does not exist!", http.StatusBadRequest)
		return
	}

	_, err = db.Query("INSERT INTO students(full_name, photo, group_number, username) VALUES($1,'std_path', $2, $3)",
		fullname,
		group_number_parsed,
		username,
	)

	if err != nil {
		log.Println(err.Error())
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}

}

func GetStudentsByGroup(w http.ResponseWriter, r *http.Request, db *sql.DB, group_number string) {
	group_number_parsed, err := strconv.Atoi(group_number)

	if err != nil {
		http.Error(w, "Invalid group number", http.StatusBadRequest)
		return
	}

	rows, err := db.Query("SELECT * FROM students where group_number = $1",
		group_number_parsed,
	)

	if err != nil {
		log.Println(err.Error())
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}

	var students []model.Student

	for rows.Next() {
		var student model.Student

		err = rows.Scan(&student.StudentID,
			&student.FullName,
			&student.Photo,
			&student.GroupNumber,
			&student.Username,
		)

		if err != nil {
			log.Println(err)
		}
		students = append(students, student)
	}

	dump, err := json.Marshal(students)

	if err != nil {
		log.Println(err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(dump)
}
