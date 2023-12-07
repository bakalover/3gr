-- Tables
CREATE TABLE Lang (
    lang_level varchar(2) PRIMARY KEY,
    descript TEXT NOT NULL
);
CREATE TABLE Resources(
    resourse_id SERIAL PRIMARY KEY,
    descript TEXT NOT NULL,
    link TEXT NOT NULL,
    lang_level varchar(2) REFERENCES Lang(lang_level) ON DELETE CASCADE
);
CREATE TABLE Course(
    course_id SERIAL PRIMARY KEY,
    descript TEXT,
    start_d DATE,
    end_d DATE,
    lang_level varchar(2) REFERENCES Lang(lang_level) ON DELETE CASCADE
);
CREATE TABLE Lesson(
    lesson_id SERIAL PRIMARY KEY,
    title varchar(30),
    descript TEXT NOT NULL,
    content TEXT NOT NULL,
    course_id INTEGER REFERENCES Course(course_id) ON DELETE CASCADE
);
CREATE TABLE Quiz(
    quiz_id SERIAL PRIMARY KEY,
    descript TEXT NOT NULL,
    time_slice SMALLINT NOT NULL CHECK (time_slice >= 60),
    lesson_id INTEGER REFERENCES Lesson(lesson_id) ON DELETE CASCADE
);
CREATE TABLE Cards(
    card_id SERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    answers TEXT [4] NOT NULL,
    ans SMALLINT CHECK(
        ans BETWEEN 1 AND 4
    ),
    quiz_id INTEGER REFERENCES Quiz(quiz_id) ON DELETE CASCADE
);
CREATE TABLE Users(
    username varchar(20) PRIMARY KEY,
    pass BYTEA NOT NULL,
    is_admin BOOLEAN NOT NULL
);
CREATE TABLE Instructor(
    instructor_id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    bio TEXT NOT NULL,
    photo TEXT UNIQUE,
    username varchar(20) REFERENCES Users(username) ON DELETE CASCADE,
    course_id INTEGER REFERENCES Course(course_id) ON DELETE CASCADE
);
CREATE TABLE Groups(
    group_id SERIAL PRIMARY KEY,
    group_number SMALLINT NOT NULL,
    faculty varchar(10) NOT NULL
);
CREATE TABLE Student(
    student_id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    photo TEXT UNIQUE,
    group_id INTEGER REFERENCES Groups(group_id) ON DELETE CASCADE,
    username varchar(20) REFERENCES Users(username) ON DELETE CASCADE
);
CREATE TABLE Topic(
    topic_id SERIAL PRIMARY KEY,
    post_count SMALLINT CHECK(post_count >= 0),
    descript TEXT
);
CREATE TABLE Post(
    post_id SERIAL PRIMARY KEY,
    content text NOT NULL,
    username varchar(20) REFERENCES Users(username) ON DELETE CASCADE,
    topic_id INTEGER REFERENCES Topic(topic_id) ON DELETE CASCADE
);
CREATE TABLE Payment(
    student_id INTEGER REFERENCES Student(student_id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES Course(course_id) ON DELETE CASCADE,
    amount INTEGER NOT NULL CHECK(amount >= 0),
    date TIMESTAMP NOT NULL,
    PRIMARY KEY(student_id, course_id)
);
CREATE TABLE Enrollment(
    student_id INTEGER REFERENCES Student(student_id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES Course(course_id) ON DELETE CASCADE,
    enrollment_d TIMESTAMP,
    PRIMARY KEY(student_id, course_id)
);
CREATE TABLE Feedback(
    student_id INTEGER REFERENCES Student(student_id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES Course(course_id) ON DELETE CASCADE,
    feedback_val TEXT NOT NULL,
    PRIMARY KEY(student_id, course_id)
);
CREATE TABLE Progress(
    student_id INTEGER REFERENCES Student(student_id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES Course(course_id) ON DELETE CASCADE,
    progress_val SMALLINT NOT NULL CHECK(
        progress_val BETWEEN 0 and 100
    ),
    PRIMARY KEY(student_id, course_id)
);
-- Tables
-- Triggers
CREATE OR REPLACE FUNCTION check_payment() RETURNS TRIGGER AS $$ BEGIN IF EXISTS (
        SELECT 1
        FROM Payment
        WHERE student_id = NEW.student_id
            AND course_id = NEW.course_id
    ) THEN RETURN NEW;
ELSE RAISE EXCEPTION 'Student has not paid for the course!';
END IF;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER check_payment BEFORE
INSERT ON Enrollment FOR EACH ROW EXECUTE FUNCTION check_payment();
CREATE OR REPLACE FUNCTION course_complete_check() RETURNS TRIGGER AS $$ BEGIN IF EXISTS (
        SELECT 1
        FROM Progress
        WHERE course_id = NEW.course_id
            and value = 100
    ) THEN RETURN NEW;
ELSE RAISE EXCEPTION 'Feedback is not available until course is finished!';
END IF;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER course_complete_check BEFORE
INSERT ON Feedback FOR EACH ROW EXECUTE FUNCTION course_complete_check();
-- Triggers
-- Just functions
CREATE OR REPLACE FUNCTION complete_lesson(lesson_id_arg INTEGER, student_arg INTEGER) RETURNS void AS $$
DECLARE course INTEGER;
lesson_number INTEGER;
BEGIN
SELECT course_id INTO course
FROM Lesson
WHERE lesson_id = lesson_id_arg;
SELECT count(*) INTO lesson_number
FROM Lesson
WHERE course_id = course;
UPDATE Progress
SET progress_val = progress_val + (0.6 * (100.0 / lesson_number))
where course_id = course
    and student_id = student_arg;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION complete_quiz(lesson_id_arg INTEGER, student_arg INTEGER) RETURNS void AS $$
DECLARE course INTEGER;
lesson_number INTEGER;
BEGIN
SELECT course_id INTO course
FROM Lesson
WHERE lesson_id = lesson_id_arg;
SELECT count(*) INTO lesson_number
FROM Lesson
WHERE course_id = course;
UPDATE Progress
SET progress_val = progress_val + (0.4 * (100.0 / lesson_number))
where course_id = course
    and student_id = student_arg;
END;
$$ LANGUAGE plpgsql;
-- Just functions