CREATE OR REPLACE PROCEDURE find_source(keyword TEXT, schem TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    fill_char TEXT := ' ';
    no_pad INT := 3;
    name_pad INT := 21;
    line_pad INT := 14;
    text_pad INT := 44;

    rec RECORD;
BEGIN

    RAISE INFO '
   Текст запроса: %

                            No. Имя объекта           # строки       Текст
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
            WHERE pg_namespace.nspname = schem
        ) object_lines
        WHERE position(lower(keyword) in lower(source_code)) > 0
        ORDER BY line_num
    LOOP
        RAISE INFO ' % % % %', 
      RPAD(rec.object_num::TEXT,no_pad,fill_char),
      RPAD(rec.object_name::TEXT,name_pad,fill_char),
      RPAD(rec.line_num::TEXT,line_pad,fill_char),
      RPAD(TRIM(rec.source_code::TEXT), text_pad,fill_char);
    END LOOP;
END;
$$;

call find_source('student', 's335162');
-- drop procedure find_source;
