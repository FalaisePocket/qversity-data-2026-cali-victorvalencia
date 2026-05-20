{% macro add_country_code(phone_col, country_col) %}

CASE
    WHEN length(regexp_replace({{ phone_col }}, '[^0-9]', '', 'g')) = 10 THEN
        CASE {{ country_col }}
            WHEN 'CO' THEN '+57' || {{ phone_col }}
            WHEN 'UY' THEN '+598' || {{ phone_col }}
            WHEN 'AR' THEN '+54' || {{ phone_col }}
            WHEN 'MX' THEN '+52' || {{ phone_col }}
            WHEN 'CL' THEN '+56' || {{ phone_col }}
            WHEN 'PE' THEN '+51' || {{ phone_col }}
            WHEN 'BR' THEN '+55' || {{ phone_col }}
            ELSE {{ phone_col }}
        END

    WHEN length(regexp_replace({{ phone_col }}, '[^0-9]', '', 'g')) > 10 THEN
        {{ phone_col }}

    ELSE
        {{ phone_col }}
END

{% endmacro %}