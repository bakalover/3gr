package chat

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"server/model"
	"strconv"
	"time"
)

func CheckReverseExistense(db *sql.DB, first string, second string) (bool, error) {
	res1, _ := db.Query("SELECT * FROM chats WHERE first_user = $1 AND first_user = $2", first, second)
	res2, err := db.Query("SELECT * FROM chats WHERE first_user = $2 AND first_user = $1", first, second)
	return res1.Next() || res2.Next(), err
}

func CheckChatExistense(db *sql.DB, chat_id int16) (bool, error) {
	res, err := db.Query("SELECT * FROM chats WHERE chat_id = $1", chat_id)
	return res.Next(), err
}

func CreateChat(w http.ResponseWriter, r *http.Request, db *sql.DB, first_user string, second_user string) {

	check, _ := CheckReverseExistense(db, first_user, second_user)

	if check {
		http.Error(w, "Char Exist!", http.StatusBadRequest)
		return
	}
	_, err := db.Query("INSERT INTO chats(first_user, second_user) VALUES($1,$2)",
		first_user,
		second_user,
	)

	if err != nil {
		log.Println(err)
		http.Error(w, "Self chat!", http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusOK)

}

func AddMessage(w http.ResponseWriter, r *http.Request, db *sql.DB, content string, from_user string, chat_id string) {
	chat_id_parsed, _ := strconv.Atoi(chat_id)

	check, err := CheckChatExistense(db, int16(chat_id_parsed))

	if err != nil {
		log.Println(err)
		http.Error(w, "Internal Error", http.StatusInternalServerError)
		return
	}

	if !check {
		log.Println(err)
		http.Error(w, "Chat does not exist!", http.StatusBadRequest)
		return
	}

	_, err = db.Query("INSERT INTO messages(content, from_user, message_date, chat_id) VALUES($1,$2,$3,$4)",
		content,
		from_user,
		time.Now(),
		chat_id_parsed,
	)

	if err != nil {
		log.Println(err)
		http.Error(w, "Internal Error", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)

}

func GetChatMessage(w http.ResponseWriter, r *http.Request, db *sql.DB, chat_id string) {
	chat_id_parsed, _ := strconv.Atoi(chat_id)

	check, err := CheckChatExistense(db, int16(chat_id_parsed))

	if err != nil {
		log.Println(err)
		http.Error(w, "Internal Error", http.StatusInternalServerError)
		return
	}

	if !check {
		log.Println(err)
		http.Error(w, "Chat does not exist!", http.StatusBadRequest)
		return
	}

	rows, err := db.Query("SELECT * FROM messages WHERE chat_id = $1",
		chat_id_parsed,
	)

	if err != nil {
		log.Println(err)
		http.Error(w, "Internal Error", http.StatusInternalServerError)
		return
	}

	var messages []model.Message
	for rows.Next() {
		var message model.Message
		err = rows.Scan(&message.ChatId, &message.From, &message.MessageDate, &message.Content, &message.ChatId)
		if err != nil {
			log.Println(err)
		}
		messages = append(messages, message)
	}

	dump, err := json.Marshal(messages)

	if err != nil {
		log.Println(err)
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(dump)
}
