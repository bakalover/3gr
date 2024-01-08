package model

import (
	"time"
)

type Lang struct {
	LangLevel string
	Descript   string
}

type LangResourse struct {
	ResourceId uint32
	Descript    string
	Link        string
	LangLevel  string
}

type Course struct {
	CourseId  uint32
	Descript   string
	StartDate   time.Time
	EndDate     time.Time
	LangLevel string
}

type Lesson struct {
	LessonId uint32
	Title     string
	Descript  string
	Content   string
	CourseId uint32
}

type Quiz struct {
	QuizId   uint32
	Descript  string
	Timeslice uint16
	LessonId uint32
}

type Card struct {
	CardId  uint32
	Question string
	Answers  [4]string
	TrueAns      uint8
	QuizId uint32
}

type User struct {
	Username string
	Password []byte
	IsAdmin bool
}

type Instructor struct {
	InstructorId uint32
	FullName     string
	Bio           string
	Photo         string
	Username      string
	CourseId     uint32
}

type Group struct {
	GroupId     uint32
	GroupNumber uint8
	Faculcy      string
}

type Student struct {
	StudentID   uint32
	FullName    string
	Photo       string
	GroupNumber int16
	Username    string
}

type Topic struct {
	TopicName string
	PostCount uint8
	Descript  string
}

type Post struct {
	PostId    uint32
	Content   string
	Username  string
	TopicName string
}

type Payment struct {
	StudentId uint32
	CourseId  uint32
	Amount    uint32
	PayDate   time.Time
}

type Enrollment struct {
	StudentId   uint32
	CourseId    uint32
	EnrollDate time.Time
}

type Feedback struct {
	StudentId   uint32
	CourseId    uint32
	FeedbackVal string
}

type Progress struct {
	StudentId   uint32
	CourseId    uint32
	ProgressVal uint8
}
