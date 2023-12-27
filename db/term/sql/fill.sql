INSERT INTO Langs(lang_level, descript)
VALUES ('c1', 'just eng');
INSERT INTO Courses(descript, start_d, end_d, lang_level)
VALUES(
        'end course for fun',
        '2017-03-14',
        '2017-04-15',
        'c1'
    );
INSERT INTO Lessons(title, descript, content, course_id)
VALUES (
        'nice lesson',
        'eng lesson number 1',
        '/path/',
        1
    );
INSERT INTO Users(username, pass, is_admin)
VALUES('perry', sha256('asdsad')::bytea, true);