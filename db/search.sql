CREATE OR REPLACE PROCEDURE find_source(keyword TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    schema TEXT := 's335162';
    fill_char TEXT := ' ';
    rec RECORD;
BEGIN

    RAISE INFO '
   Текст запроса: %

   No. Имя объекта         # строки   Текст
  --- -------------------   -------------  --------------------------------------------', 
  keyword;

    FOR rec IN
        SELECT row_number() OVER () AS object_num, object_name::TEXT, line_num::INT, source_code::TEXT
        FROM (
            SELECT pg_proc.proname AS object_name, 
                   generate_subscripts(string_to_array(pg_proc.prosrc, E'\n'), 1) AS line_num,
                   unnest(string_to_array(pg_proc.prosrc, E'\n')) AS source_code
            FROM pg_proc
            JOIN pg_namespace ON pg_proc.pronamespace = pg_namespace.oid
            WHERE pg_namespace.nspname = schema
        ) object_lines
        WHERE position(lower(keyword) in lower(source_code)) > 0
    LOOP
        RAISE INFO ' % % % %', 
      RPAD(rec.object_num::TEXT,3,fill_char),
      RPAD(rec.object_name::TEXT,21,fill_char),
      RPAD(rec.line_num::TEXT,14,fill_char),
      RPAD(TRIM(rec.source_code::TEXT), 44,fill_char);
    END LOOP;
END;
$$;

call find_source('student');
drop procedure find_source;
