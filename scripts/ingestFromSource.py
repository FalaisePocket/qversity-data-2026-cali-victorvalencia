import requests
import psycopg2
import json
import os
import sys
sys.path.append("/opt/airflow")



S3_URL = " https://qversity-raw-public-data.s3.amazonaws.com/fintech_banking_dataset.json"
LOCAL_FILE = "/opt/airflow/data/raw/fintech_banking_dataset.json"



DB_CONFIG = {
    "host": os.getenv("POSTGRES_HOST", "postgres"),
    "database": os.getenv("POSTGRES_DB", "qversity"),
    "user": os.getenv("POSTGRES_USER", "qversity-admin"),
    "password": os.getenv("POSTGRES_PASSWORD", "qversity-admin"),
    "port": 5432,
}


def ingest_from_source():
    response = requests.get(S3_URL)
    response.raise_for_status()
    os.makedirs(os.path.dirname(LOCAL_FILE), exist_ok=True)
    with open(LOCAL_FILE, "w") as f:
        f.write(response.text)


def load_to_postgres():
    conn = psycopg2.connect(**DB_CONFIG)
    cursor = conn.cursor()

    
    cursor.execute("""CREATE SCHEMA IF NOT EXISTS bronze;""")
    cursor.execute("CREATE SCHEMA IF NOT EXISTS silver;")
    cursor.execute("CREATE SCHEMA IF NOT EXISTS gold;")

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS bronze.raw_fintech_data (
            id SERIAL PRIMARY KEY,
            data JSONB,
            load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    """)

    
    with open(LOCAL_FILE, "r") as f:
        data = json.load(f)

    if not isinstance(data, list):
        raise ValueError("El JSON no es una lista de objetos")


    records = [(json.dumps(item),) for item in data]
    
    cursor.executemany(
        "INSERT INTO bronze.raw_fintech_data (data) VALUES (%s)",
        records
    )

    conn.commit()
    cursor.close()
    conn.close()