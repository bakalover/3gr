package forum

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"server/model"

	"github.com/jackc/pgx/v5/pgxpool"
)

func CheckExistense(db *pgxpool.Pool, topic string) (bool, error) {
	res, err := db.Query(context.Background(), "SELECT * FROM topics WHERE topic_name = $1", topic)
	return res.Next(), err
}

func CreateTopic(w http.ResponseWriter, r *http.Request, db *pgxpool.Pool, topic string, descript string) {
	exist, err := CheckExistense(db, topic)
	if err != nil {
		log.Println(err)
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}

	if exist {
		http.Error(w, "Topic already exists!", http.StatusBadRequest)
	} else {
		_, err := db.Query(context.Background(),
			"INSERT INTO topics(topic_name, post_count, descript) VALUES($1, 0, $2)",
			topic,
			descript,
		)
		if err != nil {
			log.Println(err)
			http.Error(w, "Error", http.StatusInternalServerError)
		} else {
			w.WriteHeader(http.StatusOK)
		}
	}

}

func GetTopic(w http.ResponseWriter, r *http.Request, db *pgxpool.Pool, topic string) {
	exist, err := CheckExistense(db, topic)
	if err != nil {
		log.Println(err)
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}
	if exist {
		var topic model.Topic
		err := db.QueryRow(context.Background(), "SELECT * FROM topics WHERE topic_name = $1", topic).Scan(
			&topic.TopicName,
			&topic.PostCount,
			&topic.Descript,
		)

		if err != nil {
			log.Println(err)
			http.Error(w, "Error", http.StatusInternalServerError)
			return
		}

		dump, err := json.Marshal(topic)
		if err != nil {
			log.Println(err)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.Write(dump)
	} else {
		http.Error(w, "Topic doesn't exists!", http.StatusBadRequest)
	}

}

func GetAllTopics(w http.ResponseWriter, r *http.Request, db *pgxpool.Pool) {

	var topics []model.Topic

	rows, err := db.Query(context.Background(), "SELECT * FROM topics")

	if err != nil {
		log.Println(err)
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}

	for rows.Next() {
		var topic model.Topic
		err = rows.Scan(&topic.TopicName, &topic.PostCount, &topic.Descript)
		if err != nil {
			log.Println(err)
		}
		topics = append(topics, topic)
	}

	dump, err := json.Marshal(topics)

	if err != nil {
		log.Println(err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(dump)

}
