DROP FUNCTION complete_lesson;
DROP TRIGGER check_payment ON Enrollment;
DROP TRIGGER course_complete_check ON Feedback;
DROP TABLE Progress CASCADE;
DROP TABLE Feedback CASCADE;
DROP TABLE Enrollment CASCADE;
DROP TABLE Payment CASCADE;
DROP TABLE Post CASCADE;
DROP TABLE Topic CASCADE;
DROP TABLE Student CASCADE;
DROP TABLE Groups CASCADE;
DROP TABLE Instructor CASCADE;
DROP TABLE Users CASCADE;
DROP TABLE Cards CASCADE;
DROP TABLE Quiz CASCADE;
DROP TABLE Lesson CASCADE;
DROP TABLE Course CASCADE;
DROP TABLE Resources CASCADE;
DROP TABLE Lang CASCADE;