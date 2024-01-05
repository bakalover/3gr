-- Tables
CREATE TABLE langs (
    lang_level varchar(2) PRIMARY KEY,
    descript TEXT NOT NULL
);
CREATE TABLE lang_resources(
    resourse_id SERIAL PRIMARY KEY,
    descript TEXT NOT NULL,
    link TEXT NOT NULL,
    lang_level varchar(2) REFERENCES langs(lang_level) ON DELETE CASCADE
);
CREATE TABLE courses(
    course_id SERIAL PRIMARY KEY,
    descript TEXT,
    start_d DATE,
    end_d DATE,
    lang_level varchar(2) REFERENCES langs(lang_level) ON DELETE CASCADE
);
CREATE TABLE lessons(
    lesson_id SERIAL PRIMARY KEY,
    title varchar(30),
    descript TEXT NOT NULL,
    content TEXT NOT NULL,
    course_id INTEGER REFERENCES courses(course_id) ON DELETE CASCADE
);
CREATE TABLE quizzes(
    quiz_id SERIAL PRIMARY KEY,
    descript TEXT NOT NULL,
    time_slice SMALLINT NOT NULL CHECK (time_slice >= 60),
    lesson_id INTEGER REFERENCES lessons(lesson_id) ON DELETE CASCADE
);
CREATE TABLE cards(
    card_id SERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    answers TEXT [4] NOT NULL,
    ans SMALLINT CHECK(
        ans BETWEEN 1 AND 4
    ),
    quiz_id INTEGER REFERENCES quizzes(quiz_id) ON DELETE CASCADE
);
CREATE TABLE users(
    username varchar(20) PRIMARY KEY,
    pass BYTEA NOT NULL,
    is_admin BOOLEAN NOT NULL
);
CREATE TABLE instructors(
    instructor_id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    bio TEXT NOT NULL,
    photo TEXT UNIQUE,
    username varchar(20) REFERENCES users(username) ON DELETE CASCADE,
    course_id INTEGER REFERENCES courses(course_id) ON DELETE CASCADE
);
CREATE TABLE groups(
    group_number SMALLINT PRIMARY KEY,
    faculty varchar(10) NOT NULL
);
CREATE TABLE students(
    student_id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    photo TEXT UNIQUE,
    group_number INTEGER REFERENCES groups(group_number) ON DELETE CASCADE,
    username varchar(20) REFERENCES users(username) ON DELETE CASCADE
);
CREATE TABLE topics(
    topic_name TEXT PRIMARY KEY,
    post_count SMALLINT CHECK(post_count >= 0),
    descript TEXT
);
CREATE TABLE posts(
    post_id SERIAL PRIMARY KEY,
    content text NOT NULL,
    username varchar(20) REFERENCES users(username) ON DELETE CASCADE,
    topic_name TEXT REFERENCES topics(topic_name) ON DELETE CASCADE
);
CREATE TABLE payments(
    student_id INTEGER REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES courses(course_id) ON DELETE CASCADE,
    amount INTEGER NOT NULL CHECK(amount >= 0),
    payment_date TIMESTAMP NOT NULL,
    PRIMARY KEY(student_id, course_id)
);
CREATE TABLE enrollments(
    student_id INTEGER REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES courses(course_id) ON DELETE CASCADE,
    enrollment_d TIMESTAMP,
    PRIMARY KEY(student_id, course_id)
);
CREATE TABLE feedbacks(
    student_id INTEGER REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES courses(course_id) ON DELETE CASCADE,
    feedback_val TEXT NOT NULL,
    PRIMARY KEY(student_id, course_id)
);
CREATE TABLE progress(
    student_id INTEGER REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES courses(course_id) ON DELETE CASCADE,
    progress_val SMALLINT NOT NULL CHECK(
        progress_val BETWEEN 0 and 100
    ),
    PRIMARY KEY(student_id, course_id)
);
CREATE TABLE chats(
    chat_id SERIAL PRIMARY KEY,
    first_user VARCHAR(20) REFERENCES users(username),
    second_user VARCHAR(20) REFERENCES users(username),
    CHECK(first_user != second_user)
);
CREATE TABLE messages(
    message_id BIGSERIAL PRIMARY KEY,
    message_date TIMESTAMP,
    content text,
    chat_id INTEGER REFERENCES chats(chat_id)
);
-- Tables
-- Triggers
CREATE OR REPLACE FUNCTION check_payment() RETURNS TRIGGER AS $$ BEGIN IF EXISTS (
        SELECT 1
        FROM payments
        WHERE student_id = NEW.student_id
            AND course_id = NEW.course_id
    ) THEN RETURN NEW;
ELSE RAISE EXCEPTION 'Student has not paid for the course!';
END IF;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER check_payment BEFORE
INSERT ON enrollments FOR EACH ROW EXECUTE FUNCTION check_payment();
CREATE OR REPLACE FUNCTION course_complete_check() RETURNS TRIGGER AS $$ BEGIN IF EXISTS (
        SELECT 1
        FROM progress
        WHERE course_id = NEW.course_id
            and progress_val = 100
    ) THEN RETURN NEW;
ELSE RAISE EXCEPTION 'Feedback is not available until course is finished!';
END IF;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER course_complete_check BEFORE
INSERT ON feedbacks FOR EACH ROW EXECUTE FUNCTION course_complete_check();
-- Triggers
-- Just functions
CREATE OR REPLACE FUNCTION complete_lesson(lesson_id_arg INTEGER, student_arg INTEGER) RETURNS void AS $$
DECLARE course INTEGER;
lesson_number INTEGER;
BEGIN
SELECT course_id INTO course
FROM lessons
WHERE lesson_id = lesson_id_arg;
SELECT count(*) INTO lesson_number
FROM lessons
WHERE course_id = course;
UPDATE progress
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
FROM lessons
WHERE lesson_id = lesson_id_arg;
SELECT count(*) INTO lesson_number
FROM lessons
WHERE course_id = course;
UPDATE progress
SET progress_val = progress_val + (0.4 * (100.0 / lesson_number))
where course_id = course
    and student_id = student_arg;
END;
$$ LANGUAGE plpgsql;
-- Just functions
-- Index
CREATE INDEX student_id_index ON students USING HASH (student_id);
-- Index