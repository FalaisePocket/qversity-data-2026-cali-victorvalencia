from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.sensors.filesystem import FileSensor
from datetime import datetime
import requests
import psycopg2
import json
import os
from dotenv import load_dotenv
import sys
sys.path.append("/opt/airflow")

from spark.dedup_nested_arrays import bronze_to_silver
from scripts.ingestFromSource import ingest_from_source, load_to_postgres


S3_URL = " https://qversity-raw-public-data.s3.amazonaws.com/fintech_banking_dataset.json"
LOCAL_FILE = "/opt/airflow/data/raw/fintech_banking_dataset.json"



with DAG(
    dag_id="qversity_DAG",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@once",
    catchup=False,
    is_paused_upon_creation=False
) as dag:
    #download data from s3 and save it to local file system
    task_download = PythonOperator(
        task_id="download_from_source",
        python_callable=ingest_from_source,
    )
    #check if the file is available in the local file system
    check_download = FileSensor(
        task_id="wait_for_file",
        filepath=LOCAL_FILE,
        poke_interval=10,
        timeout=300,
    )
    #load the data from the local file system to postgres bronze schema
    task_load = PythonOperator(
        task_id="load_to_postgres_bronze",
        python_callable=load_to_postgres,
    )
    #transform the data from bronze to silver using spark and 
    # finally load it to postgres silver schema
    task_bronze_to_silver_spark = PythonOperator(
        task_id="bronze_to_silver",
        python_callable=bronze_to_silver,
    )
    #Execute dbt transformations to normalize the silver data and create gold tables
    silver_normalization_dbt = BashOperator(
        task_id="silver_normalization_dbt",
        bash_command="""
        docker exec dbt bash -c "
            cd /dbt &&
            dbt deps &&
            dbt run --profiles-dir /dbt --target dev
        "
        """
    )


    #ingesting data and staging it to bronze
    task_download >> check_download >> task_load
    #ingesting data from bronze, transforming it and 
    #staging it to silver
    task_load >> task_bronze_to_silver_spark


    task_bronze_to_silver_spark >> silver_normalization_dbt



