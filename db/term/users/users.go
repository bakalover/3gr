package users

import (
	"bytes"
	"crypto/sha256"
	"database/sql"
	"net/http"
)

func CheckExistense(username string, db *sql.DB) (bool, error) {
	res, err := db.Query("SELECT * FROM users WHERE username = $1", username)
	return res.Next(), err
}

func Register(w http.ResponseWriter, r *http.Request, db *sql.DB, username string, password string) {
	check, err := CheckExistense(username, db)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	} else {
		if check {
			http.Error(w, "User already exists!", http.StatusBadRequest)
		} else {
			_, err = db.Query("INSERT INTO users(username, pass, is_admin) VALUES($1, sha256($2::bytea), $3)",
				username,
				password,
				false,
			)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
			} else {
				w.WriteHeader(http.StatusOK)
			}
		}
	}
}

func CheckPassword(username string, password string, db *sql.DB) bool {
	var true_password []byte
	password_hash := sha256.Sum256([]byte(password))
	db.QueryRow("SELECT pass FROM users WHERE username = $1", username).Scan(&true_password)
	return bytes.Equal(password_hash[:], true_password)
}

func Login(w http.ResponseWriter, r *http.Request, db *sql.DB, username string, password string) {
	check, err := CheckExistense(username, db)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	} else {
		if !check {
			http.Error(w, "User does not exist", http.StatusBadRequest)
		} else {
			if CheckPassword(username, password, db) {
				w.WriteHeader(http.StatusOK)
			} else {
				http.Error(w, "Password mismatch", http.StatusBadRequest)
			}
		}
	}
}
