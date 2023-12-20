package users

import (
	"context"
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"
)

func AddNewUser(w http.ResponseWriter, r *http.Request, db *pgxpool.Pool) {
	_, err := db.Query(context.Background(), "INSERT INTO users(username, pass, is_admin) VALUES($1, sha256($2::bytea), $3)",
		r.FormValue("username"),
		r.FormValue("password"),
		false,
	)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
	} else {
		w.WriteHeader(http.StatusOK)
	}

}
