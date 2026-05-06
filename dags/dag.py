from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.sensors.filesystem import FileSensor
from datetime import datetime
import requests
import psycopg2
import json
import os
from dotenv import load_dotenv

S3_URL = " https://qversity-raw-public-data.s3.amazonaws.com/fintech_banking_dataset.json"
LOCAL_FILE = "/opt/airflow/data/raw/fintech_banking_dataset.json"


load_dotenv()

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

    
    cursor.execute("""
        CREATE SCHEMA IF NOT EXISTS bronze;
    """)
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


#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################










#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
with DAG(
    dag_id="s3_to_bronze_pipeline",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@once",
    catchup=False,
    is_paused_upon_creation=False
) as dag:

    task_download = PythonOperator(
        task_id="download_from_source",
        python_callable=ingest_from_source,
    )

    check_download = FileSensor(
        task_id="wait_for_file",
        filepath=LOCAL_FILE,
        poke_interval=10,
        timeout=300,
    )

    task_load = PythonOperator(
        task_id="load_to_postgres_bronze",
        python_callable=load_to_postgres,
    )

    task_download >> check_download >> task_load