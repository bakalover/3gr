package forum

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"server/model"
	"server/users"
)

func AddPost(w http.ResponseWriter, r *http.Request, db *sql.DB, topic string, username string, content string) {
	existTopic, err := CheckExistense(db, topic)
	if err != nil {
		log.Println(err.Error())
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	existUser, err := users.CheckExistense(username, db)
	if err != nil {
		log.Println(err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	if existTopic && existUser {
		db.QueryRow("INSERT INTO posts(content, username, topic_name) VALUES($1,$2,$3)",
			content,
			username,
			topic,
		)

		db.QueryRow("UPDATE topics SET post_count = post_count + 1 WHERE topic_name = $1",
			topic,
		)

	} else {
		http.Error(w, "Topic or User doesn't exist!", http.StatusBadRequest)
	}

}

func GetPosts(w http.ResponseWriter, r *http.Request, db *sql.DB, topic string, username string) {
	exist, err := CheckExistense(db, topic)
	if err != nil {
		log.Println(err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if exist {
		rows, err := db.Query("SELECT * FROM posts WHERE topic_name = $1 AND username = $2",
			topic,
			username,
		)

		if err != nil {
			log.Println(err)
		}

		var posts []model.Post
		for rows.Next() {
			var post model.Post
			err = rows.Scan(&post.PostId, &post.Content, &post.Username, &post.TopicName)
			if err != nil {
				log.Println(err)
			}
			posts = append(posts, post)
		}

		dump, err := json.Marshal(posts)

		if err != nil {
			log.Println(err)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.Write(dump)

	} else {
		http.Error(w, "Topic doesn't exist!", http.StatusBadRequest)
	}

}

func GetAllPosts(w http.ResponseWriter, r *http.Request, db *sql.DB) {
	rows, err := db.Query("SELECT * FROM posts")

	if err != nil {
		log.Println(err)
	}

	var posts []model.Post
	for rows.Next() {
		var post model.Post
		err = rows.Scan(&post.PostId, &post.Content, &post.Username, &post.TopicName)
		if err != nil {
			log.Println(err)
		}
		posts = append(posts, post)
	}

	dump, err := json.Marshal(posts)

	if err != nil {
		log.Println(err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(dump)

}
