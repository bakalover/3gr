INSERT INTO langs(lang_level, descript)
VALUES ('C1', 'Advanced eng');
INSERT INTO langs(lang_level, descript)
VALUES ('A2', 'Beginner eng');
INSERT INTO courses(descript, start_d, end_d, lang_level)
VALUES(
        'end course for fun',
        '2017-03-14',
        '2017-04-15',
        'C1'
    );
INSERT INTO courses(descript, start_d, end_d, lang_level)
VALUES(
        'English for babies',
        '2010-03-14',
        '2011-04-15',
        'A2'
    );
INSERT INTO users(username, pass, is_admin)
VALUES('perry', sha256('perry')::bytea, true);
INSERT INTO users(username, pass, is_admin)
VALUES('I1', sha256('asldkkj123')::bytea, false);
INSERT INTO users(username, pass, is_admin)
VALUES('I2', sha256('12345')::bytea, false);
INSERT INTO instructors(full_name, bio, photo, username, course_id)
VALUES(
        'James Ghol',
        'Hello currently getting master degree',
        'stdpathI1',
        'I1',
        1
    );
INSERT INTO instructors(full_name, bio, photo, username, course_id)
VALUES(
        'Maria Anderson',
        'Ready for best practice in English!',
        'stdpathI2',
        'I2',
        2
    );
INSERT INTO lessons(title, descript, content, course_id)
VALUES (
        'nice lesson',
        'eng lesson number 1',
        '/path/',
        1
    );