package model

import "github.com/jackc/pgx/v5/pgtype"

type Lang struct {
	lang_level string
	descript   string
}

type LangResourse struct {
	resourse_id uint32
	descript    string
	link        string
	lang_level  string
}

type Course struct {
	course_id  uint32
	descript   string
	start_d    pgtype.Date
	end_d      pgtype.Date
	lang_level string
}

type Lesson struct {
	lesson_id uint32
	title     string
	descript  string
	content   string
	course_id uint32
}

type Quiz struct {
	quiz_if uint32
	descript string
	timeslice uint16
	lesson_id uint32
}

type Card struct{
	card_id uint32
	question string
	answers [4]string
	ans uint8
	quiz_id  uint32
}

type User struct {
	username string
	password []byte
	is_admin bool
}

type Instructor struct{
	instructor_id uint32
	full_name string
	bio string
	photo string
	username string
	course_id uint32
}

type Group struct{
	group_id uint32
	group_number uint8
	faculcy string
}

type Student struct{
	student_id uint32
	full_name string
	photo string
	group_id uint32
	usename string
}

type Topic struct{
	topic_id uint32
	post_count uint8
	descript string
}

type Post struct{
	post_id uint32
	content string
	username string
	topic_id uint32
}

type Payment struct{
	student_id uint32
	course_id uint32
	amount uint32
	payment_date pgtype.Time
}

type Enrollment struct{
	student_id uint32
	course_id uint32
	enrollment_d pgtype.Date
}

type Feedback struct{
	student_id uint32
	course_id uint32
	feedback_val string
}

type Progress struct{
	student_id uint32
	course_id uint32
	progress_val uint8
}