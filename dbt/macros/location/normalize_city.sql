{% macro normalize_city(column_name) %}

CASE LOWER(TRIM({{ column_name }}))

    -- Mexico
    WHEN 'ciudad de mexico' THEN 'Ciudad de Mexico'
    WHEN 'ciudd de mexico' THEN 'Ciudad de Mexico'

    -- Colombia
    WHEN 'bogta' THEN 'Bogota'
    WHEN 'bogota' THEN 'Bogota'
    WHEN 'medelin' THEN 'Medellin'
    WHEN 'medellin' THEN 'Medellin'
    WHEN 'barranquila' THEN 'Barranquilla'
    WHEN 'barranquilla' THEN 'Barranquilla'
    WHEN 'cartagna' THEN 'Cartagena'
    WHEN 'cartagena' THEN 'Cartagena'
    WHEN 'cai' THEN 'Cali'
    WHEN 'cali' THEN 'Cali'
    WHEN 'arequpa' THEN 'Arequipa'
    WHEN 'arequipa' THEN 'Arequipa'

    -- Peru
    WHEN 'lma' THEN 'Lima'
    WHEN 'lima' THEN 'Lima'
    WHEN 'cusco' THEN 'Cusco'
    WHEN 'cusc' THEN 'Cusco'
    WHEN 'piua' THEN 'Piura'
    WHEN 'piura' THEN 'Piura'
    WHEN 'trujllo' THEN 'Trujillo'
    WHEN 'trujillo' THEN 'Trujillo'

    -- Chile
    WHEN 'santiago' THEN 'Santiago'
    WHEN 'santiag' THEN 'Santiago'
    WHEN 'valparaiso' THEN 'Valparaiso'
    WHEN 'temuco' THEN 'Temuco'
    WHEN 'temco' THEN 'Temuco'
    WHEN 'concepcion' THEN 'Concepcion'
    WHEN 'concepcin' THEN 'Concepcion'
    WHEN 'la serna' THEN 'La Serena'
    WHEN 'la serena' THEN 'La Serena'

    -- Argentina
    WHEN 'tucuman' THEN 'Tucuman'
    WHEN 'tucman' THEN 'Tucuman'
    WHEN 'rosaro' THEN 'Rosario'
    WHEN 'rosario' THEN 'Rosario'
    WHEN 'cordoba' THEN 'Cordoba'
    WHEN 'cordba' THEN 'Cordoba'
    WHEN 'mendoza' THEN 'Mendoza'
    WHEN 'mendza' THEN 'Mendoza'
    WHEN 'buenos aires' THEN 'Buenos Aires'
    WHEN 'buenos aire' THEN 'Buenos Aires'

    -- Brazil
    WHEN 'sao paulo' THEN 'Sao Paulo'
    WHEN 'sao paulp' THEN 'Sao Paulo'
    WHEN 'brasilia' THEN 'Brasilia'
    WHEN 'brasila' THEN 'Brasilia'
    WHEN 'fortaleza' THEN 'Fortaleza'
    WHEN 'fortalza' THEN 'Fortaleza'

    -- Uruguay
    WHEN 'montevideo' THEN 'Montevideo'
    WHEN 'montevide' THEN 'Montevideo'
    WHEN 'salto' THEN 'Salto'
    WHEN 'saltp' THEN 'Salto'
    WHEN 'rivera' THEN 'Rivera'
    WHEN 'rivra' THEN 'Rivera'
    WHEN 'paysandu' THEN 'Paysandu'
    WHEN 'paysand' THEN 'Paysandu'
    WHEN 'maldonado' THEN 'Maldonado'
    WHEN 'maldonad' THEN 'Maldonado'

    -- fallback
    ELSE INITCAP(TRIM({{ column_name }}))

END

{% endmacro %}