INSERT INTO Lang(lang_level, descript)
VALUES ('c1', 'just eng');
INSERT INTO Course(descript, start_d, end_d, lang_level)
VALUES(
        'end course for fun',
        '2017-03-14',
        '2017-04-15',
        'c1'
    );
INSERT INTO Lesson(title, descript, content, course_id)
VALUES (
        'nice lesson',
        'eng lesson number 1',
        '/path/',
        1
    );
INSERT INTO Users(username, pass, is_admin)
VALUES('john', 'asdsad'::bytea, true);
INSERT INTO Groups(group_number, faculty)
VALUES(123, 'RNauh');
INSERT INTO Student(full_name, photo, group_id, username)
VALUES('john_name', '/path/', 1, 'john');
INSERT INTO Progress(student_id, course_id, progress_val)
VALUES(1, 1, 0);
SELECT complete_lesson(1, 1);