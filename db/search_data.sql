create table s335162.student(
  a integer,
  b integer
);

CREATE FUNCTION s335162.check_password(uname TEXT, pass TEXT)
RETURNS BOOLEAN AS $$
DECLARE passed BOOLEAN;
BEGIN
        SELECT  (pwd = $2) INTO passed
        FROM    pwds
        WHERE   username = 'STUDENT';

        RETURN passed;
END;
$$  LANGUAGE plpgsql;


CREATE PROCEDURE s335162.insert_data(a integer, b integer)
LANGUAGE SQL
AS $$
INSERT INTO s335162.student VALUES (a);
$$;

    
CREATE TABLE s335162.test_table(
  name text primary key
);
    
CREATE OR REPLACE FUNCTION s335162.search_trigger_test()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.name = 'StUdEnT' THEN
    END IF;
    
    RETURN NEW;
END;
$$
 LANGUAGE plpgsql;

CREATE TRIGGER test_trigger
BEFORE INSERT OR UPDATE ON s335162.test_table
FOR EACH ROW
EXECUTE FUNCTION s335162.search_trigger_test();
